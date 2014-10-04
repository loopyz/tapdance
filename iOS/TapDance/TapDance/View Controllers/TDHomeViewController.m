//
//  TDLoginViewController.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDHomeViewController.h"
#import <APParallaxHeader/UIScrollView+APParallaxHeader.h>

@interface TDHomeViewController()<APParallaxViewDelegate>

@end

@implementation TDHomeViewController

- (id)init {
    self = [super init];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self.tableView addParallaxWithImage:nil andHeight:50];
        [self.tableView.parallaxView setDelegate:self];
        [self.tableView addBlackOverlayToParallaxView];
        [self.tableView.parallaxView.imageView setImage:[UIImage imageNamed:@"HomeHeader"]];
        
    }
    return self;
}

@end
