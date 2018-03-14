
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
//    BOOL isAnimation;//
}

@property(nonatomic,retain)CACircleLayer* circleLayer;
@property(nonatomic,retain)CALayer* squareLayer;
@property(nonatomic,retain)CALayer* shapeLayer;
@property(nonatomic,retain)CALayer* laceBackLayer;
@property(nonatomic,retain)CACircleLayer* logoLayer;

//@property(nonatomic,retain)CAMediaTimingFunction* scaleTimingFunction;

#define MAX_LACE_SCALE 0.56
#define MIN_LACE_SCALE 0.42
#define FIRST_ANIMATION_DURATION 0.5
#define FIRST_ANIMATION_GAP 1.2 //第一组动画结束后的停顿间隔
#define TOTAL_ANIMATION_DURATION 3.3
#define CIRCLE_WIDTH 90.0
#define SQUARE_WIDTH 24.0
#define THEME_COLOR [UIColor colorWithRed:142.0/255 green:5.0/255 blue:0 alpha:1]

#define SCALE_TIMING_FUNCTION [CAMediaTimingFunction functionWithControlPoints:0.5 :0.2: 0.83:.6]

@end

@implementation SplashSourceTransport


//-(CAMediaTimingFunction *)scaleTimingFunction{
//    return [CAMediaTimingFunction functionWithControlPoints:0.5 :0.2: 0.83:.6];
//}

//-(UIColor *)themeColor{
//    if (!_themeColor) {
//        _themeColor = [UIColor colorWithRed:142.0/255 green:5.0/255 blue:0 alpha:1];
//    }
//    return _themeColor;
//}

