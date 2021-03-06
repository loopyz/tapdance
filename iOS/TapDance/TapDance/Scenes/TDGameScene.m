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
@property NSInteger misses;
@property NSInteger good;
@property NSInteger great;
@property BOOL endedGame;

@property(strong, nonatomic) SKSpriteNode *left;
@property(strong, nonatomic) SKSpriteNode *right;
@property(strong, nonatomic) SKSpriteNode *up;
@property(strong, nonatomic) SKSpriteNode *down;

@property(strong, nonatomic) SKSpriteNode *missedText;
@property(strong, nonatomic) SKSpriteNode *goodText;
@property(strong, nonatomic) SKSpriteNode *greatText;

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
        self.misses = 0;
        self.good = 0;
        self.great = 0;
        self.endedGame = NO;
        // subscribing to early end notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endGame:) name:kTDEarlyEndToSceneNotification object:nil];
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
    
    self.left = [self createGoal:LEFT];
    self.right = [self createGoal:RIGHT];
    self.up = [self createGoal:UP];
    self.down = [self createGoal:DOWN];
    
    [self addChild:self.left];
    [self addChild:self.right];
    [self addChild:self.up];
    [self addChild:self.down];
    
    self.missedText = [self createText:@"MissedText"];
    self.goodText = [self createText:@"GoodText"];
    self.greatText = [self createText:@"GreatText"];
    
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

- (SKSpriteNode *)createGoal:(enum DIR)direction
{
    TDMove *move = [[TDMove alloc] init];
    SKSpriteNode *goal = [SKSpriteNode spriteNodeWithImageNamed:[move getNodePicName:direction]];
    goal.position = [[move getNodePosition:self.viewsize andDir:direction] CGPointValue];
    goal.size = CGSizeMake(51,51);
    goal.name = [NSString stringWithFormat:@"%@Move", [move getMoveDirName:direction]];
    return goal;
}

- (SKSpriteNode *)createText:(NSString *)textStr
{
    SKSpriteNode *text = [SKSpriteNode spriteNodeWithImageNamed:textStr];
    text.position = CGPointMake(self.viewsize.width/2, self.viewsize.height - 150);
    return text;
}

- (SKSpriteNode *)createMove:(TDMove *)move
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:[move getNodePicName]];
    
    node.size = CGSizeMake(51, 51);
    node.position = [[move getNodePosition:self.viewsize.width] CGPointValue];
    node.name = [move getNodeName];
    
    NSTimeInterval time = [move getTime];
    NSLog(@"time %f", time);
    SKAction *pause = [SKAction waitForDuration:[move getTime]];
    SKAction *moveUp = [SKAction moveByX:0 y:self.viewsize.height-90 duration:5];
    SKAction *moveSeq = [SKAction sequence:@[pause, moveUp]];
    [node runAction:moveSeq completion:^{
        if (move.direction == LEFT) {
            [move completeMove];
        }
        if ([move isCompleted]) {
            self.score += move.score;
            
            // update score and post notification to update score
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:self.score forKey:kTDCurrentGameScoreKey];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kTDUpdateCurrentGameScoreNotification object:nil];
            // create temporary label here
            SKAction *tmppause = [SKAction waitForDuration:1.5];
            SKAction *tmpremove = [SKAction removeFromParent];
            SKAction *missedSeq = [SKAction sequence:@[tmppause, tmpremove]];
            
            
            
            if ((move.score >= 2) && (move.score <= 3)) {
                self.good += 1;
                if (!self.goodText.parent) {
                    [self addChild:self.goodText];
                    [self.goodText runAction:missedSeq];
                } else {
                    [self.goodText runAction:tmppause completion:^{
                        if (!self.goodText.parent) {
                        [self addChild:self.goodText];
                        [self.goodText runAction:missedSeq];
                        }
                    }];
                }
            } else if (move.score >= 4) {
                self.great += 1;
                if (!self.greatText.parent) {
                    [self addChild:self.greatText];
                    [self.greatText runAction:missedSeq];
                } else {
                    [self.greatText runAction:tmppause completion:^{
                        if (!self.greatText.parent) {
                            [self addChild:self.greatText];
                            [self.greatText runAction:missedSeq];
                        }
                    }];
                }
            }
            
            SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *closeSeq = [SKAction sequence:@[fadeAway, remove]];
            [node runAction:closeSeq];
        } else {
            self.misses += 1;
            SKAction *moveUpAndAway = [SKAction moveByX:0 y:90 duration:0.5];
            [node runAction:moveUpAndAway];
            
            // create temporary label here
            SKAction *pause = [SKAction waitForDuration:1.5];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *missedSeq = [SKAction sequence:@[pause, remove]];
            
            if (!self.missedText.parent) {
                [self addChild:self.missedText];
                [self.missedText runAction:missedSeq];
            } else {
                [self.missedText runAction:remove completion:^{
                    if (!self.missedText.parent) {
                    [self addChild:self.missedText];
                    [self.missedText runAction:missedSeq];
                    }
                }];
            }
        }
        
        if ([move isLast]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTDEarlyEndToCtrlNotification object:nil];
        }
    }];
    return node;
}

- (void)endGame:(NSNotification *)notification
{
    if (self.endedGame) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:([defaults integerForKey:kTDScoreKey]+self.score) forKey:kTDScoreKey];
    
    // update current game scores
    [defaults setInteger:[self.moves count] forKey:kTDCurrentGameNumMovesKey];
    [defaults setInteger:self.score forKey:kTDCurrentGameScoreKey];
    [defaults setInteger:self.misses forKey:kTDCurrentGameMissesKey];
    [defaults setInteger:self.good forKey:kTDCurrentGameGoodKey];
    [defaults setInteger:self.great forKey:kTDCurrentGameGreatKey];
    
    [defaults synchronize];
}

- (void)removeNotificationCenterObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)dealloc
{
    [self performSelectorOnMainThread:@selector(removeNotificationCenterObserver) withObject:self waitUntilDone:YES];
}

@end