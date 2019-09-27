//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import "HJLivedChildThread.h"
#import <objc/runtime.h>

static void observerCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        default:
            break;
    }
}

@interface HJThread : NSThread
@end
@implementation HJThread
- (void)dealloc {
#ifdef DEBUG
    NSLog(@"thread dealloc");
#endif
}
@end

@interface HJLivedChildThread()
@property (strong, nonatomic) HJThread *thread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;
@property (strong, nonatomic) NSMapTable<NSString*, NSTimer*> *timerMapTable;
@end

@implementation HJLivedChildThread
#pragma mark - public methods
- (void)hj_executeTask:(void (^)(void))task {
    if (!task) return;
    [self performSelector:@selector(p_executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)hj_stopThread
{
    if (!_thread) return;
    [self performSelector:@selector(p_stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)hj_addTimer:(NSTimer *)timer {
    if (!timer) {return;}
    [self.timerMapTable setObject:timer forKey:((NSString *)&*timer)];
    [self performSelector:@selector(addTimerToRunloopModel:) onThread:self.thread withObject:timer waitUntilDone:NO];
}

- (void)hj_removeTimer:(NSTimer *)timer {
    if (!timer) {return;}
    id obj = [self.timerMapTable objectForKey:((NSString *)&*timer)];
    if (timer == obj) {
        [obj invalidate];
        [self.timerMapTable removeObjectForKey:((NSString *)&*timer)];
    }
}

- (void)hj_removeAllTimers {
    for (NSTimer* timer in self.timerMapTable) {
        [timer invalidate];
    }
    [self.timerMapTable removeAllObjects];
}

#pragma mark - dealloc
- (void)dealloc
{
    for (NSTimer *timer in self.timerMapTable) {
        if (timer.isValid) {
            [timer invalidate];
        }
    }
    [self.timerMapTable removeAllObjects];
    [self hj_stopThread];
}

#pragma mark - private methods
- (void)p_stop
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)p_executeTask:(void (^)(void))task
{
    task();
}

- (void)addTimerToRunloopModel:(NSTimer *)timer {
    // 在子线程中添加定时器，定时器的回调也就在该子线程中
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - getter
- (NSMapTable<NSString *,NSTimer *> *)timerMapTable {
    if (_timerMapTable == nil) {
        _timerMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    return _timerMapTable;
}

+ (HJLivedChildThread *)sharedThread {
    static HJLivedChildThread *_livedChildThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _livedChildThread = [[HJLivedChildThread alloc] init];
    });
    return _livedChildThread;
}

- (HJThread *)thread {
    if (nil == _thread) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        _thread = [[HJThread alloc] initWithBlock:^{
            // add port
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            // add observer
            CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallBack, NULL);
            CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
            CFRelease(observer);
            
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        [_thread start];
    }
    return _thread;
}

@end
