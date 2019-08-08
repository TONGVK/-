//
//  BTHTime.m
//  beesToHome
//
//  Created by TONG on 2018/5/30.
//  Copyright © 2018年 eluotuo. All rights reserved.
//

#import "BTHTime.h"

@interface BTHTime ()

@property(nonatomic,strong)NSTimer *timer; // timer

@property(nonatomic,strong)NSDate *beforeDate; // 上次进入后台时间

@end

static int const tick = 10;

@implementation BTHTime

+(instancetype)shardTime {
    static dispatch_once_t onceToken;
    static BTHTime *time = nil;
    dispatch_once(&onceToken, ^{
        time = [[BTHTime alloc] init];
    });
    
    return time;
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self setupNotification];
    }
    
    return self;
}


+(void)startTime {
    
    if ([BTHTime shardTime].countDown == 0) {
        
        [[BTHTime shardTime] startCountDown];
    }else {
        NSLog(@"已经有定时器在定时");
    }
}

+(void)stopTimer {
    
    [[BTHTime shardTime] stopTimer];
}


-(void)setupNotification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

/**
 *  进入后台记录当前时间
 */
-(void)enterBG {
    NSLog(@"应用进入后台啦");
    _beforeDate = [NSDate date];
}

/**
 *  返回前台时更新倒计时值
 */
-(void)enterFG {
    
    NSLog(@"应用将要进入到前台");
    NSDate * now = [NSDate date];
    int interval = (int)ceil([now timeIntervalSinceDate:_beforeDate]);
    int val = _countDown - interval;
    if(val > 1){
        _countDown -= interval;
    }else{
        _countDown = 1;
    }
}

/**
 *  开始倒计时
 */
-(void)startCountDown {
    
    _countDown = tick; //重置计时
    
    //需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    //使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)timerFired:(NSTimer *)timer {
    if (_countDown == 0) {
        
        [self stopTimer];
        
        NSLog(@"定时器定时完成");
        
    }else{
        
        _countDown -=1;
        
        NSLog(@"倒计时中：%d",_countDown);
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self stopTimer];
}
















@end
