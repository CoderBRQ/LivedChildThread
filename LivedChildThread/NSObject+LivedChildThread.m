//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import "NSObject+LivedChildThread.h"
#import <objc/runtime.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

static void *NSObjectLivedChildThread = &NSObjectLivedChildThread;

@implementation NSObject (LivedChildThread)

- (HJLivedChildThread *)hj_thread {
    id thread = objc_getAssociatedObject(self, &NSObjectLivedChildThread);
    if (nil == thread) {
        thread = [[HJLivedChildThread alloc] init];
        self.hj_thread = thread;
    }
    return thread;
}

- (void)setHj_thread:(HJLivedChildThread *)hj_thread {
    objc_setAssociatedObject(self, &NSObjectLivedChildThread, hj_thread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
