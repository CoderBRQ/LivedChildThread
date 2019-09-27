//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

/**
 常驻子线程在这里有两种创建方式：
    1. 单利的方式。这种使用与全局的子线程。直接在所在的控制器，使用self.hj_thread即可获得单利对象。
    2. alloc]init]方式直接创建。这种使用于单个界面或控制器需要保活子线程，离开界面销毁线程的场景。
 
 主要功能：
    1. 子线程保活（常驻子线程）;同时也可以停止子线程
    2. 常驻子线程中执行任务-hj_executeTask:方法，传入要执行的任务。主要任务的执行在对应的子线程中执行。
    3. 常驻子线程中添加一个或多个定时器。以及移除定时器。同上，也要注意定时任务也是在子线程中执行。
 
 */

#import <Foundation/Foundation.h>

@interface HJLivedChildThread : NSObject

/**
 单利的创建方式是可选的，根据需求选择不同的创建方式。
 */
@property (nonatomic, class, readonly, nonnull) HJLivedChildThread *sharedThread;
/**
 停止子线程
 */
- (void)hj_stopThread;

/**
 在常驻子线程中执行任务。
 @param task 任务.
 */
- (void)hj_executeTask:(void(^_Nullable)(void))task;

/**
 添加定时器
 @description: 在子线程中添加定时器，定时器的回调block也就在该子线程中
 @param timer 定时器
 */
- (void)hj_addTimer:(NSTimer *_Nullable)timer;

/**
 移除定时器

 @param timer 定时器实例对象作为移除key
 */
- (void)hj_removeTimer:(NSTimer *_Nullable)timer;

/**
 移除该线程上所有的定时器
 */
- (void)hj_removeAllTimers;
@end
