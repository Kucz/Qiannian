//
//  AboutMeViewController.m
//  千年
//
//  Created by God on 16/1/24.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AboutMeViewController.h"
#import "HopeCommentModel.h"
#import "DetailCommentModel.h"
#import "AboutMeTableCell.h"
#import "HopeDetailViewController.h"
#import "PersonDetailViewController.h"
#import "WantedByModel.h"
#import "GoodslistModel.h"
#import "GoodDetailViewController.h"

@interface AboutMeViewController ()<UITableViewDelegate,UITableViewDataSource,DidSelectedDelegate>
{
    NSUserDefaults *userDefault;
    NSString *PlistPath;
    NSMutableArray *tmpArray;
}
@property (nonatomic, strong) NSMutableArray *AboutArray;
@end

@implementation AboutMeViewController

-(NSMutableArray *)AboutArray
{
    if(_AboutArray==nil)
    {

        _AboutArray = [NSMutableArray array];
    }
    return _AboutArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [super viewWillAppear:YES];
    UIImage *image = [UIImage imageNamed:@"AboutMe"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    PlistPath  = [NSString stringWithFormat:@"%@/Library/Caches/Comment.plist",NSHomeDirectory()];
    tmpArray = [NSMutableArray arrayWithContentsOfFile:PlistPath];

    if(tmpArray==nil)
    {
        self.AboutArray =nil;
        [aboutTableview reloadData];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"Message_None"]];
        
        [aboutTableview setBackgroundView:imageView];
    }else
    {
        for(NSDictionary *dictionary in tmpArray)
        {
            if([[dictionary objectForKey:@"CommentClass"]isEqualToString:@"1"]||[[dictionary objectForKey:@"CommentClass"]isEqualToString:@"2"])
            {
                [HopeCommentModel LoadDataFromClassCommentWithobjectId:[dictionary objectForKey:@"objectId"]];
            }else{
                [DetailCommentModel loadFromGoodCommentWithObjectId:[dictionary objectForKey:@"objectId"]];
            }
        }
        [aboutTableview setBackgroundView:nil];
    }
}

