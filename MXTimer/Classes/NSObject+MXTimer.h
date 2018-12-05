//
//  NSObject+MXTimer.h
//  MXTimer
//
//  Created by heke on 2018/12/5.
//  Copyright © 2018 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXTimer.h"
NS_ASSUME_NONNULL_BEGIN

typedef NSString * MXJobID;

@interface NSObject (MXTimer)

- (MXJobID)startTimerWithTimeinterval:(NSTimeInterval)timeInterval
                                 repeats:(BOOL)repeats
                                 handler:(MXTimerHandler)handler;

- (void)stopTimerWith:(MXJobID)jobID;

@end

NS_ASSUME_NONNULL_END
