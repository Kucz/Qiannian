//
//  ShouYeViewController.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "ShouYeViewController.h"
#import "ScrollCollectionViewCell.h"
#import "EightButtonCollectionViewCell.h"
#import "GoodsCollectionViewCell.h"
#import <BmobSDK/Bmob.h>
#import "EightModel.h"
#import "SearchViewController.h"
#import "GoodslistModel.h"
#import "GoodDetailViewController.h"
#import "MJRefresh.h"
#import "NSString+Mobile.h"
static int i = 0;
static int j = 0;
static NSString *ScrollIdentifier = @"MyScrollIdentifier";
static NSString *EightIdentifier = @"EightIdentifier";
static NSString *GoodIdentifier = @"GoodIdentifier";
@interface ShouYeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *EightLabelArray;
    NSMutableArray *labelll;
    NSMutableArray *GoodList;
    NSTimer *timer;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *MyCollectionView;
@property (nonatomic, strong) NSMutableArray *scrollArray;
- (IBAction)SearchAction:(id)sender;
@end

@implementation ShouYeViewController
-(NSMutableArray *)scrollArray
{
    if(_scrollArray == nil)
    {
        _scrollArray = [NSMutableArray arrayWithObjects:@"Banner_01",@"Banner_02", nil];
    }
    return _scrollArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    j=0;
    self.navigationController.navigationBar.hidden = NO;
    
    UIImage *image  = [UIImage imageNamed:@"MainTitle"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if([NSString connectedToNetwork])
    {
        [GoodslistModel loaddataFromGoods:i];
        [EightModel Getdata];
    }else{
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageview setImage:[UIImage imageNamed:@"NoNetWorking"]];
        [self.MyCollectionView setBackgroundView:imageview];
//        self.scrollArray = [NSMutableArray array];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.MyCollectionView.dataSource = self;
    self.MyCollectionView.delegate = self;
    labelll = [NSMutableArray array];
    EightLabelArray = [NSMutableArray array];
    GoodList = [NSMutableArray array];
    
    //注册cell->Scroll的cell
    [self.MyCollectionView registerNib:[UINib nibWithNibName:@"ScrollCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ScrollIdentifier];
    //   ->EightButton的cell
    [self.MyCollectionView registerNib:[UINib nibWithNibName:@"EightButtonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:EightIdentifier];
    //   ->Good的cell
    [self.MyCollectionView registerNib:[UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:GoodIdentifier];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil]];
    
    [self.MyCollectionView setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
    
    //Eight的model通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataEight:) name:@"eight" object:nil];
    //GoodsCollection的model通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateGoodList:) name:@"GoodList" object:nil];
    // Do any additional setup after loading the view.
    
    [self ReferView];
    
}

-(void)updataEight:(NSNotification *)fication
{
    EightLabelArray = fication.object;
    [self.MyCollectionView reloadData];
}

-(void)UpdateGoodList:(NSNotification *)fication
{
    if(i==0)
    {
        GoodList = nil;
        GoodList = fication.object;
    }else
    {
       [GoodList addObjectsFromArray:fication.object];
       
    }
    [self.MyCollectionView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }else if(section==1){
        return EightLabelArray.count;
    }else{
        return GoodList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScrollIdentifier forIndexPath:indexPath];
        if(j==0)
        {
            if([NSString connectedToNetwork])
            {
                cell.scrollArray = self.scrollArray;
                timer = cell.timer;
                j++;
            }else{
                cell.MypageView.hidden = YES;
            }
        }
        return cell;
    }else if(indexPath.section==1){
        EightButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EightIdentifier forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
        cell.model = EightLabelArray[indexPath.row];
        cell.Eight_image.layer.cornerRadius = cell.Eight_image.bounds.size.width/2.0;
        cell.Eight_image.layer.masksToBounds = YES;
        return cell;
    }else{
        
        GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodIdentifier forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0]];
        GoodslistModel *model = GoodList[indexPath.row];
        cell.model =model;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(5, 2);
        cell.layer.shadowOpacity  = 0.8;

        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBar.hidden = NO;
    if(indexPath.section==0)
    {
//        NSLog(@"1");
    }
    if(indexPath.section==1)
    {
        EightModel *model = EightLabelArray[indexPath.row];
        [self performSegueWithIdentifier:@"Eight_segue" sender:model.class_name];
    }else if(indexPath.section==2)
    {
        GoodslistModel *model = GoodList[indexPath.item];
        [self performSegueWithIdentifier:@"CollectionSegue" sender:model];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SearchViewController class]]&&[segue.identifier isEqualToString:@"Eight_segue"])
    {
        SearchViewController *SearchVC = (SearchViewController *)segue.destinationViewController;
        SearchVC.className = sender;
    }
    if([segue.destinationViewController isKindOfClass:[GoodDetailViewController class]])
    {
        GoodDetailViewController *gooddetailVC = (GoodDetailViewController *)segue.destinationViewController;
        gooddetailVC.model = (GoodslistModel *)sender;
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return CGSizeMake(winWidth, 150*winHeight/568);
    }else if(indexPath.section==1){
        return CGSizeMake(winWidth/4, winWidth/4);
    }else{
        return CGSizeMake((winWidth-30)/2.0, (winWidth-30)/2.0+50);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section==2)
    {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }else
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(section==2)
    {
        return 10;
    }else{
        return 0;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if(section==2)
    {
        return 10;
    }else{
        return 0;
    }
}

- (IBAction)SearchAction:(id)sender {
    [self performSegueWithIdentifier:@"searchAction" sender:nil];
}


-(void)ReferView
{
    [self.MyCollectionView addHeaderWithTarget:self action:@selector(HeaderRefersh)];
    [self.MyCollectionView addFooterWithTarget:self action:@selector(FooterRefersh)];
    
    self.MyCollectionView.headerPullToRefreshText = @"";
    self.MyCollectionView.headerRefreshingText = @"刷新...";
    self.MyCollectionView.headerReleaseToRefreshText = @"";
}
-(void)HeaderRefersh
{
    i=0;
    [GoodslistModel loaddataFromGoods:i];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.MyCollectionView headerEndRefreshing];
        [self.MyCollectionView reloadData];
    });
}
-(void)FooterRefersh
{
    if(GoodList.count>=10*(i+1))
    {
        i++;
        [GoodslistModel loaddataFromGoods:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.MyCollectionView footerEndRefreshing];
            [self.MyCollectionView reloadData];
        });
    }else{
        [self.MyCollectionView footerEndRefreshing];
    }
}

-(void)didSelectedScrollView
{
    NSLog(@"---------");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [timer invalidate];
}

@end
