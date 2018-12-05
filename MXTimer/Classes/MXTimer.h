//
//  MXTimer.h
//  MXTimer
//
//  Created by heke on 2018/12/5.
//  Copyright © 2018 MX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MXTimerHandler)(void);

@interface MXTimer : NSObject
/*
 return Job id
 */
+ (NSString *)startTimerJobWith:(NSObject *)observer
                   fireInterval:(NSTimeInterval)timeInterval
                        repeats:(BOOL)repeats
                        handler:(MXTimerHandler)handler;

/*
 stop timer job by id
 */
+ (void)stopTimerJobWith:(NSString *)jobId;

@end

NS_ASSUME_NONNULL_END
