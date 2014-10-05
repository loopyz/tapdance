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
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"size %d %d", self.skView.frame.size.height, self.skView.frame.size.width);
    GameScene *game = [[GameScene alloc] initWithViewSize:self.view.frame.size];
    
    [_gameView.skView presentScene:game];
    [self.navigationItem setHidesBackButton:YES];

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
