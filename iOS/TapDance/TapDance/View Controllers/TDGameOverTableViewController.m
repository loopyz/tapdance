//
//  TDGameOverTableViewController.m
//  TapDance
//
//  Created by Lucy Guo on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameOverTableViewController.h"

#import "TDGameOverTableViewCell.h"
#import "TDHomeViewController.h"
#import "TDConstants.h"

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
    // [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:[[TDHomeViewController alloc] init] animated:YES];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int numMoves = [defaults integerForKey:kTDCurrentGameNumMovesKey];
    
    _gameOverCell.missesView.progressTotal = numMoves;
    _gameOverCell.missesView.progressCounter = [defaults integerForKey:kTDCurrentGameMissesKey];
    _gameOverCell.averageView.progressCounter = [defaults integerForKey:kTDCurrentGameScoreKey];
    _gameOverCell.averageView.progressTotal = 5 * numMoves;
    _gameOverCell.goodView.progressCounter = [defaults integerForKey:kTDCurrentGameGoodKey];
    _gameOverCell.goodView.progressTotal = numMoves;
    _gameOverCell.greatView.progressTotal = numMoves;
    _gameOverCell.greatView.progressCounter = [defaults integerForKey:kTDCurrentGameGreatKey];
    
    int grade = ([defaults integerForKey:kTDCurrentGameScoreKey] * 100)/(numMoves*5);
    
    NSString *gradeLetter = nil;
    
    if (grade >= 90) {
        gradeLetter = @"A";
    } else if (grade >= 80) {
        gradeLetter = @"B";
    } else if (grade >= 70) {
        gradeLetter = @"C";
    } else if (grade >= 60) {
        gradeLetter = @"D";
    } else {
        gradeLetter = @"F";
    }
    
    int leftover = grade % 10;
    NSString *gradeDesc = nil;
    
    if (leftover >= 7) {
        gradeDesc = @"+";
    } else if (leftover >= 5) {
        gradeDesc = @"";
    } else {
        gradeDesc = @"-";
    }
    
    _gameOverCell.gradeLabel.text = [NSString stringWithFormat:@"%@%@", gradeLetter, gradeDesc];
    [_gameOverCell.doneButton addTarget:self action:@selector(didTapDone) forControlEvents:UIControlEventTouchUpInside];
    
    return _gameOverCell;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
