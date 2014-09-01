//
//  XHCircleView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHCircleView.h"

@interface XHCircleView ()

@property (nonatomic, strong) NSNumber *currentAngle;

@end

@implementation XHCircleView

- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    if (_offsetY > 40) {
        [self.layer addAnimation:[self rotateAnimationWithAngle:_offsetY] forKey:@"rotate"];
    }
    else {
        [self setNeedsDisplay];
    }

}

- (CABasicAnimation *)rotateAnimationWithAngle:(CGFloat)argFloat {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.duration = 0.25;
    rotateAnimation.cumulative = YES;
    rotateAnimation.additive = YES;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAnimation.fromValue = self.currentAngle;
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * argFloat * 10 / 180];
    self.currentAngle = rotateAnimation.toValue;
    return rotateAnimation;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _heightBeginToRefresh = 40;
        _offsetY = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CABasicAnimation*)repeatRotateAnimation {
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotateAni.duration = 0.25;
    rotateAni.cumulative = YES;
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAni.toValue = [NSNumber numberWithFloat:M_PI / 2];
    rotateAni.repeatCount = MAXFLOAT;
    
    return rotateAni;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    CGContextSetLineWidth(context, self.circleLineWidth);
    
    static CGFloat radius = 9;
    if (self.refreshViewLayerType) {
        static CGFloat startAngle = M_PI / 2;
        CGFloat endAngle = (ABS(_offsetY) / _heightBeginToRefresh) * (M_PI * 19 / 10) + startAngle;
        CGContextAddArc(context, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2, radius, startAngle, endAngle, 0);
    } else {
        static CGFloat startAngle = 3 * M_PI / 2.0;
        CGFloat endAngle = (ABS(_offsetY) / _heightBeginToRefresh) * (M_PI * 19 / 10) + startAngle;
        CGContextAddArc(context, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2, radius, startAngle, endAngle, 0);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
