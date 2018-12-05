//
//  MXTimer.m
//  MXTimer
//
//  Created by heke on 2018/12/5.
//  Copyright © 2018 MX. All rights reserved.
//

#import "MXTimer.h"

@interface MXTimerJob : NSObject

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, copy)   NSString *jobID;
@property (nonatomic, copy)   MXTimerHandler handler;
@property (nonatomic, assign) BOOL valid;

@end

@implementation MXTimerJob

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initJob];
    }
    return self;
}

- (void)initJob {
    _valid = YES;
}

- (void)execute {
    if (_valid && _handler) {
        _handler();
    }
    
    if (!_repeats) {
        _valid = NO;
        _handler = nil;
    }
}

@end

@interface MXTimer ()

@property (nonatomic, strong) NSMutableDictionary *jobQueue;
@property (nonatomic, strong) NSMapTable          *observerQueue;
@property (nonatomic, strong) NSMutableDictionary *timerQueue;

@end

@implementation MXTimer

+ (NSString *)startTimerJobWith:(NSObject *)observer
                   fireInterval:(NSTimeInterval)timeInterval
                        repeats:(BOOL)repeats
                        handler:(MXTimerHandler)handler {
    
    MXTimer *t = [MXTimer sharedInstance];
    return [t startTimerWith:observer fireInterval:timeInterval repeats:repeats handler:handler];
}

+ (void)stopTimerJobWith:(NSString *)jobId {
    [[MXTimer sharedInstance] stopTimerJobWith:jobId];
}

#pragma mark - private
+ (instancetype)sharedInstance {
    static MXTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[MXTimer alloc] init];
    });
    return timer;
}

- (void)stopTimerJobWith:(NSString *)jobId {
    NSTimer *timer = [_timerQueue objectForKey:jobId];
    if (timer) {
        [timer invalidate];
        [_timerQueue removeObjectForKey:jobId];
    }
    [_jobQueue removeObjectForKey:jobId];
    [_observerQueue removeObjectForKey:jobId];
}

- (NSString *)startTimerWith:(NSObject *)observer
          fireInterval:(NSTimeInterval)timeInterval
               repeats:(BOOL)repeats
               handler:(MXTimerHandler)handler {
    
    NSString *key = [MXTimer mxUUID];
    
    MXTimerJob *job = [[MXTimerJob alloc] init];
    job.handler = handler;
    job.timeInterval = timeInterval;
    job.repeats = repeats;
    job.jobID = key;
    
    [_jobQueue setObject:job forKey:key];
    [_observerQueue setObject:observer forKey:key];
    
    [self startTimerWith:job];
    
    return key;
}

- (void)startTimerWith:(MXTimerJob *)job {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:job.timeInterval
                                              target:self
                                            selector:@selector(fire:)
                                            userInfo:job.jobID
                                             repeats:job.repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer
                              forMode:NSRunLoopCommonModes];
    [_timerQueue setObject:timer forKey:job.jobID];
}

- (void)fire:(NSTimer *)timer {
    NSString *jobID = (NSString *)(timer.userInfo);
    id obeserver = [_observerQueue objectForKey:jobID];
    if (!obeserver) {
        [timer invalidate];
        [_observerQueue removeObjectForKey:jobID];
        [_jobQueue removeObjectForKey:jobID];
        [_timerQueue removeObjectForKey:jobID];
        return;
    }
    
    MXTimerJob *job = [_jobQueue objectForKey:jobID];
    [job execute];
    if (!job.valid) {
        [_observerQueue removeObjectForKey:jobID];
        [_jobQueue removeObjectForKey:jobID];
        [_timerQueue removeObjectForKey:jobID];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.jobQueue = @{}.mutableCopy;
    self.timerQueue = @{}.mutableCopy;
    self.observerQueue = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
}

+ (NSString *)mxUUID {
    return [[NSUUID UUID] UUIDString];
}

@end
