//
//  TDHomeHeaderTableViewCell.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDHomeHeaderTableViewCell.h"

@interface TDHomeHeaderTableViewCell()

@end

@implementation TDHomeHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.layer.masksToBounds = NO;
    self.layer.masksToBounds = NO;
    
    [self setupWhiteBackground];
    [self setupAvatar];
    [self setupName];
    [self setupPoints];
    
    
    return self;
}

- (void)setupWhiteBackground {
    UIImageView *whiteBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeWhiteBG"]];
    whiteBG.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:whiteBG];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[whiteBG(330)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(whiteBG)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[whiteBG]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(whiteBG)]];
}

- (void)setupAvatar {
    _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CatAvatar"]];
    _avatar.frame = CGRectMake(12, -20, 66, 66);
    [self.contentView addSubview:_avatar];
}

- (void)setupName {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.textColor = UIColorFromRGB(0x4897DF);
    _nameLabel.font = [UIFont fontWithName:@"Avenir" size:15.0];
    [self.contentView addSubview:_nameLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[_nameLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_nameLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
}

- (void)setupPoints {
    _pointsLabel = [[UILabel alloc] init];
    _pointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _pointsLabel.textColor = UIColorFromRGB(0x6D7886);
    _pointsLabel.font = [UIFont fontWithName:@"Avenir" size:14.0f];
    [self.contentView addSubview:_pointsLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[_pointsLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pointsLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nameLabel]-0-[_pointsLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _pointsLabel)]];
}


@end
