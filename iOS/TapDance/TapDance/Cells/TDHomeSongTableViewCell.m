//
//  TDHomeSongTableViewCell.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDHomeSongTableViewCell.h"

@implementation TDHomeSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    [self setupAvatar];
    [self setupSongTitle];
    [self setupSongArtist];
    [self setupDifficulty];
    
    [self addBorder];
    
    
    return self;
}

- (void)setupAvatar {
    _avatar = [[UIImageView alloc] init];
    _avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatar];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_avatar(55)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9.5-[_avatar(55)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar)]];
}

- (void)setupSongTitle {
    _songName = [[UILabel alloc] init];
    _songName.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    _songName.textColor = UIColorFromRGB(0x666666);
    _songName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_songName];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatar(55)]-15-[_songName]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar, _songName)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_songName]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_songName)]];
}

- (void)setupSongArtist {
    _artistName = [[UILabel alloc] init];
    _artistName.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    _artistName.textColor = UIColorFromRGB(0xCCCCCC);
    _artistName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_artistName];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatar(55)]-15-[_artistName]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatar, _artistName)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_songName]-1-[_artistName]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_songName, _artistName)]];
}

- (void)setupDifficulty {
    _difficultyView = [[UIView alloc] init];
    _difficultyView.layer.cornerRadius = 15/2;
    _difficultyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_difficultyView];
    
    _difficultyLabel = [[UILabel alloc] init];
    _difficultyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    _difficultyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _difficultyLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:_difficultyLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_difficultyView(10)]-15-[_difficultyLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_difficultyLabel, _difficultyView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-33-[_difficultyView(10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_difficultyView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-31-[_difficultyLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_difficultyLabel)]];
}

- (void)addBorder
{
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:borderView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[borderView(1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(borderView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[borderView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(borderView)]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
