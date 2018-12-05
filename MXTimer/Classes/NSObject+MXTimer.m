//
//  NSObject+MXTimer.m
//  MXTimer
//
//  Created by heke on 2018/12/5.
//  Copyright © 2018 MX. All rights reserved.
//

#import "NSObject+MXTimer.h"

@implementation NSObject (MXTimer)

- (MXJobID)startTimerWithTimeinterval:(NSTimeInterval)timeInterval
                                repeats:(BOOL)repeats
                                handler:(MXTimerHandler)handler {
    return (MXJobID)[MXTimer startTimerJobWith:self fireInterval:timeInterval repeats:repeats handler:handler];
}

- (void)stopTimerWith:(MXJobID)jobID {
    [MXTimer stopTimerJobWith:jobID];
}

@end
