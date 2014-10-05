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
@property CGSize viewsize;

@end

@implementation GameScene

- (id) initWithViewSize: (CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.viewsize = size;
    }
    return self;
}

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
//    self.backgroundColor = [UIColor blueColor];
    //self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self createBackground]];
    [self addChild: [self createLabel:@"Hello"]];
}

- (SKSpriteNode *)createBackground
{
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"GameBG"];
    bg.position = CGPointMake(self.viewsize.width/2, self.viewsize.height/2);
    return bg;
}
- (SKSpriteNode *)createLabel: (NSString *)text
{
    CGSize size = CGSizeMake(self.viewsize.width/2, self.viewsize.height/2);
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
