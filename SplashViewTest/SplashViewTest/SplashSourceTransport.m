
//
//  SplashSourceTransport.m
//  SplashViewTest
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SplashSourceTransport.h"
#import "CACircleLayer.h"
#import "extobjc.h"

@interface SplashSourceTransport (){
//    BOOL isAnimation;//私有临时属性
}

@property(nonatomic,retain)UIColor* themeColor;
@property(nonatomic,retain)CACircleLayer* circleLayer;
@property(nonatomic,retain)CAShapeLayer* squareLayer;
@property(nonatomic,retain)CAShapeLayer* shapeLayer;
@property(nonatomic,assign)CGFloat circleWidth;
@property(nonatomic,assign)CGFloat squareWidth;

@property(nonatomic,assign)double firstAnimationDuration;
@property(nonatomic,assign)double firstAnimationGap;
@property(nonatomic,assign)double totalAnimationDuration;

@end

@implementation SplashSourceTransport

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(double)firstAnimationDuration{
    return 0.2;
}

//第一组动画结束后的停顿间隔
-(double)firstAnimationGap{
    return 1;
}

-(double)totalAnimationDuration{
    return 3;
}

-(CGFloat)circleWidth{
    return 90;
}

-(CGFloat)squareWidth{
    return 24;
}

-(UIColor *)themeColor{
    if (!_themeColor) {
        _themeColor = [UIColor colorWithRed:142.0/255 green:5.0/255 blue:0 alpha:1];
    }
    return _themeColor;
}

-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer new];
        _shapeLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shapeLayer.cornerRadius = self.circleWidth / 2.;
        
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

-(CACircleLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CACircleLayer new];
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _circleLayer.fillColor = self.themeColor.CGColor;
        _circleLayer.progress = 1;
//        _circleLayer.clipRectHeight = 6;
        [self.layer addSublayer:_circleLayer];
        
        CGFloat clipRectHeight = 6;
        
        CALayer* subLayer = [CALayer new];
        subLayer.backgroundColor = self.themeColor.CGColor;
        subLayer.frame = CGRectMake(0, self.circleWidth / 2. - clipRectHeight / 2., self.circleWidth / 2., clipRectHeight);
        [self.circleLayer addSublayer:subLayer];
    }
    return _circleLayer;
}

-(CALayer *)squareLayer{
    if (!_squareLayer) {
        _squareLayer = [CAShapeLayer new];
        _squareLayer.backgroundColor = self.themeColor.CGColor;
        _squareLayer.cornerRadius = 4;
        [self.layer addSublayer:_squareLayer];
    }
    return _squareLayer;
}

-(void)display{
    self.backgroundColor = self.themeColor;//
    
    CGFloat screenWidth = CGRectGetWidth(self.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.bounds);
    
    self.shapeLayer.frame = CGRectMake((screenWidth - self.circleWidth) / 2, (screenHeight - self.circleWidth) / 2, self.circleWidth, self.circleWidth);
    
    self.circleLayer.lineWidth = self.circleWidth / 2;
    self.circleLayer.frame = CGRectMake((screenWidth - self.circleWidth) / 2, (screenHeight - self.circleWidth) / 2, self.circleWidth, self.circleWidth);
//    self.circleLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    self.squareLayer.frame = CGRectMake((screenWidth - self.squareWidth) / 2, (screenHeight - self.squareWidth) / 2, self.squareWidth, self.squareWidth);
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(),^(void){
        @strongify(self);
        [self animationShape];
        [self animationCircle];
        [self animationSquare];
    });
}

-(void)animationShape{
    CABasicAnimation* an1Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an1Corner.fromValue = [NSNumber numberWithFloat:self.circleWidth / 2.];
    an1Corner.toValue = @0;
    an1Corner.fillMode = kCAFillModeForwards;
    an1Corner.duration = self.firstAnimationDuration;
    an1Corner.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an1Scale.fromValue = @0.8;
    CGFloat targetScale = self.squareWidth / self.circleWidth - 0.1;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = self.firstAnimationDuration;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Corner,an1Scale];
    group.duration = self.totalAnimationDuration;
    group.repeatCount = FLT_MAX;
    
    [self.shapeLayer addAnimation:group forKey:nil];
}

