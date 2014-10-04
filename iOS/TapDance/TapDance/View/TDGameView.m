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

@end
