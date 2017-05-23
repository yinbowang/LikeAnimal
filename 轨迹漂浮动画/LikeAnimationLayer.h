//
//  LikeAnimationLayer.h
//  轨迹漂浮动画
//
//  Created by wyb on 2017/5/22.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface LikeAnimationLayer : CAShapeLayer

- (instancetype)initWithSuperView:(UIView *)superView;

/**
 给layer添加动画
 */
- (void)addAnimation;

@end