-(void)animationSquare{
    
    CGFloat targetScale = (self.squareWidth / self.circleWidth - 0.1);// * self.circleWidth / self.squareWidth;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an1Scale.fromValue = @1;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = self.firstAnimationDuration;
    
    CABasicAnimation* an1Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an1Corner.fromValue = @4;
    an1Corner.toValue = @0;
    an1Corner.fillMode = kCAFillModeForwards;
    an1Corner.duration = self.firstAnimationDuration;
    
    CABasicAnimation* an1Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an1Opacity.fromValue = @1;
    an1Opacity.toValue = @0;
    an1Opacity.fillMode = kCAFillModeForwards;
    an1Opacity.duration = 0.1;
    an1Opacity.beginTime = self.firstAnimationDuration;
    
    CABasicAnimation* an2Color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    an2Color.fromValue = (id)[UIColor whiteColor].CGColor;
    an2Color.toValue = (id)self.themeColor.CGColor;
    an2Color.fillMode = kCAFillModeForwards;
    an2Color.duration = 0.6;
    an2Color.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
    CABasicAnimation* an2Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an2Opacity.fromValue = @0.9;
    an2Opacity.toValue = @1;
    an2Opacity.fillMode = kCAFillModeForwards;
    an2Opacity.duration = 0.01;
    an2Opacity.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
    
    targetScale = (self.squareWidth / self.circleWidth - 0.1) * self.circleWidth / self.squareWidth;
    CABasicAnimation* an2Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an2Scale.fromValue = [NSNumber numberWithFloat:targetScale];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8,0.8,0.5)];
    an2Scale.toValue = @1;
    an2Scale.fillMode = kCAFillModeForwards;
    an2Scale.duration = 0.2;
    an2Scale.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
    CABasicAnimation* an2Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an2Corner.fromValue = @0.0;
    an2Corner.toValue = @4;
    an2Corner.fillMode = kCAFillModeForwards;
    an2Corner.duration = 0.2;
    an2Corner.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
//    CAKeyframeAnimation* an1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    an1.values = [NSMutableArray arrayWithObjects:
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1,0.1,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9,0.9,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,0.5)],
//                  nil];
//    an1.beginTime = 0.3;
//    an1.duration = 0.3;
//    an1.fillMode = kCAFillModeForwards;
    
//    CAKeyframeAnimation* an2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    an2.values = [NSMutableArray arrayWithObjects:
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5,0.5,0.5)],
//                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0,0.0,0.5)],
//                  nil];
//    an2.duration = 0.3;
//    an2.beginTime = 6.5;
//    an2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    an2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Scale,an1Opacity,an1Corner,an2Scale,an2Opacity,an2Corner,an2Color];
    group.duration = self.totalAnimationDuration;
    group.repeatCount = FLT_MAX;
    
    [self.squareLayer addAnimation:group forKey:nil];
}

-(void)animationCircle{
    CABasicAnimation* an1Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an1Opacity.fromValue = @1;
    an1Opacity.toValue = @0;
    an1Opacity.fillMode = kCAFillModeForwards;
    an1Opacity.duration = 0.1;
    an1Opacity.beginTime = self.firstAnimationDuration;
    
    
    CABasicAnimation* an1Progress = [CABasicAnimation animationWithKeyPath:@"progress"];
    an1Progress.fromValue = @1;
    an1Progress.toValue = @1;
    an1Progress.duration = self.firstAnimationDuration;
    an1Progress.fillMode = kCAFillModeForwards;
    
    CGFloat targetScale = (self.squareWidth / self.circleWidth - 0.1);// * self.circleWidth / self.squareWidth;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    an1Scale.fromValue = @1.0;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(targetScale, targetScale, 0.5)];//@0;//
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = self.firstAnimationDuration;
    
//    CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:.55:.08:.68:.66];
    CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:.7:.38:.21:.96];
    
    CABasicAnimation* an2Progress = [CABasicAnimation animationWithKeyPath:@"progress"];
    an2Progress.fromValue = @0;
    an2Progress.toValue = @1;
    an2Progress.duration = 1.2;
    an2Progress.fillMode = kCAFillModeForwards;
    an2Progress.beginTime = self.firstAnimationDuration + self.firstAnimationGap + 0.2;
    
    an2Progress.timingFunction = timingFunction;
    
    CABasicAnimation* an2Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an2Opacity.fromValue = @0.9;
    an2Opacity.toValue = @1;
    an2Opacity.fillMode = kCAFillModeForwards;
    an2Opacity.duration = 0.01;
    an2Opacity.beginTime = an2Progress.beginTime;
    
    //[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation* an2Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an2Scale.fromValue = @0;
    an2Scale.toValue = @1;
    an2Scale.fillMode = kCAFillModeForwards;
    an2Scale.duration = 1;
    an2Scale.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
    CABasicAnimation* an2Rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    an2Rotation.fromValue = @-M_PI_2;
    an2Rotation.toValue = @0;
    an2Rotation.fillMode = kCAFillModeForwards;
    an2Rotation.duration = 1;
    an2Rotation.beginTime = self.firstAnimationDuration + self.firstAnimationGap;
    
//    an1Rotation.timingFunction = timingFunction;
    
//    CABasicAnimation* an2 = [CABasicAnimation animationWithKeyPath:@"progress"];
//    an2.fromValue = @1;
//    an2.toValue = @0;
//    an2.duration = 0.3;
//    an2.beginTime = 6;
//    an2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Progress,an1Opacity,an1Scale,an2Progress,an2Opacity,an2Scale,an2Rotation];//
    group.duration = self.totalAnimationDuration;
    group.repeatCount = FLT_MAX;
    
    [self.circleLayer addAnimation:group forKey:nil];
}

-(void)removeFromSuperview{
    [self.squareLayer removeAllAnimations];
    [self.circleLayer removeAllAnimations];
    [super removeFromSuperview];
}


@end