-(CALayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [[CALayer alloc] init];
        _shapeLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _shapeLayer.cornerRadius = CIRCLE_WIDTH / 2.;
        
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

-(CALayer *)laceBackLayer{
    if (!_laceBackLayer) {
        _laceBackLayer = [[CALayer alloc] init];
        [self.layer addSublayer:_laceBackLayer];
    }
    return _laceBackLayer;
}

-(CACircleLayer *)logoLayer{
    if (!_logoLayer) {
        _logoLayer = [self createLogoBack:[UIColor whiteColor] subLayerColor:[UIColor blackColor]];
        [self.layer addSublayer:_logoLayer];
        
        CALayer* subSquareLayer = [[CALayer alloc] init];
        subSquareLayer.backgroundColor = [UIColor blackColor].CGColor;
        subSquareLayer.cornerRadius = 4;
        subSquareLayer.frame = CGRectMake((CIRCLE_WIDTH - SQUARE_WIDTH) / 2, (CIRCLE_WIDTH - SQUARE_WIDTH) / 2, SQUARE_WIDTH, SQUARE_WIDTH);
        [_logoLayer addSublayer:subSquareLayer];
    }
    return _logoLayer;
}

-(CACircleLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [self createLogoBack:[UIColor whiteColor] subLayerColor:THEME_COLOR];
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

-(CACircleLayer *)createLogoBack:(UIColor*)strokeColor  subLayerColor:(UIColor*)subLayerColor{
    CACircleLayer *layer = [[CACircleLayer alloc] init];
    layer.strokeColor = strokeColor.CGColor;
    layer.progress = 1;
    layer.lineWidth = CIRCLE_WIDTH / 2;
    //        _circleLayer.clipRectHeight = 6;
    CGFloat clipRectHeight = 6;
    
    CALayer* subLayer = [[CALayer alloc] init];
    subLayer.backgroundColor = subLayerColor.CGColor;
    subLayer.frame = CGRectMake(0, CIRCLE_WIDTH / 2. - clipRectHeight / 2., CIRCLE_WIDTH / 2., clipRectHeight);
    [layer addSublayer:subLayer];
    return layer;
}

-(CALayer *)squareLayer{
    if (!_squareLayer) {
        _squareLayer = [[CALayer alloc] init];
        _squareLayer.backgroundColor = THEME_COLOR.CGColor;
        _squareLayer.cornerRadius = 4;
        [self.layer addSublayer:_squareLayer];
    }
    return _squareLayer;
}

-(void)display{
    self.backgroundColor = [UIColor blackColor];//THEME_COLOR;//
    
    CGFloat screenWidth = CGRectGetWidth(self.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.bounds);
    
    self.laceBackLayer.frame = self.bounds;
    
    self.shapeLayer.frame = CGRectMake((screenWidth - CIRCLE_WIDTH) / 2, (screenHeight - CIRCLE_WIDTH) / 2, CIRCLE_WIDTH, CIRCLE_WIDTH);
    
    self.circleLayer.frame = CGRectMake((screenWidth - CIRCLE_WIDTH) / 2, (screenHeight - CIRCLE_WIDTH) / 2, CIRCLE_WIDTH, CIRCLE_WIDTH);
//    self.circleLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    self.squareLayer.frame = CGRectMake((screenWidth - SQUARE_WIDTH) / 2, (screenHeight - SQUARE_WIDTH) / 2, SQUARE_WIDTH, SQUARE_WIDTH);
    
    self.logoLayer.frame = self.circleLayer.frame;
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(),^(void){
        @strongify(self);
        [self animationLogo];
        [self initLaceLayer];
        [self animationShape];
        [self animationCircle];
        [self animationSquare];
    });
}

-(void)animationLogo{
    CABasicAnimation* an1Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an1Opacity.toValue = @0;
    an1Opacity.fillMode = kCAFillModeForwards;
    an1Opacity.duration = 0.3;
    an1Opacity.removedOnCompletion = NO;
    
    [self.logoLayer addAnimation:an1Opacity forKey:nil];
    
    CABasicAnimation* an1Color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    an1Color.toValue = (id)THEME_COLOR.CGColor;
    an1Color.fillMode = kCAFillModeForwards;
    an1Color.duration = 0.3;
    an1Color.removedOnCompletion = NO;
    
    [self.layer addAnimation:an1Color forKey:nil];
}

-(void)initLaceLayer{
    CGFloat diameter = CIRCLE_WIDTH * 2;
    
    CGFloat halfW = (CGRectGetWidth(self.bounds) - diameter * MIN_LACE_SCALE) / 2.;
    CGFloat halfH = (CGRectGetHeight(self.bounds) - diameter * MIN_LACE_SCALE) / 2.;
    
    int columns = ceil(halfW / (diameter * MIN_LACE_SCALE)) * 2 + 1;
    int rows = ceil(halfH / (diameter * MIN_LACE_SCALE)) * 2 + 1;
    
    UIColor* strokeColor = //[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [UIColor colorWithRed:253./255 green:100./255 blue:69./255 alpha:0.6];
    
    CGFloat offsetX = (columns * diameter * MIN_LACE_SCALE - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat offsetY = (rows * diameter * MIN_LACE_SCALE - CGRectGetHeight(self.bounds)) / 2.;
    
    for (int i = 0 ; i < columns; i ++) {
        for (int j = 0; j < rows; j ++) {
            LaceLayer* laceLayer = [[LaceLayer alloc] init];
            laceLayer.frame = CGRectMake(0,0, diameter, diameter);
            laceLayer.anchorPoint = CGPointMake(0, 0);
            laceLayer.position = CGPointMake(i * diameter * MIN_LACE_SCALE - offsetX, j * diameter * MIN_LACE_SCALE - offsetY);
            laceLayer.strokeColor = strokeColor.CGColor;
            [laceLayer setTransform:CATransform3DMakeScale(MIN_LACE_SCALE, MIN_LACE_SCALE, 1)];
            //[[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
            
            //    laceLayer.backgroundColor = [UIColor blueColor].CGColor;
            laceLayer.lineWidth = 1.8;
            [self.laceBackLayer addSublayer:laceLayer];
            
            [self animationLace:laceLayer diameter:diameter columns:columns rows:rows i:i j:j];
        }
    }
    
}

-(void)animationLace:(CALayer*)laceLayer diameter:(CGFloat)diameter columns:(int)columns rows:(int)rows i:(int)i j:(int)j {
    CAMediaTimingFunction* timingFunction = SCALE_TIMING_FUNCTION;//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    CGFloat maxOffsetX = (columns * diameter * MAX_LACE_SCALE - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat maxOffsetY = (rows * diameter * MAX_LACE_SCALE - CGRectGetHeight(self.bounds)) / 2.;
    
    CGFloat beginTime = 0;
    
    int centerColumn = columns / 2;
    int centerRow = rows / 2;
    
    CGPoint maxPoint = CGPointMake(i * diameter * MAX_LACE_SCALE - maxOffsetX, j * diameter * MAX_LACE_SCALE - maxOffsetY);
//    CGPoint centerPoint = CGPointMake(centerColumn * diameter * MAX_LACE_SCALE - offsetX, centerRow * diameter * MAX_LACE_SCALE - offsetY);
    
    CABasicAnimation* an1Point = [CABasicAnimation animationWithKeyPath:@"position"];
    an1Point.toValue = [NSValue valueWithCGPoint:maxPoint];
    an1Point.fillMode = kCAFillModeForwards;
    an1Point.duration = FIRST_ANIMATION_DURATION;
    an1Point.beginTime = beginTime;
//    an1Point.removedOnCompletion = NO;
    an1Point.timingFunction = timingFunction;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    an1Scale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(MAX_LACE_SCALE, MAX_LACE_SCALE, 1)];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = FIRST_ANIMATION_DURATION;
    an1Scale.beginTime = an1Point.beginTime;
    an1Scale.timingFunction = timingFunction;
    
    CGFloat largeScale = MAX_LACE_SCALE + 0.02;
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
    an2Point.beginTime = beginTime + FIRST_ANIMATION_DURATION + distance * gapTime;
    
    CAKeyframeAnimation* an2Scale = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    an2Scale.values = [NSMutableArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(MAX_LACE_SCALE,MAX_LACE_SCALE,1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(largeScale,largeScale,1)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(MAX_LACE_SCALE,MAX_LACE_SCALE,1)],
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
    
    CGFloat minOffsetX = (columns * diameter * MIN_LACE_SCALE - CGRectGetWidth(self.bounds)) / 2.;
    CGFloat minOffsetY = (rows * diameter * MIN_LACE_SCALE - CGRectGetHeight(self.bounds)) / 2.;
    CGPoint minPoint = CGPointMake(i * diameter * MIN_LACE_SCALE - minOffsetX, j * diameter * MIN_LACE_SCALE - minOffsetY);
    
    CABasicAnimation* an3Point = [CABasicAnimation animationWithKeyPath:@"position"];
    an3Point.toValue = [NSValue valueWithCGPoint:minPoint];
    an3Point.fillMode = kCAFillModeForwards;
    an3Point.duration = 0.01;
    an3Point.beginTime = an2Opacity.beginTime + an2Opacity.duration;
    
    CABasicAnimation* an3Scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    an3Scale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(MIN_LACE_SCALE, MIN_LACE_SCALE, 1)];
    an3Scale.fillMode = kCAFillModeForwards;
    an3Scale.duration = an3Point.duration;
    an3Scale.beginTime = an3Point.beginTime;
    
    CABasicAnimation* an3Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an3Opacity.toValue = @1;
    an3Opacity.fillMode = kCAFillModeForwards;
    an3Opacity.duration = 1.2;
    an3Opacity.beginTime = beginTime + FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP + 0.2;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Point,an1Scale,an2Point,an2Scale,an2Opacity,an3Point,an3Scale,an3Opacity];//
    group.duration = TOTAL_ANIMATION_DURATION;
    group.repeatCount = FLT_MAX;
    
    [laceLayer addAnimation:group forKey:nil];
}

