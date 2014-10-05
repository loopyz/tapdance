//
//  TDConstants.h
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDConstants : NSObject

#pragma mark - basic
extern NSString *const kTDHasBeenLaunchedKey;
extern NSString *const kTDScoreKey;
extern NSString *const kTDPersonKey;

#pragma mark - current game
extern NSString *const kTDCurrentGameNumMovesKey;
extern NSString *const kTDCurrentGameScoreKey;
extern NSString *const kTDCurrentGameMissesKey;
extern NSString *const kTDCurrentGameGoodKey;
extern NSString *const kTDCurrentGameGreatKey;

@end
