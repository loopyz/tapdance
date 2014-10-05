//
//  TDGameView.h
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface TDGameView : UIView

@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UILabel *pointsLabel;

@end