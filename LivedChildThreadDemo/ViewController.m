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
#import "AnotherViewController.h"

@interface ViewController ()
@property (nonatomic, strong) HJLivedChildThread *thread;


- (IBAction)executeCommonThread:(id)sender;

- (IBAction)stopCommonTread:(id)sender;

- (IBAction)excuteGlobalThread:(id)sender;

- (IBAction)stopGlobalThread:(id)sender;

- (IBAction)timerButton1:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.thread = [[HJLivedChildThread alloc] init];
}


- (IBAction)executeCommonThread:(id)sender {
    [self.thread hj_executeTask:^{
        NSLog(@"子线程执行任务");
    }];
}

- (IBAction)stopCommonTread:(id)sender {
    NSLog(@"stop common thread");
    [self.thread hj_stopThread];
}

- (IBAction)excuteGlobalThread:(id)sender {
    // 全局常驻子线程
    [self.hj_thread hj_executeTask:^{
        NSLog(@"全局子线程执行任务");
    }];
}

- (IBAction)stopGlobalThread:(id)sender {
    NSLog(@"stop global thread");
    [self.hj_thread hj_stopThread];
}

- (IBAction)timerButton1:(id)sender {
    AnotherViewController *anotherVC = [AnotherViewController new];
    anotherVC.view.backgroundColor = [UIColor yellowColor];
    [self presentViewController:anotherVC animated:YES completion:^{
        
    }];
    
}


@end
