//
//  TDGameViewController.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameViewController.h"

#import "TDGameView.h"
#import "TDGameScene.h"
#import "TDMove.h"
#import "TDConstants.h"
#import "TDGameOverTableViewController.h"

#import "AFSoundManager.h"
#import <SpriteKit/SpriteKit.h>


@interface TDGameViewController ()

@property (nonatomic, strong) TDGameView *gameView;
@property (nonatomic, strong) NSArray *songs;

@end

@implementation TDGameViewController

- (id)initWithGameId: (NSInteger)gameId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = UIColorFromRGB(0xFBFBFB);
        
        self.gameId = gameId;
        _gameView = [[TDGameView alloc] init];
        [_gameView.quitButton addTarget:self action:@selector(quitButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        _gameView.pointsLabel.text = @"Points: 0";
        
        self.view = _gameView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToNotification:) name:kTDEarlyEndToCtrlNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToNotification:) name:kTDUpdateCurrentGameScoreNotification object:nil];
        
        _songs = @[@"LaffyTaffy.mp3", @"shakeitoff.mp3", @"whatdoesthefoxsay.mp3", @"nyancat.mp3", @"rednose.mp3", @"closer.mp3", @"clarity.mp3", @"dieyoung.mp3", @"wecantstop.mp3", @"talkdirtytome.mp3"];
        
        [self playMusic];
    }
    return self;
}

- (void)respondToNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kTDEarlyEndToCtrlNotification]) {
        [self quitButtonTouched];
    } else if ([notification.name isEqualToString:kTDUpdateCurrentGameScoreNotification]) {
        [self updateGameScore];
    }
}

- (void)updateGameScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _gameView.pointsLabel.text = [NSString stringWithFormat:@"Points: %d", [defaults integerForKey:kTDCurrentGameScoreKey]];
}

- (void)quitButtonTouched {
    [[AFSoundManager sharedManager] stop];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTDEarlyEndToSceneNotification object:nil];
    
    TDGameOverTableViewController *gotvc = [[TDGameOverTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self presentViewController:gotvc animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)playMusic {
    [[AFSoundManager sharedManager]startPlayingLocalFileWithName:_songs[self.gameId] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        NSLog(@"Playing music now?!?");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    TDMove *move1 = [[TDMove alloc] initWithDir:LEFT andTime:1 andLast:NO];
    TDMove *move2 = [[TDMove alloc] initWithDir:RIGHT andTime:1 andLast:NO];
    TDMove *move3 = [[TDMove alloc] initWithDir:UP andTime:3 andLast:NO];
    TDMove *move4 = [[TDMove alloc] initWithDir:DOWN andTime:4 andLast:YES];
    
    NSMutableArray *moves = [[NSMutableArray alloc] initWithObjects:move1, move2, move3, move4, nil];
    TDGameScene *game = [[TDGameScene alloc] initWithViewSize:self.view.frame.size andMoves:moves];
    
    [_gameView.skView presentScene:game];
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeNotificationCenterObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)dealloc
{
    [self performSelectorOnMainThread:@selector(removeNotificationCenterObserver) withObject:self waitUntilDone:YES];
}

@end