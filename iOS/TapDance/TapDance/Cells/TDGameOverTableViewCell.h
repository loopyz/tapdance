//
//  TDGameOverTableViewCell.h
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDRadialProgressView.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>

@interface TDGameOverTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) MDRadialProgressView *averageView;

@property (nonatomic, strong) MDRadialProgressView *missesView;
@property (nonatomic, strong) MDRadialProgressView *goodView;
@property (nonatomic, strong) MDRadialProgressView *greatView;

@property (nonatomic, strong) UIButton *doneButton;



@end
