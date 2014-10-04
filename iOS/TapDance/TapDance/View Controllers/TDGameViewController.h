//
//  TDGameViewController.h
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDGameViewController : UIViewController

@property (nonatomic, strong) NSString *gameId;

- (id)initWithGameId: (NSString *)gameId;

@end
