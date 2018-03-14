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

//子类化CALayer时，有个地方要注意，因为CoreAnimation在生成中间帧的方式，是通过Copy操作生成了一大堆中间帧用的CALayer，它在复制CALayer的数据时，只能对CALayer原有的属性成员进行copy，不会copy后添加的诸如对象引用一类的东西，这就需要程序员重载
//出处:http://www.cnblogs.com/pengyingh/articles/2381698.html
- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if(self != nil) {
        CACircleLayer *myLayer = (CACircleLayer*)layer;
        self.progress = myLayer.progress;//自定义的属性需要自己复制
    }
    return self;
}


-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

//-(CGFloat)progress{
//    return _progress;
//}

//非常重要 识别自定义key是否被动画识别
+ (BOOL)needsDisplayForKey:(NSString *)key{
//    NSLog(@"__%s__ %@",__FUNCTION__,key);
    return [key isEqualToString:@"progress"]?YES:[super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx{
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
