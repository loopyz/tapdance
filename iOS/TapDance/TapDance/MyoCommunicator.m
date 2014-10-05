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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didConnectDevice:)
                                                     name:TLMHubDidConnectDeviceNotification
                                                   object:nil];
    }
    return self;
}

- (void) didReceiveAccelerometerEvent: (NSNotification*) notification {
    TLMAccelerometerEvent *event = notification.userInfo[kTLMKeyAccelerometerEvent];
    _acceleration = event.vector;
    NSDate *timestamp = event.timestamp;
    
    // calculate the magnitude of the acceleration
    float magnitude = GLKVector3Length(_acceleration);
    
    if (magnitude > 0.65 && _acceleration.x < 0) {
        if ([timestamp timeIntervalSinceDate:_lastImpactTime] < 0.2 /* seconds */)
            return;
        _lastImpactTime = timestamp;
        
        NSLog(@"accel: %f, %f, %f", _acceleration.x, _acceleration.y, _acceleration.z);
    }
}

- (void) didConnectDevice: (NSNotification*) notification {
    NSLog(@"connected to myo...");
}


@end
