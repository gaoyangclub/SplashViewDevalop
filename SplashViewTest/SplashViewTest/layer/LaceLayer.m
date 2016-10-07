//
//  LaceLayer.m
//  SplashViewTest
//
//  Created by 高扬 on 16/10/1.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "LaceLayer.h"

@interface LaceLayer(){

    
}
@end

@implementation LaceLayer

-(void)setStrokeColor:(CGColorRef)strokeColor{
    [super setStrokeColor:strokeColor];
    [self setNeedsDisplay];
}

-(void)setLineWidth:(CGFloat)lineWidth{
    [super setLineWidth:lineWidth];
    [self setNeedsDisplay];
}

//
-(void)drawInContext:(CGContextRef)ctx{
    
//    self.strokeColor
    CGFloat minWidth = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat circleRadius = minWidth / 2. / 3.;//半径为1/3
    CGFloat line = self.lineWidth;
    if (line <= 0) {
        line = 0.5;
    }
    
    [self drawRoundCircle:ctx circleRadius:circleRadius lineWidth:line];
    [self drawSideLine:ctx circleRadius:circleRadius lineWidth:line];
    [self drawArc:ctx circleRadius:circleRadius lineWidth:line];
    
}

//绘制四个圈圈
-(void)drawRoundCircle:(CGContextRef)ctx circleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth{
    CGFloat centerX = CGRectGetWidth(self.bounds) / 2 - circleRadius;
    CGFloat centerY = CGRectGetHeight(self.bounds) / 2 - circleRadius;
    
    
//    CGContextSetAllowsAntialiasing(ctx,NO);//关闭抗锯齿
    
    CGContextSetLineWidth(ctx,lineWidth);
    CGContextSetStrokeColorWithColor(ctx,self.strokeColor);//
    
    CGContextAddEllipseInRect(ctx, CGRectMake(centerX - circleRadius, centerY, circleRadius * 2, circleRadius * 2));//左边
    CGContextAddEllipseInRect(ctx, CGRectMake(centerX + circleRadius, centerY, circleRadius * 2, circleRadius * 2));//右边
    CGContextAddEllipseInRect(ctx, CGRectMake(centerX, centerY - circleRadius, circleRadius * 2, circleRadius * 2));//上边
    CGContextAddEllipseInRect(ctx, CGRectMake(centerX, centerY + circleRadius, circleRadius * 2, circleRadius * 2));//下边
    
    CGContextStrokePath(ctx);
    
}


-(void)drawSideLine:(CGContextRef)ctx circleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth{
    CGFloat centerX = CGRectGetWidth(self.bounds) / 2.;
    CGFloat centerY = CGRectGetHeight(self.bounds) / 2.;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGContextSetLineWidth(ctx,lineWidth);
    CGContextSetStrokeColorWithColor(ctx,self.strokeColor);//
    
    CGContextMoveToPoint(ctx, 0, centerY);
    CGContextAddLineToPoint(ctx, circleRadius, centerY);
    CGContextMoveToPoint(ctx, centerX + circleRadius * 2, centerY);
    CGContextAddLineToPoint(ctx, width, centerY);
    
    CGContextMoveToPoint(ctx, circleRadius * 2, 0);
    CGContextAddLineToPoint(ctx, width - circleRadius * 2, 0);
    CGContextMoveToPoint(ctx, circleRadius * 2, height);
    CGContextAddLineToPoint(ctx, width - circleRadius * 2, height);
    
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx,lineWidth * 2);
    CGContextMoveToPoint(ctx, centerX, 0);
    CGContextAddLineToPoint(ctx, centerX, circleRadius);
    CGContextMoveToPoint(ctx, centerX, centerY + circleRadius * 2);
    CGContextAddLineToPoint(ctx, centerX, height);
    
    CGContextMoveToPoint(ctx, 0, circleRadius * 2);
    CGContextAddLineToPoint(ctx, 0, height - circleRadius * 2);
    CGContextMoveToPoint(ctx, width, circleRadius * 2);
    CGContextAddLineToPoint(ctx, width, height - circleRadius * 2);
    
    CGContextStrokePath(ctx);
}

-(void)drawArc:(CGContextRef)ctx circleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth{

    CGContextSetLineWidth(ctx,lineWidth * 2);
    CGContextSetStrokeColorWithColor(ctx,self.strokeColor);//
    
    CGFloat centerX = CGRectGetWidth(self.bounds) / 2.;
    CGFloat centerY = CGRectGetHeight(self.bounds) / 2.;
    
    CGContextAddArc(ctx,centerX - circleRadius,centerY,circleRadius, M_PI, M_PI * 2 ,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,centerX + circleRadius,centerY,circleRadius, 0, M_PI ,0);
    CGContextStrokePath(ctx);
    
    CGContextAddArc(ctx,centerX,centerY - circleRadius,circleRadius, M_PI_2, M_PI_2 + M_PI,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,centerX,centerY + circleRadius,circleRadius, M_PI + M_PI_2, M_PI * 2 + M_PI_2,0);
    CGContextStrokePath(ctx);
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    //右上
    CGContextAddArc(ctx,width - circleRadius,0,circleRadius, 0, M_PI ,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,width,circleRadius,circleRadius, M_PI_2, M_PI + M_PI_2 ,0);
    CGContextStrokePath(ctx);
    //左下
    CGContextAddArc(ctx,circleRadius,height,circleRadius, M_PI, M_PI * 2 ,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,0,height - circleRadius,circleRadius, M_PI + M_PI_2, M_PI * 2 + M_PI_2,0);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx,lineWidth);
    //左上
    CGContextAddArc(ctx,circleRadius,0,circleRadius, 0, M_PI ,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,0,circleRadius,circleRadius, M_PI + M_PI_2, M_PI * 2 + M_PI_2  ,0);
    CGContextStrokePath(ctx);
    //右下
    CGContextAddArc(ctx,width - circleRadius,height,circleRadius, M_PI, M_PI * 2 ,0);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx,width, height - circleRadius,circleRadius, M_PI_2, M_PI + M_PI_2  ,0);
    CGContextStrokePath(ctx);
    
}


@end
