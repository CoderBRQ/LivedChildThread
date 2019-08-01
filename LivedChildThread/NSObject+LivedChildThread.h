//  LivedChildThreadDemo
//
//  Created by bianrongqiang on 8/1/19.
//  Copyright © 2019 bianrongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJLivedChildThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LivedChildThread)
@property (strong, nonatomic) HJLivedChildThread *hj_thread;

@end

NS_ASSUME_NONNULL_END
