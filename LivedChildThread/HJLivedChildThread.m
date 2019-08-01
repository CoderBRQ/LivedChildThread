//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import "HJLivedChildThread.h"

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

@end


@implementation HJLivedChildThread
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
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        [_thread start];
    }
    return _thread;
}

- (void)hj_executeTask:(void (^)(void))task {
    if (!task) return;
    
    [self performSelector:@selector(p_executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)p_executeTask:(void (^)(void))task
{
    task();
}

- (void)hj_stopThread
{
    if (!_thread) return;
    
    [self performSelector:@selector(p_stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)p_stop
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc
{
    [self hj_stopThread];
}

@end
