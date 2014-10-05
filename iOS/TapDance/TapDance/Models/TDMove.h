//
//  TDMove.h
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMove : NSObject

enum DIR {LEFT, RIGHT, UP, DOWN};
@property enum DIR direction;
@property BOOL completed;
@property double time;
@property BOOL last;

- (id)initWithDir: (enum DIR)direction andTime: (double)time andLast:(bool)last;
- (void)completeMove;
- (BOOL)isCompleted;
- (NSString *)getMoveDirName;
- (NSString *)getNodeName;
- (NSValue *)getNodePosition;
- (NSString *)getNodePicName;
- (double)getTime;
- (BOOL)isLast;

@end
