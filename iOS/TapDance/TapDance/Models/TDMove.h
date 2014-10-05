//
//  TDMove.h
//  TapDance
//
//  Created by Niveditha Jayasekar on 10/4/14.
//  Copyright (c) 2014 TapDance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
- (NSString *)getMoveDirName:(enum DIR)direction;
- (NSString *)getNodeName;
- (NSValue *)getNodePosition:(CGFloat)width;
- (NSValue *)getNodePosition:(CGSize)size andDir:(enum DIR)direction;
- (NSString *)getNodePicName;
- (NSString *)getNodePicName:(enum DIR)direction;
- (double)getTime;
- (BOOL)isLast;

@end
