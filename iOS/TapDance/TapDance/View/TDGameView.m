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
        [self setupBottomBar];
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

- (void)setupBottomBar {
    UIView *bottomBar = [[UIView alloc] init];
    bottomBar.backgroundColor = UIColorFromRGB(0x03193B);
    bottomBar.alpha = .98f;
    bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomBar];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBar(78)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomBar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomBar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomBar)]];
    
    _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quitButton setImage:[UIImage imageNamed:@"QuitButton"] forState:UIControlStateNormal];
    _quitButton.contentMode = UIViewContentModeScaleAspectFill;
    _quitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomBar addSubview:_quitButton];
    
    [bottomBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_quitButton(52)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_quitButton)]];
    [bottomBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_quitButton(52)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_quitButton)]];
    
    _pointsLabel = [[UILabel alloc] init];
    _pointsLabel.textColor = [UIColor whiteColor];
    _pointsLabel.font = [UIFont fontWithName:@"Avenir" size:21.0f];
    _pointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _pointsLabel.textAlignment = NSTextAlignmentCenter;
    [bottomBar addSubview:_pointsLabel];
    
    [bottomBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pointsLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pointsLabel)]];
    [bottomBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pointsLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pointsLabel)]];
    
    
}

@end