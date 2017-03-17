//
//  iRonProgressView.h
//  iRonProgress
//
//  Created by IDSBG-00 on 2017/3/15.
//  Copyright © 2017年 iRonCheng. All rights reserved.
//

/*
 *       进度条：可实时获取当前进度 (iRonProgressView)
 *
 *      (自定义)
 ＊              精度间隔   : countInstance
 *           进度条走完时间  : totalTimeInterval
 *          每次是否从零开始 : returnZeroEachTime
 *               进度条颜色 : foreColoer
 */

#import <UIKit/UIKit.h>

/* progress - block */
typedef void (^Progress) (CGFloat progress);

typedef void (^Finished) (BOOL finished);

@interface iRonProgressView : UIView

/* 前景色 */
@property (nonatomic, strong) UIColor *foreColor;

/* 走完整个进度条的时间 */
@property (nonatomic, assign) NSTimeInterval totalTimeInterval;

/* 当前进度 -- 只读 */
@property (nonatomic, assign, readonly) CGFloat progress;

/* 计数的间隔 0.1% 1% 10% ... */
@property (nonatomic, assign) CGFloat countInstance;

/* 每次从零开始计数 */
@property (nonatomic, assign) BOOL returnZeroEachTime;

- (void)setProgress:(CGFloat)progress curretProgress:(Progress)curretProgress finished:(Finished)flag;


@end

