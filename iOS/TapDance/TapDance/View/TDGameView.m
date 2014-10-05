//
//  TDGameView.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameView.h"

#define GAME_DEBUG YES

@implementation TDGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBackground];
        [self setupSKView];
        [self setupArrows];
    }
    return self;
}

- (void)setupBackground {
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GameBG"]];
    bg.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bg];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bg)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bg)]];
}

- (void)setupSKView {
    self.skView = [[SKView alloc] init];
    self.skView.translatesAutoresizingMaskIntoConstraints = NO;
    self.skView.showsDrawCount = GAME_DEBUG;
    self.skView.showsNodeCount = GAME_DEBUG;
    self.skView.showsFPS = GAME_DEBUG;
    self.skView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.skView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_skView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_skView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skView)]];
}

- (void)setupArrows {
    UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftArrowPad"]];
    [self addSubview:leftArrow];
    
    UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftArrowPad"]];
    [self addSubview:downArrow];
    
    UIImageView *upArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UpArrowPad"]];
    [self addSubview:upArrow];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrowPad"]];
    [self addSubview:rightArrow];
    
    
}

@end
