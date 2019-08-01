//
//  ViewController.m
//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import "ViewController.h"
// 导入头文件
#import "LivedChildThread.h"

@interface ViewController ()
@property (nonatomic, strong) HJLivedChildThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 普通子线程
- (void)commonThread {
    self.thread = [[HJLivedChildThread alloc] init];
    
    [self.thread hj_executeTask:^{
        NSLog(@"%s", __func__);
    }];
}

// 结束普通子线程
- (void)stopCommonThread {
    [self.thread hj_stopThread];
}

- (void)globalThread {
    // 全局常驻子线程
    [self.hj_thread hj_executeTask:^{
        NSLog(@"Execute task.");
    }];
}
@end
