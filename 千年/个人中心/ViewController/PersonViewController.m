//
//  PersonViewController.m
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import "PersonViewController.h"

static NSString *identifier_tableview = @"mycell";
static NSString *identifier_collection = @"MyCollectionView";
#import "PersonTableViewCell.h"
#import "FiveCollectionViewCell.h"
#import "UserInformation.h"
#import "UIImageView+WebCache.h"
#import "FiveCollectViewController.h"
#import "LoginViewController1.h"
#import "ExpendViewController.h"
@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UserInformation *UserInfo;

@property (nonatomic, strong) NSArray *titleArray1;
@property (nonatomic, strong) NSArray *titleImage1;
@property (nonatomic, strong) NSArray *titleArray2;
@property (nonatomic, strong) NSArray *titleImage2;
@property (nonatomic, strong) NSArray *titleArray3;
@property (nonatomic, strong) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *Background_Image;
@property (weak, nonatomic) IBOutlet UIButton *head_image_button;
@property (weak, nonatomic) IBOutlet UIButton *nick_login_button;
- (IBAction)Set_headImage:(id)sender;
- (IBAction)LoginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *PersonTableview;
@property (weak, nonatomic) IBOutlet UICollectionView *FiveCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *UserPhoto_image;

@end

@implementation PersonViewController
-(NSArray *)titleArray1
{
    if(_titleArray1 == nil)
    {
        _titleArray1 = [NSArray arrayWithObjects:@"个人信息",@"我的收支", nil];
    }
    return _titleArray1;
}
-(NSArray *)titleImage1
{
    if(_titleImage1==nil)
    {
        _titleImage1 = [NSArray arrayWithObjects:@"personInformation",@"Money", nil];
    }
    return _titleImage1;
}
-(NSArray *)titleImage2
{
    if(_titleImage2 == nil)
    {
        _titleImage2 = [NSArray arrayWithObjects:@"address_tubiao",@"setting", nil];
    }
    return _titleImage2;
}
-(NSArray *)titleArray2
{
    if(_titleArray2 == nil)
    {
        _titleArray2 = [NSArray arrayWithObjects:@"收货地址",@"设置", nil];
    }
    return _titleArray2;
}
-(NSArray *)titleArray3
{
    if(_titleArray3 == nil)
    {
        _titleArray3 = [NSArray arrayWithObjects:@"在售",@"已卖出",@"已购买",@"求购",@"收藏的", nil];
    }
    return _titleArray3;
}
-(NSArray *)imageArray
{
    if(_imageArray == nil)
    {
        _imageArray = [NSArray arrayWithObjects:@"zaishou",@"maichu",@"goumai",@"qiugou",@"shoucang",nil];
    }
    return _imageArray;
}
-(UserInformation *)UserInfo
{
    if(_UserInfo == nil)
    {
        _UserInfo = [[UserInformation alloc]init];
    }
    return _UserInfo;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.Background_Image setImage:[UIImage imageNamed:@"HeadBackground"]]; //背景图片
    

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"]&&[[userDefault objectForKey:@"Logining"]isEqualToString:@"1"])
    {
        [UserInformation loaduserinformationFromLoginWithUsername:[userDefault objectForKey:@"username"]];//获取用户信息
        [self.nick_login_button setTitle:@"登录中..." forState:UIControlStateNormal];
    }else{
        [self.nick_login_button setTitle:@"请登录" forState:UIControlStateNormal];
        [self.UserPhoto_image setImage:nil];
        self.nick_login_button.enabled = YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateViewController:) name:@"UserInfo" object:nil];
}

