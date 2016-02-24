//
//  FiveCollectViewController.m
//  千年
//
//  Created by God on 16/1/6.
//  Copyright © 2016年 God. All rights reserved.
//

#import "FiveCollectViewController.h"
#import "SearchTableViewCell.h"
#import "SearcherModel.h"
#import "FiveCollectModel.h"
#import "WantedBuyTableViewCell.h"
#import "WantedByModel.h"
#import "UIView+Toast.h"
//#import "PersonViewController.h"
#import "PersonDetailViewController.h"
#define FiveIdentifier  @"Fivecollectidentifierha"
#define WantedIdentifier @"Wantedcollectidentifierha"
static int i = 0;
@interface FiveCollectViewController ()<UITableViewDataSource,UITableViewDelegate,DidSelectHeadDelegate>
{
    NSUserDefaults *userDefault;
}
@property (weak, nonatomic) IBOutlet UITableView *Fivetableview;
@property (nonatomic, strong) NSMutableArray *Collectarray;
@property (nonatomic, strong) NSMutableArray *wantedArray;
//@property (nonatomic, strong) NSMutableArray *SaleoutArray;
@end

@implementation FiveCollectViewController
-(NSMutableArray *)Collectarray
{
    if(_Collectarray == nil)
    {
        _Collectarray = [NSMutableArray array];
//        @[@{@"title":@"在售中",@"query":@"Goods",@"col":@"sale_id"},@{@"title":@"已卖出",@"query":@"Goods",@"col":@"good_buy"},@{@"title":@"已购买",@"query":@"Goods"},@{@"title":@"求购中",@"query":@"WantedBuy",@"col":@"wanted_id"},@{@"title":@"我的收藏",@"query":@"Goods",@"col":@"good_id"}];
        
        if([[userDefault objectForKey:@"Logining"]isEqualToString:@"1"])//判断用户是否登录
        {
            if([[self.Fivedictionary objectForKey:@"query"]isEqualToString:@"Goods"])//刷新在售+收藏+已购买+已卖出
            {
                [FiveCollectModel loadDataFromTable:[self.Fivedictionary objectForKey:@"query"] objectKey:[self.Fivedictionary objectForKey:@"col"]];
            }
        }else{
            [self.view makeToast:@"您未登录" duration:2.0 position:@"CSToastPositionCenter"];
        }
    }
    return _Collectarray;
}



