//
//  TDMove.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDMove.h"

#import <UIKit/UIKit.h>

@implementation TDMove

- (id)initWithDir: (enum DIR)direction andTime: (double)time andLast:(bool)last
{
    self = [super init];
    if (self) {
        self.completed = NO;
        self.direction = direction;
        self.time = time;
        self.last = last;
    }
    return self;
}

- (void)completeMove
{
    self.completed = YES;
}

- (BOOL)isCompleted
{
    return self.completed;
}

- (NSString *)getMoveDirName
{
    switch (self.direction) {
        case LEFT:
            return @"left";
        case RIGHT:
            return @"right";
        case UP:
            return @"up";
        default:
            return @"down";
    }
}

- (NSString *)getNodeName
{
    return [NSString stringWithFormat:@"%@%fMoveNode", [self getMoveDirName], self.time];
}

- (NSValue *)getNodePosition
{
    switch (self.direction) {
        case LEFT:
            return [NSValue valueWithCGPoint:CGPointMake(50,50)];
        case RIGHT:
            return [NSValue valueWithCGPoint:CGPointMake(50+80*3,50)];
        case UP:
            return [NSValue valueWithCGPoint:CGPointMake(50+80*2,50)];
        default:
            return [NSValue valueWithCGPoint:CGPointMake(50+80,50)];
    }
}

- (NSString *)getNodePicName
{
    switch (self.direction) {
        case LEFT:
            return @"LeftArrow";
        case RIGHT:
            return @"RightArrow";
        case UP:
            return @"UpArrow";
        default:
            return @"DownArrow";
    }
}

- (double)getTime
{
    return self.time;
}

- (BOOL)isLast
{
    return self.last;
}

@end
