//
//  TDGameOverTableViewController.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameOverTableViewController.h"
#import "TDGameOverTableViewCell.h"

@interface TDGameOverTableViewController ()

@property (nonatomic, strong) TDGameOverTableViewCell *gameOverCell;

@end

@implementation TDGameOverTableViewController

static NSString *TDGameOverCellIdentifier = @"TDGameOverTableViewCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = UIColorFromRGB(0x03193B);
        [self.tableView registerClass:[TDGameOverTableViewCell class] forCellReuseIdentifier:TDGameOverCellIdentifier];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)didTapDone {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _gameOverCell = [self.tableView dequeueReusableCellWithIdentifier:TDGameOverCellIdentifier];
    _gameOverCell.missesView.progressTotal = 7;
    _gameOverCell.missesView.progressCounter = 3;
    _gameOverCell.averageView.progressCounter = 3;
    _gameOverCell.averageView.progressTotal = 7;
    _gameOverCell.goodView.progressCounter = 5;
    _gameOverCell.goodView.progressTotal = 7;
    _gameOverCell.greatView.progressTotal = 7;
    _gameOverCell.greatView.progressCounter = 1;
    
    _gameOverCell.gradeLabel.text = @"A-";
    [_gameOverCell.doneButton addTarget:self action:@selector(didTapDone) forControlEvents:UIControlEventTouchUpInside];
    
    return _gameOverCell;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
