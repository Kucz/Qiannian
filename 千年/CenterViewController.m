//
//  CenterViewController.m
//  千年
//
//  Created by God on 16/1/4.
//  Copyright © 2016年 God. All rights reserved.
//

#import "CenterViewController.h"
#import "AddGoodsViewController.h"
#import "ClassView.h"
#import "EightModel.h"
#import "UIButton+WebCache.h"
@interface CenterViewController ()
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation CenterViewController

-(NSArray *)titlesArray
{
    if(_titlesArray == nil)
    {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [EightModel Getdata];
    
    [self SetUpView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateButton:) name:@"eight" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)UpdateButton:(NSNotification *)notification
{
    CGFloat Magin = 10;
    CGFloat ViewWidth = (winWidth - 5*10)/4;
    CGFloat ViewHeight = ViewWidth + 30;
    self.titlesArray = notification.object;
    for(UIView *view in [self.view subviews])
    {
        if(view.tag>10000&&view.tag<10009)
        {
            EightModel *model = self.titlesArray[view.tag-10001];
            ClassView *classview = (ClassView *)view;
            [classview.classBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.class_image,Base_url]] forState:UIControlStateNormal]
            ;
            classview.classLab.text = model.class_name;
            
            [classview.classBtn addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
            classview.classBtn.layer.cornerRadius = classview.classBtn.bounds.size.width/2;
            classview.classBtn.layer.masksToBounds = YES;
            classview.classBtn.tag = classview.tag-10001;
            [UIView animateWithDuration:0.5 animations:^{
                switch (classview.tag) {
                    case 10001:
                        classview.transform = CGAffineTransformMakeTranslation(ViewWidth+Magin, winHeight/2-5-ViewHeight);
                        break;
                    case 10002:
                        classview.transform = CGAffineTransformMakeTranslation(ViewWidth+2*Magin, winHeight/2-5);
                        break;
                    case 10003:
                        classview.transform = CGAffineTransformMakeTranslation(3*ViewWidth+3*Magin-winWidth, winHeight/2-5);
                        break;
                    case 10004:
                        classview.transform = CGAffineTransformMakeTranslation(3*ViewWidth+4*Magin-winWidth, winHeight/2-5-ViewHeight);
                        break;
                    case 10005:
                        classview.transform = CGAffineTransformMakeTranslation(ViewWidth+Magin, ViewHeight+5-winHeight/2);
                        break;
                    case 10006:
                        classview.transform = CGAffineTransformMakeTranslation(ViewWidth+2*Magin, 5-winHeight/2);
                        break;
                    case 10007:
                        classview.transform = CGAffineTransformMakeTranslation(3*(ViewWidth+Magin)-winWidth, 5-winHeight/2);
                        break;
                    case 10008:
                        classview.transform = CGAffineTransformMakeTranslation(3*ViewWidth+4*Magin-winWidth, 5+ViewHeight-winHeight/2);
                        break;
                    default:
                        break;
                }
            }];

        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)SetUpView
{
    CGFloat ViewWidth = (winWidth - 5*10)/4;
    CGFloat ViewHeight = ViewWidth + 30;
    
    ClassView *classView1 = [[ClassView alloc] initWithFrame:CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight)];
    classView1.tag = 10001;
    ClassView *classView2 = [[ClassView alloc] initWithFrame:CGRectMake(0, -ViewHeight, ViewWidth, ViewHeight)];
    classView2.tag = 10002;
    
    ClassView *classView3 = [[ClassView alloc] initWithFrame:CGRectMake(winWidth-ViewWidth, -ViewHeight, ViewWidth, ViewHeight)];
    classView3.tag = 10003;
    
    ClassView *classView4 = [[ClassView alloc] initWithFrame:CGRectMake(winWidth, 0, ViewWidth, ViewHeight)];
    classView4.tag = 10004;
    
    ClassView *classView5 = [[ClassView alloc] initWithFrame:CGRectMake(-ViewWidth, winHeight-ViewHeight, ViewWidth, ViewHeight)];
    classView5.tag = 10005;
    
    ClassView *classView6 = [[ClassView alloc] initWithFrame:CGRectMake(0, winHeight, ViewWidth, ViewHeight)];
    classView6.tag = 10006;
    ClassView *classView7 = [[ClassView alloc] initWithFrame:CGRectMake(winWidth-ViewWidth, winHeight, ViewWidth, ViewHeight)];
    classView7.tag = 10007;
    
    ClassView *classView8 = [[ClassView alloc] initWithFrame:CGRectMake(winWidth, winHeight-ViewHeight, ViewWidth, ViewHeight)];
    classView8.tag = 10008;
    
    [self.view addSubview:classView1];
    [self.view addSubview:classView2];
    [self.view addSubview:classView3];
    [self.view addSubview:classView4];
    [self.view addSubview:classView5];
    [self.view addSubview:classView6];
    [self.view addSubview:classView7];
    [self.view addSubview:classView8];
//    Color.rgb(51, 175, 252)
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0]];
}

-(void)pushViewController:(UIButton *)sender
{
    UIButton *addButton = (UIButton *)sender;
    EightModel *model = self.titlesArray[addButton.tag];
    AddGoodsViewController *GoodsVC = [[AddGoodsViewController alloc]init];
    GoodsVC.Goodsclass = model.class_name;
    [self presentViewController:GoodsVC animated:YES completion:nil];
}

- (IBAction)Back_action:(id)sender {
    
    for(UIView *view in [self.view subviews])
    {
        if(view.tag>10000&&view.tag<10009)
        {
            ClassView *classview = (ClassView *)view;
            [UIView animateWithDuration:0.5 animations:^{
                 classview.transform = CGAffineTransformIdentity;
            }];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
         for(UIView *view in [self.view subviews])
         {
             view.hidden=YES;
         }
    });
}
@end
