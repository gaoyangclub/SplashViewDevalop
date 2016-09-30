//
//  SplashViewController.m
//  SplashViewTest
//
//  Created by admin on 16/9/27.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "SplashViewController.h"
#import "extobjc.h"

@interface SplashViewController ()<SplashControllerDelegate>{
    BOOL isFinishing;//私有变量
}

@end

@implementation SplashViewController

-(void)setSourceView:(SplashSourceView *)sourceView{
    _sourceView = sourceView;
    if (sourceView.superview != self.view) {
        [self.view addSubview:sourceView];//添加到显示列表
    }
    sourceView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sourceView != NULL) {
        self.sourceView.frame = self.view.bounds;
        
        [self startAnimation];//动画开始
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//播放结束动画
-(void)finish{
    if (!isFinishing) {
        isFinishing = true;
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 delay:300000 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //        [self setX:-kScreen_Width];
            weakSelf.sourceView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.view removeFromSuperview];
            if (weakSelf.completeHandler) {
                weakSelf.completeHandler(self);
            }
        }];
    }
}

- (void)startAnimation{
    self.sourceView.alpha = 0.99;
    
//    __weak __typeof(self) weakSelf = self;
//    __strong __typeof(self) strongSelf = weakSelf;
//    @weakify(self);
    [UIView animateWithDuration:0.6 animations:^{
        self.sourceView.alpha = 1.0;
    } completion:^(BOOL finished) {
//        @strongify(self);
        [self finish];
    }];
}

+(instancetype)initBySourceView:(UIView*)superView andSource:(SplashSourceView*)sourceView{
    SplashViewController* splashView = [SplashViewController new];
    splashView.view.frame = superView.bounds;//全屏

    splashView.sourceView = sourceView;
    
    [superView addSubview:splashView.view];//添加子对象
    [superView bringSubviewToFront:splashView.view];//置顶
    
    [splashView viewDidLoad];
    
    [sourceView display];
    
    return splashView;
}

@end
