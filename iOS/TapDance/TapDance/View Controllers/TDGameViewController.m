//
//  TDGameViewController.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDGameViewController.h"
#import "TDGameView.h"


#import <SpriteKit/SpriteKit.h>

#import "GameScene.h"

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

    self.skView = [[SKView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    self.skView.showsDrawCount = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsFPS = YES;
    self.skView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.skView];
}

- (void)viewWillAppear:(BOOL)animated
{
    GameScene *game = [[GameScene alloc] initWithSize:self.skView.frame.size];
    
    [self.skView presentScene:game];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
