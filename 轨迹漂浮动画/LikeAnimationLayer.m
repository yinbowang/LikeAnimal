//
//  LikeAnimationLayer.m
//  轨迹漂浮动画
//
//  Created by wyb on 2017/5/22.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import "LikeAnimationLayer.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height
static NSTimeInterval const liveAnimationDuration = 6;

@interface LikeAnimationLayer ()<CAAnimationDelegate>

@property(nonatomic,strong)UIView *superView;

@end

@implementation LikeAnimationLayer

- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.bounds = CGRectMake(0, 0, 40, 40);
        self.anchorPoint = CGPointMake(0.5, 1);
        //画路径，❤️
        self.path = [self likePath];
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 1.0;
        self.fillColor = [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:1].CGColor;
       self.superView = superView;
     
       
        
    }
    return self;
}

- (void)addAnimation
{
    
    CASpringAnimation *springAnimal = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    springAnimal.fromValue = @(0);
    springAnimal.toValue = @(1.0);
    //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大默认是1 必须大于0
//    若你设置的值小于0  会有CoreAnimation: mass must be greater than 0.这个信息提示你
//    并且把你的小于0的值改成1
//    对象质量 质量越大 弹性越大 需要的动画时间越长
    springAnimal.mass = 1.0;
//    必须大于0  默认是100
//    若设置的小于0 会给你一个提示 并把值改成100
//    刚度系数，刚度系数越大，产生形变的力就越大，运动越快。
    springAnimal.stiffness = 90;
//    默认是10 必须大于或者等于0
//    若设置的小于0 会给你一个提示 并把值改成10
//    阻尼系数 阻止弹簧伸缩的系数 阻尼系数越大，停止越快。时间越短
     springAnimal.damping = 10;
//    默认是0
//    初始速度，正负代表方向，数值代表大小
     springAnimal.initialVelocity = 2;
//    计算从开始到结束的动画的时间，根据当前的参数估算时间
//    只读的，不能赋值
     springAnimal.duration = springAnimal.settlingDuration;
    
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @0;
    alphaAnimation.toValue = @1;
    
    CAAnimationGroup *Scalegroup = [CAAnimationGroup animation];
    Scalegroup.animations = @[springAnimal,alphaAnimation];
    Scalegroup.duration = 0.5;
    Scalegroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self addAnimation:Scalegroup forKey:@"scaleAndalphaAnimation"];
    

    // 随机数（0，1）
    NSInteger i = arc4random_uniform(2);
    //移动的方向(-1 ,1)
    NSInteger moveDirection = 1 - (2*i);
    
    // 绘制路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    //先移动到心的中心点这是起点
    [heartTravelPath moveToPoint:self.position];
    
    CGPoint endPoint = CGPointMake(self.position.x + (moveDirection) * arc4random_uniform(kWidth), self.superView.frame.size.height/6.0 + arc4random_uniform(self.superView.frame.size.height/4.0));
    
    CGFloat x = (kWidth/2.0 + arc4random_uniform(kWidth)) * moveDirection;
    CGFloat y = MAX(endPoint.y ,MAX(arc4random_uniform(8*kWidth), kWidth));
    //两个控点
    CGPoint controlPoint1 = CGPointMake(self.position.x + x, self.superView.frame.size.height - y);
    CGPoint controlPoint2 = CGPointMake(self.position.x - 2*x, y);
    
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *positionGroup = [CAAnimationGroup animation];
    positionGroup.animations = @[keyFrameAnimation,opacityAnimation];
    positionGroup.duration = liveAnimationDuration + endPoint.y/self.superView.frame.size.height;
    positionGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    positionGroup.delegate = self;
    //如果不加这句[self animationForKey:@"ani1"]是nil
    positionGroup.removedOnCompletion = NO;
    positionGroup.fillMode = kCAFillModeForwards;
    //kvc记录layer的值方便在代理方法里移除
    [positionGroup setValue:self forKey:@"likeLayer"];
    [self addAnimation:positionGroup forKey:@"positionGroup"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([self animationForKey:@"positionGroup"] == anim) {
       
        CALayer *layer = [anim valueForKey:@"likeLayer"];
        if (layer) {
            [layer removeFromSuperlayer];
        }
    }
}




- (CGPathRef)likePath
{
    //心距离边缘的距离
    CGFloat drawingPadding = 2.0;
    //向下取整floor
    CGFloat curveRadius = floor((kWidth - 2*drawingPadding) / 4.0);
    UIBezierPath *path = [UIBezierPath bezierPath];
    //最下面的点（20，38）
     CGPoint tipLocation = CGPointMake(floor(kWidth / 2.0), kHeight - drawingPadding);
    [path moveToPoint:tipLocation];
    //左上的点（2，13）
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(kHeight / 3));
    //画二元曲线左边的心的曲线
    [path addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    //画左边上面的半圆
    [path addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    //右边的半圆
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
    [path addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    //画二元曲线右边的心的曲线
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [path addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;

    return path.CGPath;
}

@end
