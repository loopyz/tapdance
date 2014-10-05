//
//  MyoCommunicator.m
//  TapDance
//
//  Created by Stephen Greco on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "MyoCommunicator.h"

@implementation MyoCommunicator

+ (id) defaultCommunicator {
    static MyoCommunicator *defaultCommunicator;
    if (defaultCommunicator == nil) defaultCommunicator = [[MyoCommunicator alloc] init];
    return defaultCommunicator;
}

- (id) init {
    if ((self = [super init]) != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveAccelerometerEvent:)
                                                     name:TLMMyoDidReceiveAccelerometerEventNotification
                                                   object:nil];
    }
    return self;
}

- (void) didReceiveAccelerometerEvent: (NSNotification*) notification {
    TLMAccelerometerEvent *event = notification.userInfo[kTLMKeyAccelerometerEvent];
    _acceleration = event.vector;
    NSDate *timestamp = event.timestamp;
    
    // calculate the magnitude of the acceleration
    float magnitude = sqrt(_acceleration.x * _acceleration.x +
                         _acceleration.y * _acceleration.y +
                         _acceleration.z * _acceleration.z);
    
    if (magnitude > 0.65 && _acceleration.x < 0) {
        if ([timestamp timeIntervalSinceDate:_lastImpactTime] < 200000 /* ns */)
            return;
        _lastImpactTime = timestamp;
        
        NSLog(@"accel: %f, %f, %f", _acceleration.x, _acceleration.y, _acceleration.z);
    }

    
}


@end
