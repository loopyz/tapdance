//
//  TDLoginViewController.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDHomeViewController.h"
#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>
#import "TDHomeHeaderTableViewCell.h"
#import "TDHomeSongTableViewCell.h"
#import "TDGameViewController.h"

@interface TDHomeViewController()<APParallaxViewDelegate>

@property (nonatomic, strong) TDHomeHeaderTableViewCell *headerCell;

@end

@implementation TDHomeViewController

const NSInteger TDHeaderSection = 0;
const NSInteger TDSongSection = 1;

static NSString *TDHomeHeaderTableViewÇellIdentifier = @"TDHomeHeaderTableViewCell";
static NSString *TDHomeSongTableViewCellIdentifier = @"TDHomeSongTableViewCell";

- (id)init {
    self = [super init];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self.tableView registerClass:[TDHomeHeaderTableViewCell class] forCellReuseIdentifier:TDHomeHeaderTableViewÇellIdentifier];
        [self.tableView registerClass:[TDHomeSongTableViewCell class] forCellReuseIdentifier:TDHomeSongTableViewCellIdentifier];
        
        [self.tableView addParallaxWithImage:nil andHeight:70];
        [self.tableView.parallaxView setDelegate:self];
        [self.tableView addBlackOverlayToParallaxView];
        [self.tableView.parallaxView.imageView setImage:[UIImage imageNamed:@"HomeHeader"]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // make total 354
    if (indexPath.section == TDHeaderSection) {
        return 70;
    } else if (indexPath. section == TDSongSection) {
        return 75;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TDHeaderSection) {
        return 1;
    } else if (section == TDSongSection) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TDHeaderSection) {
        _headerCell = [self.tableView dequeueReusableCellWithIdentifier:TDHomeHeaderTableViewÇellIdentifier];
        _headerCell.nameLabel.text = @"Lucy Guo";
        _headerCell.pointsLabel.text = @"Points: 3528";
        
        return _headerCell;
    } else if (indexPath.section == TDSongSection) {
        TDHomeSongTableViewCell *songCell = [self.tableView dequeueReusableCellWithIdentifier:TDHomeSongTableViewCellIdentifier];
        songCell.avatar.image = [UIImage imageNamed:@"ArtistAvatar"];
        songCell.songName.text = @"One more night";
        songCell.artistName.text = @"Adam Levigne";
        songCell.difficultyView.backgroundColor = UIColorFromRGB(0x62EB49);
        songCell.difficultyLabel.text = @"Easy";
                                                   
        return songCell;
    } else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TDGameViewController *gvc = [[TDGameViewController alloc] initWithGameId:[NSString stringWithFormat:@"%d", indexPath.row]];
    [self.navigationController pushViewController:gvc animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
