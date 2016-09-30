//
//  CACircleLayer.m
//  SplashViewTest
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "CACircleLayer.h"

@interface CACircleLayer(){
//    CGFloat _progress;
}
@end
@implementation CACircleLayer


-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

//-(CGFloat)progress{
//    return _progress;
//}

//-(void)setLineWidth:(CGFloat)lineWidth{
//    self.lineWidth = lineWidth;
//    [self setNeedsDisplay];
//}
//
//-(void)setStrokeColor:(CGColorRef)strokeColor{
//    self._strokeColor = strokeColor;
//    [self setNeedsDisplay];
//}

//非常重要 识别自定义key是否被动画识别
+ (BOOL)needsDisplayForKey:(NSString *)key{
//    NSLog(@"__%s__ %@",__FUNCTION__,key);
    return [key isEqualToString:@"progress"]?YES:[super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx{
//        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:self.frame];
//    CGPoint arcCenter = CGPointMake(self.frame.origin.x - self.frame.size.width / 2, self.frame.origin.y - self.frame.size.height / 2);
//    CGFloat radius = self.frame.size.width / 2 - self.lineWidth / 2;
//    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:self.progress clockwise:false];
//    self.strokeStart = 0;
//    self.strokeEnd = self.progress;
//    self.fillColor = [UIColor clearColor].CGColor;
//    self.path = path.CGPath;
    
    CGFloat minWidth = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat line = self.lineWidth ;
    if (line > minWidth / 2) {
        line = minWidth / 2;
    }
    CGFloat radius = minWidth / 2 - line / 2. - 1;
    CGContextSetLineWidth(ctx,line);
    CGContextSetStrokeColorWithColor(ctx,self.strokeColor);//
    CGFloat startAngle = M_PI;//M_PI_2 * 3;
    CGFloat endAngle = startAngle + M_PI * 2 * self.progress;
    CGContextAddArc(ctx,CGRectGetWidth(self.bounds) / 2.,CGRectGetHeight(self.bounds) / 2.,radius, startAngle, endAngle ,0);
//    CGContextSetAllowsAntialiasing(ctx,NO);//关闭抗锯齿
    CGContextStrokePath(ctx);
    
//    CGFloat clipRectHeight = 6;
////    CGContextClearRect(ctx,CGRectMake(0, CGRectGetHeight(self.bounds) / 2. - clipRectHeight / 2., CGRectGetWidth(self.bounds) / 2., clipRectHeight));
//    CGContextSetFillColorWithColor(ctx, self.fillColor);
//    CGContextFillRect(ctx,CGRectMake(0, CGRectGetHeight(self.bounds) / 2. - clipRectHeight / 2., CGRectGetWidth(self.bounds) / 2., clipRectHeight));
//    CGContextStrokePath(ctx);
}

@end
