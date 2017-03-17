//
//  iRonProgressView.m
//  iRonProgress
//
//  Created by IDSBG-00 on 2017/3/15.
//  Copyright © 2017年 iRonCheng. All rights reserved.
//

#import "iRonProgressView.h"

@interface iRonProgressView () <CAAnimationDelegate>

/* 前景图 */
@property (nonatomic, strong) UIView *foreView;

/* 返回实时值的block */
@property (nonatomic, strong) Progress progressBlock;

@property (nonatomic, strong) Finished finishedBlock;

@property (nonatomic, assign) CGFloat goalProgress;

@property (nonatomic, strong) CABasicAnimation *boundsAnimation;

@property (nonatomic, strong) NSTimer *timer;

/* 从低进度到高进度 */
@property (nonatomic, assign) BOOL fromSmallToBig;

@end

@implementation iRonProgressView

- (instancetype)initWithFrame:(CGRect)frame
{   
    self = [super initWithFrame:frame];
    if (self) {
        /*
         *  默认值
         */
        _foreColor = [UIColor blueColor];
        _totalTimeInterval = 1.f;
        _countInstance = 1;
        _returnZeroEachTime = NO;
        _progress = 0.f;
        
        _foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _foreView.backgroundColor = _foreColor;
        /* 设置锚点后 需要再设置position */
        _foreView.layer.anchorPoint = CGPointMake(0, 0);
        _foreView.layer.position = CGPointMake(0, 0);
        [self addSubview:_foreView];
        
    }
    return self;
}

#pragma mark - INSTANCE METHOD

- (void)setProgress:(CGFloat)progress curretProgress:(Progress)curretProgress finished:(Finished)flag
{
    if (progress >= 0 && progress <= 1) {
        _goalProgress = progress;
        
        _progressBlock = curretProgress;
        _finishedBlock = flag;
        
        if (!_returnZeroEachTime) {
            if (_progress > progress) {
                _fromSmallToBig = NO;
            } else {
                _fromSmallToBig = YES;
            }
        } else {
            _fromSmallToBig = YES;
            _progress = 0;
            
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:(_totalTimeInterval*_countInstance/100 )target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        
        _goalProgress = progress;
        
        /* block返回 */
        if (_progressBlock) {
            _progressBlock(_progress);
        }
        [self animateMethod];
    }
}

- (void)timerMethod
{

    if (_fromSmallToBig) {
        if (_progress >= _goalProgress) {
            [_timer invalidate];
            _progress = _goalProgress;
            return;
        } else {
            _progress += _countInstance/100;
        }
        
    } else {
        if (_progress <= _goalProgress) {
            [_timer invalidate];
            _progress = _goalProgress;
           return;
        } else {
            _progress -= _countInstance/100;
            
        }
    }
    /* block返回 */
    if (_progressBlock) {
        _progressBlock(_progress);
    }
    
}

#pragma mark - CAAnimationDelegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        /* block返回 */
        if (_finishedBlock) {
            _finishedBlock(YES);
        }
    } else {
        /* block返回 */
        if (_finishedBlock) {
            _finishedBlock(NO);
        }
    }
}


#pragma mark - Animate Method

- (void) animateMethod
{
    if (!_boundsAnimation) {
        _boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        _boundsAnimation.removedOnCompletion = NO;
        _boundsAnimation.fillMode = kCAFillModeForwards;
        _boundsAnimation.delegate = self;
    }
    _boundsAnimation.duration = _totalTimeInterval * fabs(_progress - _goalProgress);
    
    CGFloat fromWidth = self.frame.size.width * _progress;
    CGFloat toWidth = self.frame.size.width * _goalProgress;
    
    CGRect fromFrame = CGRectMake(0, 0, fromWidth, _foreView.frame.size.height);
    CGRect toFrame = CGRectMake(0, 0, toWidth, _foreView.frame.size.height);
    _boundsAnimation.fromValue = [NSValue valueWithCGRect:fromFrame];
    _boundsAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    
    [self.foreView.layer addAnimation:_boundsAnimation forKey:nil];

}

#pragma mark - Set Method

- (void)setForeColor:(UIColor *)foreColor{
    _foreColor = foreColor;
    _foreView.backgroundColor = foreColor;
}

/* 数数间隔 */
- (void)setCountInstance:(CGFloat)countInstance
{
    /* 限制范围为 0～50 % */
    if (countInstance>0 && countInstance<=50) {
        _countInstance = countInstance;
    }
}

- (void)dealloc
{
    if (_timer.valid) {
        [_timer invalidate];
        _timer = nil;
    }
    
}



@end
