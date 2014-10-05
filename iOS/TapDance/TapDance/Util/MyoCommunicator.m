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
                                                 selector:@selector(didReceiveOrientationEvent:)
                                                     name:TLMMyoDidReceiveOrientationEventNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveGyroscopeEvent:)
                                                     name:TLMMyoDidReceiveGyroscopeEventNotification
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
    NSDate *timestamp = [NSDate date];
    
    float alpha = 0.8;
    _gravity = GLKVector3Make(alpha * _gravity.x + (1-alpha) * _acceleration.x,
                              alpha * _gravity.y + (1-alpha) * _acceleration.y,
                              alpha * _gravity.z + (1-alpha) * _acceleration.z);
    
    _acceleration = GLKVector3Subtract(_acceleration, _gravity);
    
    // calculate the magnitude of the acceleration
    float magnitude = GLKVector3Length(_acceleration);
    
    if (magnitude > 0.65 && _acceleration.x < 0) {
        if ([timestamp timeIntervalSinceDate:_lastImpactTime] < 0.2 /* seconds */)
            return;
        
        _lastImpactTime = timestamp;
        
       NSLog(@"accel: %f, %f, %f", _acceleration.x, _acceleration.y, _acceleration.z);
    }
}

- (void) didReceiveOrientationEvent: (NSNotification*) notification {
    TLMOrientationEvent *event = notification.userInfo[kTLMKeyOrientationEvent];
    GLKQuaternion quat = event.quaternion;
    
    _roll = atan2(2.0f * (quat.w * quat.x + quat.y * quat.z),
                 1.0f - 2.0f * (quat.x * quat.x + quat.y * quat.y));
    _pitch = asin(2.0f * (quat.w * quat.y - quat.z * quat.x));
    _yaw = atan2(2.0f * (quat.w * quat.z + quat.x * quat.y),
                1.0f - 2.0f * (quat.y * quat.y + quat.z * quat.z));

}

- (void) didReceiveGyroscopeEvent: (NSNotification*) notification {
    TLMGyroscopeEvent *event = notification.userInfo[kTLMKeyGyroscopeEvent];
    _angular = event.vector;
}

- (void) didConnectDevice: (NSNotification*) notification {
    NSLog(@"connected to myo...");
}


@end