-(void)UpdateViewController:(NSNotification *)fication//返回的用户信息刷新显示
{
    self.UserInfo = fication.object;
    [self.nick_login_button setTitle:self.UserInfo.nickname forState:UIControlStateNormal];//设置昵称
    [self.UserPhoto_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.UserInfo.headUrl,Base_url]]];//设置头像
    self.head_image_button.layer.cornerRadius = self.head_image_button.bounds.size.width/2;
    self.head_image_button.layer.masksToBounds = YES;
    self.UserPhoto_image.layer.cornerRadius = self.UserPhoto_image.bounds.size.width/2;
    self.UserPhoto_image.layer.masksToBounds = YES;//选择头像的按钮和头像的圆角等属性
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];//保存用户名+用户昵称
    [userDefault setObject:self.UserInfo.headUrl forKey:@"head_url"];
    [userDefault setObject:self.UserInfo.nickname forKey:@"nick_name"];
    [userDefault synchronize];
    self.nick_login_button.enabled = NO;//头像更换关闭
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.PersonTableview.dataSource = self;
    self.PersonTableview.delegate = self;
    
    self.FiveCollectionView.dataSource = self;
    self.FiveCollectionView.delegate = self;
    [self.FiveCollectionView registerNib:[UINib nibWithNibName:@"FiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier_collection];//注册collectionview的cell
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.PersonTableview setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];//tableview的背景颜色
    
    [self setUpAboutMe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
    {
        return self.titleArray1.count;
    }else{
        return self.titleArray2.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_tableview];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;     //cell的选择属性
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   //cell的辅助格式
    }
    if(indexPath.section==0)
    {
        cell.Cell_name_Label.text = self.titleArray1[indexPath.row];
        [cell.Cell_image setImage:[UIImage imageNamed:[self.titleImage1 objectAtIndex:indexPath.row]]];
    }else{
        cell.Cell_name_Label.text = self.titleArray2[indexPath.row];
        [cell.Cell_image setImage:[UIImage imageNamed:[self.titleImage2 objectAtIndex:indexPath.row]]];
    }
    cell.layer.borderWidth = 1;
    [cell.layer setBorderColor:[[UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0]CGColor]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark --UITableViewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if(indexPath.section==1&&indexPath.row==1)
    {
        [self performSegueWithIdentifier:@"Setting" sender:nil];
    }else if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        if(indexPath.section==1&&indexPath.row==0)
        {
            [self performSegueWithIdentifier:@"addressSegue" sender:nil];
        }
        if(indexPath.section==0&&indexPath.row==0)
        {
            [self performSegueWithIdentifier:@"Information" sender:nil];
        }
        if(indexPath.section==0&&indexPath.row==1)
        {
            ExpendViewController *expendVc = [[ExpendViewController alloc] init];
            [self.navigationController pushViewController:expendVc animated:YES];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{//如果用户尚未登录,跳转到登录页面
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController1 *LoginVC = [story instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}


#pragma mark CollectionViewdatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_collection forIndexPath:indexPath];
    [cell.Five_Button_Text setTitle:[self.titleArray3 objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.Five_ImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]]];
    return cell;
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        NSArray *titleArray = @[@{@"title":@"在售中",@"query":@"Goods",@"col":@"sale_id"},@{@"title":@"已卖出",@"query":@"Goods",@"col":@"Saleout_id"},@{@"title":@"已购买",@"query":@"Goods",@"col":@"Buyed_id"},@{@"title":@"求购中",@"query":@"WantedBuy",@"col":@"wanted_id"},@{@"title":@"我的收藏",@"query":@"Goods",@"col":@"good_id"}];
        [self performSegueWithIdentifier:@"FiveCollect" sender:titleArray[indexPath.row]];
    }else{//如果用户尚未登录,跳转到登录页面
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController1 *LoginVC = [story instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[FiveCollectViewController class]])
    {
        FiveCollectViewController *FiveVC = (FiveCollectViewController *)segue.destinationViewController;
        FiveVC.Fivedictionary = sender;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(winWidth/5, winWidth/5);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark --点击事件
//头像相关
- (IBAction)Set_headImage:(id)sender {
    
}
//登录相关
- (IBAction)LoginAction:(id)sender {

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)setUpAboutMe
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(winWidth, 0, winWidth, winHeight)];
    [imageview setImage:[UIImage imageNamed:@"AboutMeImage"]];
    [self.view addSubview:imageview];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(winWidth, 20, 100, 30)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)backView:(UIButton *)sender
{
    self.view.transform = CGAffineTransformIdentity;
}
@end
