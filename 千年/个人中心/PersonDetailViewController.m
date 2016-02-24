//
//  PersonDetailViewController.m
//  千年
//
//  Created by God on 16/1/14.
//  Copyright © 2016年 God. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "PersonView.h"
#import "UserInformation.h"
#import "UIButton+WebCache.h"
#import "SearcherModel.h"
#import "WantedByModel.h"
#import "GoodDetailViewController.h"
#import "WantedBuyTableViewController.h"
#import "HopeDetailViewController.h"
@interface PersonDetailViewController ()<UIScrollViewDelegate,DidTableDelegate>
{
    UIScrollView *bottomScrollView;
}
@end

@implementation PersonDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [UserInformation loaduserinformationFromLoginWithUsername:self.UserNAME];//用户信息 获取
    [SearcherModel loaddataFromGoodsWithUserName:self.UserNAME];             //商品信息 获取
    [WantedByModel GetdataFormUsername:self.UserNAME];                       //求购信息 获取
    [SearcherModel loaddateFromCollectWithUsername:self.UserNAME];           //购买信息 获取
    //设置navigation的背景图片
    UIImage *image = [UIImage imageNamed:@"PerDetail"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回键设置
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self CreateBackGroundAndHeadImage];  //背景及用户头像等
    [self createThreeButton];             //3个分类
    //底层scrollview
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+100+44, winWidth, winHeight-64-100-44)];
    bottomScrollView.pagingEnabled = YES;
    [bottomScrollView setContentSize:CGSizeMake(winWidth*3, winHeight-64-100-44)];
    [bottomScrollView setBackgroundColor:[UIColor whiteColor]];
    for(int i = 1; i<4;i++)
    {
        PersonView *personV = [[PersonView alloc]init];
        [personV setFrame:CGRectMake(winWidth*(i-1), 0, winWidth, bottomScrollView.bounds.size.height)];
        personV.Diddelegate = self;
        [bottomScrollView addSubview:personV];
    }
    //默认第一个在售
    PersonView *perVI = [[bottomScrollView subviews]objectAtIndex:2];
    perVI.selected = 3;
    //按钮选中状态<字的颜色不同>默认第一个选中
    UIView *threeView = [self.view viewWithTag:20001];
    for(UIView *sub in [threeView subviews])
    {
        UIButton *Buuton = (UIButton *)sub;
        bottomScrollView.contentOffset = CGPointMake(winWidth*0, 0);
        if(Buuton.tag==1)
        {
            Buuton.selected = YES;
        }else{
            Buuton.selected = NO;
        }
    }
    
    
    bottomScrollView.delegate = self;
    [self.view addSubview:bottomScrollView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateHeadImage:) name:@"UserInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatefirst:) name:@"PerSearchArray" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatethree:) name:@"Perwantedbuy" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatetwo:) name:@"BuySearchArray" object:nil];
    
}
//刷新求购
-(void)updatethree:(NSNotification *)notification
{
    PersonView *perVI = [[bottomScrollView subviews]objectAtIndex:2];
    WantedByModel *model = notification.object;
    if(model==nil)
    {
        perVI.wantedModel = nil;
        return;
    }
    perVI.selected = 3;
    perVI.wantedModel = notification.object;
}
//刷新已购买
-(void)updatetwo:(NSNotification *)notification
{
    PersonView *perVI = [[bottomScrollView subviews]objectAtIndex:1];
    perVI.selected = 2;
    SearcherModel *model = notification.object;
    if(model==nil)
    {
        perVI.searchModel = nil;
        return;
    }
    perVI.searchModel = notification.object;
}

//刷新在售
-(void)updatefirst:(NSNotification *)notification
{
    PersonView *perVI = [[bottomScrollView subviews]objectAtIndex:0];
        perVI.selected = 1;
    SearcherModel *model = notification.object;
    if(model==nil)
    {
        perVI.searchModel = nil;
        return;
    }
    perVI.searchModel = notification.object;
}
//刷新头像及名称
-(void)updateHeadImage:(NSNotification *)notification
{
    UserInformation *infor = notification.object;
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:10000];
    UIButton *headBtn = (UIButton *)[imageview viewWithTag:10002];
    UILabel *nicknameLabel = (UILabel *)[imageview viewWithTag:10001];
    
    [headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",infor.headUrl,Base_url]] forState:UIControlStateNormal];
    nicknameLabel.text = infor.nickname;
}
//创建底层背景及头像
-(void)CreateBackGroundAndHeadImage
{
   //背景
    UIImageView *BackGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, winWidth, 100)];
    [BackGroundView setImage:[UIImage imageNamed:@"BackImage"]];