-(NSMutableArray *)wantedArray
{
    if(_wantedArray==nil)
    {
        _wantedArray = [NSMutableArray array];
        if([[userDefault objectForKey:@"Logining"]isEqualToString:@"1"])//判断用户是否登录
        {
            if([[self.Fivedictionary objectForKey:@"query"]isEqualToString:@"WantedBuy"]) //刷新求购
            {
                [userDefault setObject:@"1" forKey:@"Getmywanted"];
                [userDefault setObject:@"1" forKey:@"reload"];
                [userDefault synchronize];
                [WantedByModel GetdataFormBmobWith:i];
                
               
            }
        }else{
            [self.view makeToast:@"您未登录" duration:2.0 position:@"CSToastPositionCenter"];
        }
        
    }
    return _wantedArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *TitleViewArray = @[@"OnSale",@"SaleFinish",@"Buyed",@"Wanted",@"Collected"];
    //        @[@{@"title":@"在售中",@"query":@"Goods",@"col":@"sale_id"},@{@"title":@"已卖出",@"query":@"Goods"},@{@"title":@"已购买",@"query":@"Goods"},@{@"title":@"求购中",@"query":@"WantedBuy",@"col":@"wanted_id"},@{@"title":@"我的收藏",@"query":@"Goods",@"col":@"good_id"}];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    
    
    UIImage *image;
    if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"在售中"])
    {
        image = [UIImage imageNamed:TitleViewArray.firstObject];
    }else  if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"已卖出"])
    {
        image = [UIImage imageNamed:[TitleViewArray objectAtIndex:1]];
    }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"已购买"])
    {
        image = [UIImage imageNamed:[TitleViewArray objectAtIndex:2]];
    }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"求购中"])
    {
        image = [UIImage imageNamed:[TitleViewArray objectAtIndex:3]];
    }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"我的收藏"])
    {
        image = [UIImage imageNamed:TitleViewArray.lastObject];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];//NavgationBar

    [self.Fivetableview setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];   //tableView的背景颜色
    
    userDefault = [NSUserDefaults standardUserDefaults];

    self.Fivetableview.dataSource = self;
    self.Fivetableview.delegate = self;
    self.Fivetableview.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataforCollect:) name:@"FiveCollect" object:nil];//在售+收藏 接受 通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDateForWanted:) name:@"wantedbuy" object:nil];//求购接受 通知
}
-(void)getDataforCollect:(NSNotification *)ficatiuon //收藏和在售 通知传值刷新
{
    self.Collectarray = ficatiuon.object;
    [self.Fivetableview reloadData];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    
    if(self.Collectarray.count==0)
    {
        if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"在售中"])
        {
          [imageView setImage:[UIImage imageNamed:@"SaleNone"]];
        }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"我的收藏"]){
            [imageView setImage:[UIImage imageNamed:@"CollectedNone"]];
        }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"已卖出"])
        {
            [imageView setImage:[UIImage imageNamed:@"SaleOutNone"]];
        }else{
            [imageView setImage:[UIImage imageNamed:@"BuyedNone"]];
        }
        [self.Fivetableview setBackgroundView:imageView];
    }
    
}
-(void)getDateForWanted:(NSNotification *)fication //求购通知传值刷新
{
    self.wantedArray = fication.object;
    [self.Fivetableview reloadData];
    if(self.wantedArray.count==0)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"WantedNone"]];
        [self.Fivetableview setBackgroundView:imageView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UItableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.Fivedictionary objectForKey:@"query"]isEqualToString:@"Goods"])
    {
        return self.Collectarray.count;
    }else{
        return self.wantedArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.Fivedictionary objectForKey:@"query"]isEqualToString:@"Goods"])//收藏 或 在售
    {
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FiveIdentifier];
        if(cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.DidDelegate = self;
        }
        cell.layer.borderWidth = 1;
        [cell.layer setBorderColor:[[UIColor colorWithRed:59/255.0 green:181/255.0 blue:250/255.0 alpha:1.0]CGColor]];
        cell.model = self.Collectarray[indexPath.row];;
        return cell;
    }else //求购
    {
        WantedBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WantedIdentifier];
        if(cell == nil)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WantedBuyTableViewCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.wantedArray[indexPath.row];
        cell.layer.borderWidth = 1;
        [cell.layer setBorderColor:[[UIColor colorWithRed:59/255.0 green:181/255.0 blue:250/255.0 alpha:1.0]CGColor]];
        return cell;
    }
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.Collectarray.count==0)
    {
        return @"";
    }
    if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"在售中"])
    {
        return [NSString stringWithFormat:@"共%li件",self.Collectarray.count];
    }else  if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"已卖出"])
    {
        return [NSString stringWithFormat:@"共%li件",self.Collectarray.count];
    }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"已购买"])
    {
        return [NSString stringWithFormat:@"共%li件",self.Collectarray.count];
    }else if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"求购中"])
    {
        if(self.wantedArray.count==0)
        {
            return @"";
        }
        return [NSString stringWithFormat:@"共%li件",self.wantedArray.count];
    }else
    {
//        if(self.Collectarray.count==0)
//        {
//            return @"";
//        }else{
            return [NSString stringWithFormat:@"共%li件",self.Collectarray.count];
//        }
    }
}

#pragma mark UItableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(se)
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.Fivedictionary objectForKey:@"query"]isEqualToString:@"Goods"])
    {
         return 120;
    }else{
        return 120;
    }
   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"在售中"])//删除在售
    {
        [self deleteWithCollect:@"Collect" andGoods:@"Goods" andKey:[self.Fivedictionary objectForKey:@"col"] andRow:indexPath.row andSearchModel:self.Collectarray[indexPath.row] andWantedModel:nil];
    }
    if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"我的收藏"])//删除收藏
    {
        if(editingStyle == UITableViewCellEditingStyleDelete)
        {
            [self deleteWithCollect:@"Collect" andGoods:nil andKey:[self.Fivedictionary objectForKey:@"col"] andRow:indexPath.row andSearchModel:self.Collectarray[indexPath.row] andWantedModel:nil];
        }
    }
     if([[self.Fivedictionary objectForKey:@"title"]isEqualToString:@"求购中"])//删除求购
     {
         if(editingStyle == UITableViewCellEditingStyleDelete)
         {
             [self deleteWithCollect:@"Collect" andGoods:@"WantedBuy" andKey:[self.Fivedictionary objectForKey:@"col"] andRow:indexPath.row andSearchModel:nil andWantedModel:self.wantedArray[indexPath.row]];
         }
     }
}
//删除求购


