//
//  MyoCommunicator.m
//  TapDance
//
//  Created by Stephen Greco on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "MyoCommunicator.h"

const char *strings[] = {"CENTER", "UP", "DOWN", "LEFT", "RIGHT"};

@implementation MyoCommunicator

+ (id) defaultCommunicator {
    static MyoCommunicator *defaultCommunicator;
    if (defaultCommunicator == nil) defaultCommunicator = [[MyoCommunicator alloc] init];
    return defaultCommunicator;
}

- (id) init {
    if ((self = [super init]) != nil) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"model" ofType:@"json"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:fileData options:kNilOptions error:nil];
        _model = json[@"parameters"];
        
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

- (NSDictionary *) mostRecent {
    return @{@"direction" : @(_direction), @"timestamp": _lastImpactTime};
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
    
    if (magnitude > 0.65 && _acceleration.x > 0) {
        if ([timestamp timeIntervalSinceDate:_lastImpactTime] < 0.2 /* seconds */)
            return;
        
        _lastImpactTime = timestamp;
        
        _direction = [self predictStep];
        NSLog(@"%s", strings[_direction]);
       //NSLog(@"accel: %f, %f, %f", _acceleration.x, _acceleration.y, _acceleration.z);
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
    _direction = CENTER;
}

- (direction) predictStep {
    NSDictionary *data = _model[_direction];
    NSArray *matrix = data[@"matrix"];
    NSArray *mean = data[@"mean"];
    NSArray *std = data[@"std"];
    float newData[] = {_acceleration.x, _acceleration.y, _acceleration.z,
                _angular.x, _angular.y, _angular.z, _yaw, _pitch, _roll};
    for (int i = 0; i < 9; i++) {
        newData[i] -= [[mean objectAtIndex:i] floatValue];
        newData[i] /= [[std objectAtIndex:i] floatValue];
    }
    NSMutableArray *intercept = [NSMutableArray arrayWithArray:data[@"intercept"]];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            NSNumber *result = [NSNumber numberWithFloat:
                                newData[j] * [[[matrix objectAtIndex:i] objectAtIndex:j] floatValue]];
            [intercept setObject:result atIndexedSubscript:i];
        }
    }
    int index = 0;
    float bigFloat = -100000000.0f;
    for (int i = 0; i < 5; i++) {
        if (i != 3 && [[intercept objectAtIndex:i] floatValue] > bigFloat) {
            bigFloat = [[intercept objectAtIndex:i] floatValue];
            index = i;
        }
    }
    return index;
}


@end