//    [BackGroundView setBackgroundColor:[UIColor lightGrayColor]];
    BackGroundView.tag=10000;
    UIButton *headImage = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, winWidth/320*60, winWidth/320*60)];
    //头像
    headImage.layer.cornerRadius = headImage.bounds.size.width/2;
    headImage.layer.masksToBounds = YES;
    headImage.tag = 10002;
    [headImage setBackgroundImage:[UIImage imageNamed:@"Headimage"] forState:UIControlStateNormal];
//    headImage.backgroundColor = [UIColor redColor];
    //昵称
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+30, 30, 200, 40)];
    nickNameLabel.tag = 10001;
    
    [BackGroundView addSubview:headImage];
    [BackGroundView addSubview:nickNameLabel];
    [self.view addSubview:BackGroundView];
}
//创建3个选项按钮（在售,已购买,求购）
-(void)createThreeButton
{
     UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+100, winWidth, 44)];
    [threeView setBackgroundColor:[UIColor yellowColor]];
    threeView.tag = 20001;
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, winWidth/3, 44)];
    UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstButton.frame), 0, winWidth/3, 44)];
    UIButton *threeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondButton.frame), 0, winWidth/3, 44)];
    
    [firstButton setBackgroundImage:[UIImage imageNamed:@"Onsale_normal"] forState:UIControlStateNormal];
    [firstButton setBackgroundImage:[UIImage imageNamed:@"Onsale_selected"] forState:UIControlStateSelected];
    firstButton.tag = 1;
    
    [secondButton setBackgroundImage:[UIImage imageNamed:@"Buyed_normal"] forState:UIControlStateNormal];
    [secondButton setBackgroundImage:[UIImage imageNamed:@"Buyed_selected"] forState:UIControlStateSelected];
    secondButton.tag = 2;
    [threeButton setBackgroundImage:[UIImage imageNamed:@"Wanted_normal"] forState:UIControlStateNormal];
    [threeButton setBackgroundImage:[UIImage imageNamed:@"Wanted_selected"] forState:UIControlStateSelected];
    threeButton.tag = 3;
    
    [firstButton addTarget:self action:@selector(ChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton addTarget:self action:@selector(ChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [threeButton addTarget:self action:@selector(ChooseButton:) forControlEvents:UIControlEventTouchUpInside];

    [threeView addSubview:firstButton];
    [threeView addSubview:secondButton];
    [threeView addSubview:threeButton];
    
    [self.view addSubview:threeView];
}
//选择按钮，根据tag确定偏移量
-(void)ChooseButton:(UIButton *)sender
{
    //按钮选中状态<字的颜色不同>  执行相应的tableview刷新代码
    UIView *threeView = [self.view viewWithTag:20001];
    for(UIView *sub in [threeView subviews])
    {
        UIButton *Buuton = (UIButton *)sub;
        UIButton *btn = (UIButton *)sender;
        bottomScrollView.contentOffset = CGPointMake(winWidth*(btn.tag-1), 0);
        if(Buuton.tag==btn.tag)
        {
            Buuton.selected = YES;
            PersonView *perVI = [[bottomScrollView subviews]objectAtIndex:(btn.tag-1)];
            [perVI.mytab reloadData];
        }else{
            Buuton.selected = NO;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    PersonView *Perview = [[scrollView subviews]objectAtIndex:scrollView.contentOffset.x/winWidth ];
    if(scrollView.contentOffset.x/winWidth==0)
    {
        Perview.selected = 1;
    }else if(scrollView.contentOffset.x/winWidth==1)
    {
        Perview.selected = 2;
    }else{
        Perview.selected = 3;
    }
   //按钮选中状态<字的颜色不同>
    UIView *threeView = [self.view viewWithTag:20001];
    for(UIView *sub in [threeView subviews])
    {
        UIButton *Buuton = (UIButton *)sub;
        
        bottomScrollView.contentOffset = CGPointMake(winWidth*(scrollView.contentOffset.x/winWidth), 0);
        if(Buuton.tag==scrollView.contentOffset.x/winWidth+1)
        {
            Buuton.selected = YES;
        }else{
            Buuton.selected = NO;
        }
    }
}


//在售选择的代理方法
-(void)didSelectedWithSelectedNumber:(NSInteger)number SearchModel:(SearcherModel *)model
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoodDetailViewController *GoodVC = [story instantiateViewControllerWithIdentifier:@"GoodDetail"];
    GoodVC.searchModel = model;
    [self.navigationController pushViewController:GoodVC animated:YES];
}
//求购选择的代理方法
-(void)didSelectedWithSelectedNumber:(NSInteger)number WantedModel:(WantedByModel *)model
{
//    HopeDetail
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HopeDetailViewController *HopeVC = [story instantiateViewControllerWithIdentifier:@"HopeDetail"];
    HopeVC.Hopemodel = model;
    [self.navigationController pushViewController:HopeVC animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
