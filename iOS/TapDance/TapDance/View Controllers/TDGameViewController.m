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

#import <SpriteKit/SpriteKit.h>

@interface TDGameViewController ()

@property (nonatomic, strong) TDGameView *gameView;

@end

@implementation TDGameViewController

- (id)initWithGameId: (NSString *)gameId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = UIColorFromRGB(0xFBFBFB);
        
        self.gameId = gameId;
        _gameView = [[TDGameView alloc] init];
        
        self.view = _gameView;
    }
    return self;
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
    TDMove *move4 = [[TDMove alloc] initWithDir:DOWN andTime:4 andLast:NO];

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

@end