-(void)updateCommentArray:(NSNotification *)notification
{
    [self.AboutArray addObject:notification.object];
    if(self.AboutArray.count == tmpArray.count)
    {
        [aboutTableview reloadData];
    }
    self.navigationController.tabBarItem.badgeValue = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    aboutTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    aboutTableview.delegate = self;
    aboutTableview.dataSource = self;
    
    aboutTableview.tableFooterView = [UIView new];
    [self.view addSubview:aboutTableview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCommentArray:) name:@"ReComment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCommentArray:) name:@"ReGoodDetail" object:nil];
    
//    Color.rgb(178, 226, 242)
    [aboutTableview setBackgroundColor:[UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.AboutArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutMeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if(cell==nil)
    {
        cell = [[AboutMeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.backgroundColor = [UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:1.0];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor colorWithRed:29/255.0 green:153/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.AboutArray!=nil)
    {
        NSDictionary *dictionary =[self.AboutArray[indexPath.section]objectAtIndex:0];
        
        if([[dictionary objectForKey:@"key"]isEqualToString:@"1"])
        {
            HopeCommentModel *model =[dictionary objectForKey:@"model"];
            model.Row = indexPath.section;
            cell.hopeModel = model;
            
        }else if([[dictionary objectForKey:@"key"]isEqualToString:@"2"]){
            DetailCommentModel *model = [dictionary objectForKey:@"model"];
            model.Row = indexPath.section;
             cell.detailModel = model;
        }
    }
    return cell;
}

#pragma mark --UITableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.AboutArray!=nil)
    {
        NSDictionary *dictionary =[self.AboutArray[indexPath.section]objectAtIndex:0];
        
        if([[dictionary objectForKey:@"key"]isEqualToString:@"1"])
        {
            HopeCommentModel *model =[dictionary objectForKey:@"model"];
            [self getWnatedModel:model];
            
        }else if([[dictionary objectForKey:@"key"]isEqualToString:@"2"]){
            DetailCommentModel *model = [dictionary objectForKey:@"model"];
            [self getGoodDetailModel:model];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary =[self.AboutArray[indexPath.section]objectAtIndex:0];
    if([[dictionary objectForKey:@"key"]isEqualToString:@"1"])
    {
        HopeCommentModel *model =[dictionary objectForKey:@"model"];
        return model.height;
        
    }else{
        DetailCommentModel *model = [dictionary objectForKey:@"model"];
        return model.height;
    }
}
//section头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    return imageview;
}
//section底部
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.AboutArray = nil;
    tmpArray = nil;
}

-(void)ChooseWantedButton:(UIButton *)btn
{
    NSDictionary *dictionary =[self.AboutArray[btn.tag]objectAtIndex:0];
    
    HopeCommentModel *model = [dictionary objectForKey:@"model"];
    PersonDetailViewController *personVC = [[PersonDetailViewController alloc] init];
    NSLog(@"%@",model);
    
    personVC.UserNAME = model.comment_id;
    [self.navigationController pushViewController:personVC animated:YES];
}
-(void)ChooseGoodButton:(UIButton *)btn
{
    NSDictionary *dictionary =[self.AboutArray[btn.tag]objectAtIndex:0];
    
    DetailCommentModel *model = [dictionary objectForKey:@"model"];
    
    PersonDetailViewController *personVC = [[PersonDetailViewController alloc] init];
    personVC.UserNAME = model.commentId;
    [self.navigationController pushViewController:personVC animated:YES];
}

-(void)getWnatedModel:(HopeCommentModel *)model
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WantedBuy"];
    
    [bquery whereKey:@"objectId" equalTo:model.good_id];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *wantObject = array.lastObject;
        BmobQuery *secondQuery = [BmobQuery queryWithClassName:@"Login"];
        
        [secondQuery whereKey:@"username" equalTo:model.username];
        [secondQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *obj = array.lastObject;
            WantedByModel *model = [[WantedByModel alloc]initWithImageurl:[obj objectForKey:@"head_url"] andTitle:[wantObject objectForKey:@"wanted_title"] andPrice:[wantObject objectForKey:@"wanted_price"] andTime:[wantObject objectForKey:@"wanted_time"] andDescription:[wantObject objectForKey:@"wanted_description"] andName:[obj objectForKey:@"nick_name"]andObjectId:[wantObject objectForKey:@"objectId"]userName:[wantObject objectForKey:@"username"]];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HopeDetailViewController *hopeVc = (HopeDetailViewController *)[sb instantiateViewControllerWithIdentifier:@"HopeDetail"];
            hopeVc.Hopemodel = model;
            [self.navigationController pushViewController:hopeVc animated:YES];
        }];
    }];
}

-(void)getGoodDetailModel:(DetailCommentModel*)model
{
    BmobQuery *firstQuery = [BmobQuery queryWithClassName:@"Goods"];
    [firstQuery whereKey:@"objectId" equalTo:model.goodId];
    [firstQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = array.lastObject;
        BmobQuery *secondQuery = [BmobQuery queryWithClassName:@"Login"];
        [secondQuery whereKey:@"username" equalTo:model.username];
        [secondQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *userObj = array.lastObject;
            
             GoodslistModel *model = [[GoodslistModel alloc]initWithGoodtitle:[obj objectForKey:@"good_name"] Goodprice:[obj objectForKey:@"good_price"] Goodprcenew:[obj objectForKey:@"good_pricenew"] Gooddescription:[obj objectForKey:@"good_description"] GoodImage:[obj objectForKey:@"good_image"] Goodstate:[obj objectForKey:@"good_state"] Goodclass:[obj objectForKey:@"good_class"] GoodUsername:[obj objectForKey:@"username"] GoodTime:[obj objectForKey:@"good_time"] GoodBuy:[obj objectForKey:@"good_buy"] GoodRate:[obj objectForKey:@"good_rate"]objectId:[obj objectForKey:@"objectId"]Nickname:[userObj objectForKey:@"nick_name"] Headimage:[userObj objectForKey:@"head_url"] Age:[userObj objectForKey:@"age"] Sex:[userObj objectForKey:@"sex"]userName:[userObj objectForKey:@"username"]];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GoodDetailViewController *goodVc = [sb instantiateViewControllerWithIdentifier:@"GoodDetail"];
            goodVc.model = model;
            [self.navigationController pushViewController:goodVc animated:YES];
        }];
    }];
}

@end
