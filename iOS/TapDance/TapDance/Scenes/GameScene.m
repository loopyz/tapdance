//
//  GameScene.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property BOOL contentCreated;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    //self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self createLabel:@"Hello"]];
}

- (SKSpriteNode *)createLabel: (NSString *)text
{
    CGSize viewsize = self.view.bounds.size;
    CGSize size = CGSizeMake(viewsize.width/2, viewsize.height/2);
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:size];
    node.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    node.name = text;
    return node;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"Hello"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [helloNode runAction: moveSequence];
    }
}

@end
