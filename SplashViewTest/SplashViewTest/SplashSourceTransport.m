
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
#import "LaceLayer.h"

@interface SplashSourceTransport (){
//    BOOL isAnimation;//私有临时属性
}

@property(nonatomic,retain)UIColor* themeColor;
@property(nonatomic,retain)CACircleLayer* circleLayer;
@property(nonatomic,retain)CAShapeLayer* squareLayer;
@property(nonatomic,retain)CAShapeLayer* shapeLayer;
@property(nonatomic,retain)CALayer* laceBackLayer;
@property(nonatomic,assign)CGFloat circleWidth;
@property(nonatomic,assign)CGFloat squareWidth;

@property(nonatomic,assign)double firstAnimationDuration;
@property(nonatomic,assign)double firstAnimationGap;
@property(nonatomic,assign)double totalAnimationDuration;
@property(nonatomic,assign)CGFloat maxLaceScale;
@property(nonatomic,assign)CGFloat minLaceScale;

@end

@implementation SplashSourceTransport

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGFloat)maxLaceScale{
    return 0.56;
}

-(CGFloat)minLaceScale{
    return 0.42;
}

-(double)firstAnimationDuration{
    return 0.5;
}

//第一组动画结束后的停顿间隔
-(double)firstAnimationGap{
    return 1.2;
}

-(double)totalAnimationDuration{
    return 3.3;
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

-(CALayer *)laceBackLayer{
    if (!_laceBackLayer) {
        _laceBackLayer = [CALayer new];
        [self.layer addSublayer:_laceBackLayer];
    }
    return _laceBackLayer;
}

-(CACircleLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CACircleLayer new];
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
//        _circleLayer.fillColor = self.themeColor.CGColor;
        _circleLayer.progress = 1;
        _circleLayer.lineWidth = self.circleWidth / 2;
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
    
    self.laceBackLayer.frame = self.bounds;
    
    self.shapeLayer.frame = CGRectMake((screenWidth - self.circleWidth) / 2, (screenHeight - self.circleWidth) / 2, self.circleWidth, self.circleWidth);
    
    self.circleLayer.frame = CGRectMake((screenWidth - self.circleWidth) / 2, (screenHeight - self.circleWidth) / 2, self.circleWidth, self.circleWidth);
//    self.circleLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    self.squareLayer.frame = CGRectMake((screenWidth - self.squareWidth) / 2, (screenHeight - self.squareWidth) / 2, self.squareWidth, self.squareWidth);
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(),^(void){
        @strongify(self);
        [self initLaceLayer];
        [self animationShape];
        [self animationCircle];
        [self animationSquare];
    });
}

