//
//  AnotherViewController.m
//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 9/27/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import "AnotherViewController.h"
#import "LivedChildThread.h"


@interface AnotherViewController ()
@property (nonatomic, strong) HJLivedChildThread *thread;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AnotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[HJLivedChildThread alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, 50)];
    label.userInteractionEnabled = YES;
    label.text = @"点击屏幕退出当前控制器,查看日志，看timer是否释放";
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", NSThread.currentThread);
        dispatch_async(dispatch_get_main_queue(), ^{
           NSLog(@"%@", NSThread.currentThread);
        });
    }];
    self.timer = timer;
    
    [self.thread hj_addTimer:timer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.thread hj_removeTimer:self.timer];
    
}

- (void)dealloc {
    
}
@end