-(void)animationShape{
    CABasicAnimation* an1Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an1Corner.fromValue = [NSNumber numberWithFloat:CIRCLE_WIDTH / 2.];
    an1Corner.toValue = @0;
    an1Corner.fillMode = kCAFillModeForwards;
    an1Corner.duration = FIRST_ANIMATION_DURATION;
    an1Corner.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an1Scale.fromValue = @0.8;
    CGFloat targetScale = SQUARE_WIDTH / CIRCLE_WIDTH - 0.1;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = FIRST_ANIMATION_DURATION;
    an1Scale.timingFunction = SCALE_TIMING_FUNCTION;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Corner,an1Scale];
    group.duration = TOTAL_ANIMATION_DURATION;
    group.repeatCount = FLT_MAX;
    
    [self.shapeLayer addAnimation:group forKey:nil];
}

-(void)animationSquare{
    
    CGFloat targetScale = (SQUARE_WIDTH / CIRCLE_WIDTH - 0.1);// * CIRCLE_WIDTH / SQUARE_WIDTH;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an1Scale.fromValue = @1;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = FIRST_ANIMATION_DURATION;
    an1Scale.timingFunction = SCALE_TIMING_FUNCTION;
    
    CABasicAnimation* an1Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an1Corner.fromValue = @4;
    an1Corner.toValue = @0;
    an1Corner.fillMode = kCAFillModeForwards;
    an1Corner.duration = FIRST_ANIMATION_DURATION;
    
    CABasicAnimation* an1Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an1Opacity.fromValue = @1;
    an1Opacity.toValue = @0;
    an1Opacity.fillMode = kCAFillModeForwards;
    an1Opacity.duration = 0.1;
    an1Opacity.beginTime = FIRST_ANIMATION_DURATION;
    
    CABasicAnimation* an2Color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    an2Color.fromValue = (id)[UIColor whiteColor].CGColor;
    an2Color.toValue = (id)THEME_COLOR.CGColor;
    an2Color.fillMode = kCAFillModeForwards;
    an2Color.duration = 0.6;
    an2Color.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;
    
    CABasicAnimation* an2Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an2Opacity.fromValue = @0.9;
    an2Opacity.toValue = @1;
    an2Opacity.fillMode = kCAFillModeForwards;
    an2Opacity.duration = 0.01;
    an2Opacity.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;
    
    
    targetScale = (SQUARE_WIDTH / CIRCLE_WIDTH - 0.1) * CIRCLE_WIDTH / SQUARE_WIDTH;
    CABasicAnimation* an2Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an2Scale.fromValue = [NSNumber numberWithFloat:targetScale];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8,0.8,0.5)];
    an2Scale.toValue = @1;
    an2Scale.fillMode = kCAFillModeForwards;
    an2Scale.duration = 0.2;
    an2Scale.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;
    
    CABasicAnimation* an2Corner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    an2Corner.fromValue = @0.0;
    an2Corner.toValue = @4;
    an2Corner.fillMode = kCAFillModeForwards;
    an2Corner.duration = 0.2;
    an2Corner.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Scale,an1Opacity,an1Corner,an2Scale,an2Opacity,an2Corner,an2Color];
    group.duration = TOTAL_ANIMATION_DURATION;
    group.repeatCount = FLT_MAX;
    
    [self.squareLayer addAnimation:group forKey:nil];
}

