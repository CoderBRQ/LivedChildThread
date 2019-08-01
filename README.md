# LivedChildThread


# Usage:

## 创建并使用生命周期可控的常驻子线程

#### 导入头文件

```
#import "LivedChildThread.h"
```

#### 设置属性

```
@property (nonatomic, strong) HJLivedChildThread *thread;
```

#### 创建常驻子线程

```
self.thread = [[HJLivedChildThread alloc] init];
```

#### 在常驻子线程上执行任务

```
[self.thread hj_executeTask:^{
    NSLog(@"%s", __func__);
}];
```

#### 停止子线程两种方式

* 主动停止子线程

```
[self.thread hj_stopThread];
```
* 自动停止子线程
	
所在类销毁时，thread强引用取消，也会自动停止该类创建的子线程，所以就不需要调用`hj_stopThread`方法。

## 创建全局常驻子线程

#### 导入头文件

```
#import "LivedChildThread.h"
```

#### 直接使用实例对象的`hj_thread`属性调用执行任务的方法

在NSObject分类中添加了`hj_thread`属性，所以可以直接使用

```
// 全局常驻子线程
[self.hj_thread hj_executeTask:^{
	NSLog(@"Execute task.");
}];
```

#### 停止常驻子线程

调用`self.hj_thread`,会创建单利，所以不能自动结束，如果想结束该子线程，还是调用`hj_stopThread`方法

```
[self.hj_thread hj_stopThread];
```


