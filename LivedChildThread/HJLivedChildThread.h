//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJLivedChildThread : NSObject

@property (nonatomic, class, readonly, nonnull) HJLivedChildThread *sharedThread;
/**
 Start thread with task.

 @param task The task shoud be executed in the thread.
 */
- (void)hj_executeTask:(void(^ _Nonnull)(void))task;


/**
 Stop the child thread.
 */
- (void)hj_stopThread;

@end