-(void)initLaceLayer{
    CGFloat diameter = self.circleWidth * 2;
    
    CGFloat halfW = (CGRectGetWidth(self.bounds) - diameter * self.minLaceScale) / 2.;
    CGFloat halfH = (CGRectGetHeight(self.bounds) - diameter * self.minLaceScale) / 2.;
    
    int columns = ceil(halfW / (diameter * self.minLaceScale)) * 2 + 1;
    int rows = ceil(halfH / (diameter * self.minLaceScale)) * 2 + 1;
    
    UIColor* strokeColor = //[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [UIColor colorWithRed:253./255 green:100./255 blue:69./255 alpha:0.6];
    
    CGFloat offsetX = (columns * diameter * self.minLaceScale - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat offsetY = (rows * diameter * self.minLaceScale - CGRectGetHeight(self.bounds)) / 2.;
    
    for (int i = 0 ; i < columns; i ++) {
        for (int j = 0; j < rows; j ++) {
            LaceLayer* laceLayer = [[LaceLayer alloc] init];
            laceLayer.frame = CGRectMake(0,0, diameter, diameter);
            laceLayer.anchorPoint = CGPointMake(0, 0);
            laceLayer.position = CGPointMake(i * diameter * self.minLaceScale - offsetX, j * diameter * self.minLaceScale - offsetY);
            laceLayer.strokeColor = strokeColor.CGColor;
            [laceLayer setTransform:CATransform3DMakeScale(self.minLaceScale, self.minLaceScale, 1)];
            //[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
            
            //    laceLayer.backgroundColor = [UIColor blueColor].CGColor;
            laceLayer.lineWidth = 1.8;
            [self.laceBackLayer addSublayer:laceLayer];
            
            [self animationLace:laceLayer diameter:diameter columns:columns rows:rows i:i j:j];
        }
    }
    
}

-(void)animationLace:(CALayer*)laceLayer diameter:(CGFloat)diameter columns:(int)columns rows:(int)rows i:(int)i j:(int)j {
    CAMediaTimingFunction* timingFunction = //[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [CAMediaTimingFunction functionWithControlPoints:0.5 :0.2: 0.85:.4];
    
    CGFloat maxOffsetX = (columns * diameter * self.maxLaceScale - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat maxOffsetY = (rows * diameter * self.maxLaceScale - CGRectGetHeight(self.bounds)) / 2.;
    
    CGFloat beginTime = 0;
    
    int centerColumn = columns / 2;
    int centerRow = rows / 2;
    
    CGPoint maxPoint = CGPointMake(i * diameter * self.maxLaceScale - maxOffsetX, j * diameter * self.maxLaceScale - maxOffsetY);
//    CGPoint centerPoint = CGPointMake(centerColumn * diameter * self.maxLaceScale - offsetX, centerRow * diameter * self.maxLaceScale - offsetY);
    
    CABasicAnimation* an1Point = [CABasicAnimation animationWithKeyPath:@"position"];
    an1Point.toValue = [NSValue valueWithCGPoint:maxPoint];
    an1Point.fillMode = kCAFillModeForwards;
    an1Point.duration = self.firstAnimationDuration;
    an1Point.beginTime = beginTime;
//    an1Point.removedOnCompletion = NO;
    an1Point.timingFunction = timingFunction;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    an1Scale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.maxLaceScale, self.maxLaceScale, 1)];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = self.firstAnimationDuration;
    an1Scale.beginTime = an1Point.beginTime;
    an1Scale.timingFunction = timingFunction;
    
    CGFloat largeScale = self.maxLaceScale + 0.02;
    CGFloat largeOffsetX = (columns * diameter * largeScale - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat largeOffsetY = (rows * diameter * largeScale - CGRectGetHeight(self.bounds)) / 2.;
    
    CGFloat distance = sqrt((centerColumn - i) * (centerColumn - i) + (centerRow - j) * (centerRow - j));
    CGFloat gapTime = 0.05;
    
    CAKeyframeAnimation* an2Point = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    an2Point.values = [NSMutableArray arrayWithObjects:
                       [NSValue valueWithCGPoint:maxPoint],
                       [NSValue valueWithCGPoint:CGPointMake(i * diameter * largeScale - largeOffsetX, j * diameter * largeScale - largeOffsetY)],
                       [NSValue valueWithCGPoint:maxPoint],
                       nil];
    an2Point.duration = 0.3;
    an2Point.fillMode = kCAFillModeForwards;
    an2Point.beginTime = beginTime + self.firstAnimationDuration + distance * gapTime;
    
    CAKeyframeAnimation* an2Scale = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    an2Scale.values = [NSMutableArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.maxLaceScale,self.maxLaceScale,1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(largeScale,largeScale,1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.maxLaceScale,self.maxLaceScale,1)],
                       nil];
    an2Scale.duration = an2Point.duration;
//    an2Scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    an2Scale.fillMode = kCAFillModeForwards;
    an2Scale.beginTime = an2Point.beginTime;
    
    CABasicAnimation* an2Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an2Opacity.toValue = @0;
    an2Opacity.fillMode = kCAFillModeForwards;
    an2Opacity.duration = 0.5;
    an2Opacity.beginTime = an2Scale.beginTime;
    
    CGFloat minOffsetX = (columns * diameter * self.minLaceScale - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat minOffsetY = (rows * diameter * self.minLaceScale - CGRectGetHeight(self.bounds)) / 2.;
    CGPoint minPoint = CGPointMake(i * diameter * self.minLaceScale - minOffsetX, j * diameter * self.minLaceScale - minOffsetY);
    
    CABasicAnimation* an3Point = [CABasicAnimation animationWithKeyPath:@"position"];
    an3Point.toValue = [NSValue valueWithCGPoint:minPoint];
    an3Point.fillMode = kCAFillModeForwards;
    an3Point.duration = 0.01;
    an3Point.beginTime = an2Opacity.beginTime + an2Opacity.duration;
    
    CABasicAnimation* an3Scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    an3Scale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(self.minLaceScale, self.minLaceScale, 1)];
    an3Scale.fillMode = kCAFillModeForwards;
    an3Scale.duration = an3Point.duration;
    an3Scale.beginTime = an3Point.beginTime;
    
    CABasicAnimation* an3Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an3Opacity.toValue = @1;
    an3Opacity.fillMode = kCAFillModeForwards;
    an3Opacity.duration = 1.2;
    an3Opacity.beginTime = beginTime + self.firstAnimationDuration + self.firstAnimationGap + 0.2;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Point,an1Scale,an2Point,an2Scale,an2Opacity,an3Point,an3Scale,an3Opacity];//
    group.duration = self.totalAnimationDuration;
    group.repeatCount = FLT_MAX;
    
    [laceLayer addAnimation:group forKey:nil];
    
    
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
    
    
//    CABasicAnimation* an1Progress = [CABasicAnimation animationWithKeyPath:@"progress"];
//    an1Progress.fromValue = @1;
//    an1Progress.toValue = @1;
//    an1Progress.duration = self.firstAnimationDuration;
//    an1Progress.fillMode = kCAFillModeForwards;
    
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
    group.animations = @[an1Opacity,an1Scale,an2Progress,an2Opacity,an2Scale,an2Rotation];//an1Progress,
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
