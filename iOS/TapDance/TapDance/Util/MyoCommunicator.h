//
//  MyoCommunicator.h
//  TapDance
//
//  Created by Stephen Greco on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MyoKit/MyoKit.h>

typedef enum {
    CENTER = 0,
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    RIGHT = 4} direction;

@interface MyoCommunicator : NSObject

+ (id) defaultCommunicator;
- (NSDictionary *) mostRecent;

@property GLKVector3 acceleration;
@property GLKVector3 gravity;
@property GLKVector3 angular;
@property NSArray *model;
@property float yaw;
@property float pitch;
@property float roll;
@property direction direction;
@property NSDate *lastImpactTime;

@end
