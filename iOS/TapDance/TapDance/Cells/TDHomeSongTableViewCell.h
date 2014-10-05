//
//  TDHomeSongTableViewCell.h
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDHomeSongTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *artistName;
@property (nonatomic, strong) UIView *difficultyView;
@property (nonatomic, strong) UILabel *difficultyLabel;

@end