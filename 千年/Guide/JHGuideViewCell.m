//
//  JHGuideViewCell.m
//  Biu
//
//  Created by he on 16/1/26.
//  Copyright © 2016年 he. All rights reserved.
//

#import "JHGuideViewCell.h"

//#import "AppDelegate.h"
//#import "JHTabBarController.h"
#import "TabBarViewController.h"
@interface JHGuideViewCell()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *useButton;

@end


@implementation JHGuideViewCell

- (UIImageView *)imageView{
    if (_imageView==nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageV;
        
        //
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}


- (UIButton *)useButton{
 
    if (_useButton==nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(75, self.frame.size.height-100, self.frame.size.width-150, 50)];
        [button setBackgroundImage:[UIImage imageNamed:@"practice"] forState:UIControlStateNormal];
        //button的事件放在controller中处理
        //传递方式：1.target:self 通过代理传递事件 2:target:controller action写在controller中
        [button addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        _useButton = button;
        
        
        [self addSubview:_useButton];
    }
    
    return _useButton;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}


/**
 *  判断当前的cell是最后一张引导页
 */
- (void)setCurrentIndex:(int)currentIndex{
    _currentIndex = currentIndex;
    //如果是最后一张图片
    if (_currentIndex==2) {
        //添加进入按钮
        [self useButton];
    }else{
        if (_useButton) {
            [_useButton removeFromSuperview];
        }
    }
}


- (void)goToMainView
{
    //更改根视图控制器
    //1.(window->App(UIApplication)Delegate)
    TabBarViewController *tabBarController = [[TabBarViewController alloc] init];
    self.window.rootViewController = tabBarController;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"1" forKey:@"FirstTime"];
    [defaults synchronize];
}



@end
