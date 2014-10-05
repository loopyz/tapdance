//
//  TDConstants.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDConstants.h"

@implementation TDConstants

#pragma mark - basic
NSString *const kTDHasBeenLaunchedKey = @"hasBeenLaunched";
NSString *const kTDScoreKey = @"score";
NSString *const kTDPersonKey = @"person";

#pragma mark - current game
NSString *const kTDCurrentGameNumMovesKey = @"currentGameNumMoves";
NSString *const kTDCurrentGameScoreKey = @"currentGameScore";
NSString *const kTDCurrentGameMissesKey = @"currentGameMisses";
NSString *const kTDCurrentGameGoodKey = @"currentGameGood";
NSString *const kTDCurrentGameGreatKey = @"currentGameGreat";

#pragma mark - notifications
NSString *const kTDEarlyEndToSceneNotification = @"earlyEndToScene";
NSString *const kTDEarlyEndToCtrlNotification = @"earlyEndToCtrl";
NSString *const kTDUpdateCurrentGameScoreNotification = @"updateCurrentGameScore";

@end