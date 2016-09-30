//
//  SplashSourceView.h
//  SplashViewTest
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplashControllerDelegate <NSObject>
@optional
-(void)finish;//点击结束
@end

@interface SplashSourceView : UIView

@property (nonatomic, weak) id<SplashControllerDelegate> delegate;

-(void)display;

@end
