//
//  SplashViewController.h
//  SplashViewTest
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashSourceView.h"

@class SplashViewController;

typedef void(^SplashFinishHandler)(SplashViewController*);

@interface SplashViewController : UIViewController

@property(nonatomic,retain)SplashSourceView* sourceView;//显示内容区域
@property(nonatomic,copy)SplashFinishHandler completeHandler;//完成后回调
//@property()

-(void)finish;

+(instancetype)initBySourceView:(UIView*)superView andSource:(SplashSourceView*)sourceView;

@end
