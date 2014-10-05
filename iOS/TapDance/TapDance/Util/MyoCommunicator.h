//
//  MyoCommunicator.h
//  TapDance
//
//  Created by Stephen Greco on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MyoKit/MyoKit.h>

@interface MyoCommunicator : NSObject

+ (id) defaultCommunicator;

@property GLKVector3 acceleration;
@property GLKVector3 gravity;
@property GLKVector3 rotation;
@property NSDate *lastImpactTime;

@end