//删除在售+我的收藏
-(void)deleteWithCollect:(NSString *)collect andGoods:(NSString *)goods andKey:(NSString *)KEY andRow:(NSInteger)row andSearchModel:(SearcherModel *)model andWantedModel:(WantedByModel *)wantedModel
{
        BmobQuery *bquery = [BmobQuery queryWithClassName:collect];
    if(model.objectId!=nil)
    {
        [bquery whereKey:KEY equalTo:model.objectId];
    }else{
         [bquery whereKey:KEY equalTo:wantedModel.objectId];
    }
    
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *deleteobject = array.firstObject;
            [deleteobject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    if([goods isEqualToString:@"Goods"])//删除在售
                    {
                        BmobQuery *Goodquery = [BmobQuery queryWithClassName:goods];
                        [Goodquery getObjectInBackgroundWithId:model.objectId block:^(BmobObject *object, NSError *error) {
                            [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                if(isSuccessful)
                                {
                                    NSLog(@"删除成功");
                                }
                            }];
                        }];
                        [self deleteCollect:model];
                        [self deleteGoodComment:model];
                        
                    [self.Collectarray removeObjectAtIndex:row];
                        [self.Fivetableview reloadData];
                    }else if([goods isEqualToString:@"WantedBuy"])//删除求购
                    {
                        BmobQuery *wantedQuery = [BmobQuery queryWithClassName:goods];
                        [wantedQuery getObjectInBackgroundWithId:wantedModel.objectId block:^(BmobObject *object, NSError *error) {
                            [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                if(isSuccessful)
                                {
                                    NSLog(@"删除成功");
                                }
                            }];
                        }];
                        [self deleteComment:wantedModel];
                        [self.wantedArray removeObjectAtIndex:row];
                        [self.Fivetableview reloadData];
                    }else//删除收藏
                    {
                        [self deleteGoodRate:model];
                        [self.Collectarray removeObjectAtIndex:row];
                        [self.Fivetableview reloadData];
                    }
                    
                }
            }];
        }];
}
//减少物品的收藏数量（Goods）
-(void)deleteGoodRate:(SearcherModel *)model
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
    [bquery whereKey:@"objectId" equalTo:model.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *userObject = array.firstObject;
        NSString *goodrate = [NSString stringWithFormat:@"%i",[model.goodrate intValue]-1];
        [userObject setObject:goodrate forKey:@"good_rate"];
        [userObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                
            }
        }];
    }];
}
//删除在售时把用户收藏数据删除（Goods）
-(void)deleteCollect:(SearcherModel *)model
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"good_id" equalTo:model.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *bObj = array.lastObject;
        [bObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                NSLog(@"删除collect成功");
            }
        }];
    }];
}
//删除在售时把用户评论删除（Goods）
-(void)deleteGoodComment:(SearcherModel *)model
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"GoodComment"];
    [bquery whereKey:@"good_id" equalTo:model.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *Bobj in array)
        {
            [Bobj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    NSLog(@"评论删除成功");
                }
            }];
        }
    }];
}
//删除求购时把用户评论删掉
-(void)deleteComment:(WantedByModel *)model
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    [bquery whereKey:@"good_id" equalTo:model.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *Bobj in array)
        {
            [Bobj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    NSLog(@"删除wanted成功");
                }
            }];
        }
    }];
}

-(void)DidselectedWithUsername:(NSString *)username
{
    PersonDetailViewController *perDetailVC = [[PersonDetailViewController alloc] init];
    perDetailVC.UserNAME = username;
    [self.navigationController pushViewController:perDetailVC animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [userDefault removeObjectForKey:@"Getmywanted"];
    [userDefault synchronize];
}

@end
