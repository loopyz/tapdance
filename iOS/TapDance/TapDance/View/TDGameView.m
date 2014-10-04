//
//  TDGameView.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameView.h"

@implementation TDGameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBackground];
        [self setupSKView];
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
    self.skView.showsDrawCount = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsFPS = YES;
    self.skView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.skView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_skView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_skView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_skView)]];
}

@end
