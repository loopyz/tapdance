//
//  TDGameViewController.h
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface TDGameViewController : UIViewController

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) SKView *skView;

- (id)initWithGameId: (NSString *)gameId;

@end
