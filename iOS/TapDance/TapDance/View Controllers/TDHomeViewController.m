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

@interface TDHomeViewController()<APParallaxViewDelegate>

@property (nonatomic, strong) TDHomeHeaderTableViewCell *headerCell;

@end

@implementation TDHomeViewController

const NSInteger TDHeaderSection = 0;

static NSString *TDHomeHeaderTableViewÇellIdentifier = @"TDHomeHeaderTableViewCell";

- (id)init {
    self = [super init];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self.tableView registerClass:[TDHomeHeaderTableViewCell class] forCellReuseIdentifier:TDHomeHeaderTableViewÇellIdentifier];
        
        [self.tableView addParallaxWithImage:nil andHeight:50];
        [self.tableView.parallaxView setDelegate:self];
        [self.tableView addBlackOverlayToParallaxView];
        [self.tableView.parallaxView.imageView setImage:[UIImage imageNamed:@"HomeHeader"]];
        
    }
    return self;
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // make total 354
    if (indexPath.section == TDHeaderSection) {
        return 70;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TDHeaderSection) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TDHeaderSection) {
        _headerCell = [self.tableView dequeueReusableCellWithIdentifier:TDHomeHeaderTableViewÇellIdentifier];
        _headerCell.nameLabel.text = @"Lucy Guo";
        _headerCell.pointsLabel.text = @"Points: 3528";
        
        return _headerCell;
    } else return nil;
}


@end
