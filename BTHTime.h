//
//  BTHTime.h
//  beesToHome
//
//  Created by TONG on 2018/5/30.
//  Copyright © 2018年 eluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTHTime : NSObject

@property(nonatomic,assign,readonly)int countDown; // 倒数计时用

///开始定时器
+(void)startTime;

///取消定时器
+(void)stopTimer;

@end
