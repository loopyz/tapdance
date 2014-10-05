//
//  TDGameOverTableViewCell.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameOverTableViewCell.h"

@implementation TDGameOverTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addBackground];
        [self setupGradeLabel];
        [self setupMissesView];
        [self setupAverageView];
        [self setupGoodView];
        [self setupGreatView];
    }
    return self;
}

- (void)addBackground {
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GameOverBG"]];
    bg.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:bg];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bg)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bg)]];
}

- (void)setupGradeLabel {
    UILabel *yourScore = [[UILabel alloc] init];
    yourScore.textColor = [UIColor whiteColor];
    yourScore.font = [UIFont fontWithName:@"Avenir" size:31];
    yourScore.text = @"Your Score";
    yourScore.translatesAutoresizingMaskIntoConstraints = NO;
    yourScore.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:yourScore];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[yourScore]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(yourScore)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[yourScore]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(yourScore)]];
    
    _gradeLabel = [[UILabel alloc] init];
    _gradeLabel.textColor = [UIColor whiteColor];
    _gradeLabel.font = [UIFont fontWithName:@"Avenir" size:87];
    _gradeLabel.textAlignment = NSTextAlignmentCenter;
    _gradeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_gradeLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_gradeLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_gradeLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[yourScore]-56-[_gradeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_gradeLabel, yourScore)]];
}

- (MDRadialProgressView *)generateProgressView:(UIColor *)completedColor {
    MDRadialProgressView *newView = [[MDRadialProgressView alloc] init];
    newView.theme.sliceDividerHidden = YES;
    newView.translatesAutoresizingMaskIntoConstraints = NO;
    newView.label.hidden = YES;
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = completedColor;
    newTheme.incompletedColor = UIColorFromRGB(0x4E738B);
    newTheme.centerColor = [UIColor clearColor];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor blackColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    newTheme.thickness = 10.0f;
    
    newView.theme = newTheme;
    
    return newView;
}

- (void)setupMissesView {
    _missesView = [self generateProgressView:UIColorFromRGB(0x00A5FF)];
    [self.contentView addSubview:_missesView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_missesView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_missesView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_missesView(50)]-35-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_missesView)]];
    
}

- (void)setupAverageView {
    _averageView = [self generateProgressView:UIColorFromRGB(0x11CBC5)];
    [self.contentView addSubview:_averageView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_missesView]-20-[_averageView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_averageView, _missesView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_averageView(50)]-35-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_averageView)]];
}

- (void)setupGoodView {
    _goodView = [self generateProgressView:UIColorFromRGB(0xCE085B)];
    [self.contentView addSubview:_goodView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_averageView]-20-[_goodView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_averageView, _goodView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_goodView(50)]-35-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_goodView)]];
}

- (void)setupGreatView {
    _greatView = [self generateProgressView:UIColorFromRGB(0x3AC006)];
    [self.contentView addSubview:_greatView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_goodView]-20-[_greatView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_greatView, _goodView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_greatView(50)]-35-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_greatView)]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