-(void)animationCircle{
    CABasicAnimation* an1Opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an1Opacity.fromValue = @1;
    an1Opacity.toValue = @0;
    an1Opacity.fillMode = kCAFillModeForwards;
    an1Opacity.duration = 0.1;
    an1Opacity.beginTime = FIRST_ANIMATION_DURATION;
    
    
    CGFloat targetScale = (SQUARE_WIDTH / CIRCLE_WIDTH - 0.1);// * CIRCLE_WIDTH / SQUARE_WIDTH;
    
    CABasicAnimation* an1Scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    an1Scale.fromValue = @1.0;
    an1Scale.toValue = [NSNumber numberWithFloat:targetScale];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(targetScale, targetScale, 0.5)];//@0;//
    an1Scale.fillMode = kCAFillModeForwards;
    an1Scale.duration = FIRST_ANIMATION_DURATION;
    an1Scale.timingFunction = SCALE_TIMING_FUNCTION;
    
//    CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:.55:.08:.68:.66];
    CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:.7:.38:.21:.96];
//    CAMediaTimingFunction* timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.4 :.21:.96];
    
    CABasicAnimation* an2Progress = [CABasicAnimation animationWithKeyPath:@"progress"];
    an2Progress.fromValue = @0;
    an2Progress.toValue = @1;
    an2Progress.duration = 1.5;
    an2Progress.fillMode = kCAFillModeForwards;
    an2Progress.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP + 0.2;
    
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
    an2Scale.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;
    
    CABasicAnimation* an2Rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    an2Rotation.fromValue = @-M_PI_2;
    an2Rotation.toValue = @0;
    an2Rotation.fillMode = kCAFillModeForwards;
    an2Rotation.duration = 1;
    an2Rotation.beginTime = FIRST_ANIMATION_DURATION + FIRST_ANIMATION_GAP;

    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[an1Opacity,an1Scale,an2Progress,an2Opacity,an2Scale,an2Rotation];//an1Progress,
    group.duration = TOTAL_ANIMATION_DURATION;
    group.repeatCount = FLT_MAX;
    
    [self.circleLayer addAnimation:group forKey:nil];
}

-(void)removeFromSuperview{
    for (CALayer* child in self.laceBackLayer.sublayers) {
        [child removeAllAnimations];
    }
    [self.layer removeAllAnimations];
    [self.logoLayer removeAllAnimations];
    [self.squareLayer removeAllAnimations];
    [self.circleLayer removeAllAnimations];
    [super removeFromSuperview];
}


@end
