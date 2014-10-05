//
//  TDGameScene.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameScene.h"

#import "TDMove.h"
#import "TDConstants.h"

@interface TDGameScene ()

@property BOOL contentCreated;
@property CGSize viewsize;
@property(strong, nonatomic) NSMutableArray *moves;
@property NSInteger score;

@end

@implementation TDGameScene

- (id) initWithViewSize: (CGSize)size andMoves: (NSMutableArray *)moves
{
    self = [super initWithSize:size];
    if (self)
    {
        self.viewsize = size;
        self.moves = moves;
        self.score = 0;
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
    [self addChild:[self createBackground]];
    
    for (TDMove *move in self.moves)
    {
        [self addChild: [self createMove:move]];
    }
}

- (SKSpriteNode *)createBackground
{
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"GameBG"];
    bg.position = CGPointMake(self.viewsize.width/2, self.viewsize.height/2);
    return bg;
}
         
- (SKSpriteNode *)createMove:(TDMove *)move
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:[move getNodePicName]];

    node.size = CGSizeMake(51, 51);
    node.position = [[move getNodePosition] CGPointValue];
    node.name = [move getNodeName];

    NSTimeInterval time = [move getTime];
    NSLog(@"time %f", time);
    SKAction *pause = [SKAction waitForDuration:[move getTime]];
    SKAction *moveUp = [SKAction moveByX:0 y:self.viewsize.height duration:5];
    SKAction *moveSeq = [SKAction sequence:@[pause, moveUp]];
    [node runAction:moveSeq completion:^{
        if ([move isCompleted]) {
            self.score += 1;
        }
        
        if ([move isLast]) {
            // do end move-y stuff
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:([defaults integerForKey:kTDScoreKey]+1) forKey:kTDScoreKey];
            [defaults synchronize];
        }
    }];
    return node;
}

@end
