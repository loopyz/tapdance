//
//  TDMove.m
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import "TDMove.h"
#import "MyoCommunicator.h"

#define RAND_PRECISION 1024

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
    if (!self.completed) {
        self.completed = YES;
        // TODO: set score with myo -- based on some nearness thing
        self.score = 4;
    }
}

- (BOOL)isCompleted
{
    int direction = [[MyoCommunicator defaultCommunicator] objectForKey:@"direction"];
    int prob = 0.7;
    float x = arc4random_uniform(RAND_PRECISION) / (float)RAND_PRECISION;
    if (x < prob) {
        [self completeMove];
        self.score = 3;
    } else if ((self.direction == UP) && (direction == UPx)) {
        [self completeMove];
        self.score = 5;
    } else if ((self.direction == DOWN) && (direction == DOWNx)) {
        [self completeMove];
        self.score = 5;
    } else if ((self.direction == RIGHT) && (direction == RIGHTx)) {
        [self completeMove];
        self.score = 5;
    } else if ((self.direction == LEFT) && (direction == LEFTx)) {
        [self completeMove];
        self.score = 5;
    }

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

- (NSString *)getMoveDirName:(enum DIR)direction
{
    switch (direction) {
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

- (NSValue *)getNodePosition:(CGFloat)width
{
    CGFloat eighth = width/8;
    CGFloat height = 50;
    switch (self.direction) {
        case LEFT:
            return [NSValue valueWithCGPoint:CGPointMake(eighth,height)];
        case RIGHT:
            return [NSValue valueWithCGPoint:CGPointMake(7*eighth,height)];
        case UP:
            return [NSValue valueWithCGPoint:CGPointMake(5*eighth,height)];
        default:
            return [NSValue valueWithCGPoint:CGPointMake(3*eighth,height)];
    }
}

- (NSValue *)getNodePosition:(CGSize)size andDir:(enum DIR)direction
{
    CGFloat eighth = size.width/8;
    CGFloat height = size.height-40;
    switch (direction) {
        case LEFT:
            return [NSValue valueWithCGPoint:CGPointMake(eighth,height)];
        case RIGHT:
            return [NSValue valueWithCGPoint:CGPointMake(7*eighth,height)];
        case UP:
            return [NSValue valueWithCGPoint:CGPointMake(5*eighth,height)];
        default:
            return [NSValue valueWithCGPoint:CGPointMake(3*eighth,height)];
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

- (NSString *)getNodePicName:(enum DIR)direction
{
    switch (direction) {
        case LEFT:
            return @"LeftArrowPad";
        case RIGHT:
            return @"RightArrowPad";
        case UP:
            return @"UpArrowPad";
        default:
            return @"DownArrowPad";
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