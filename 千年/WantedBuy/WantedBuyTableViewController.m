//
//  WantedBuyTableViewController.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "WantedBuyTableViewController.h"
#import "WantedBuyTableViewCell.h"
#import "HopeDetailViewController.h"
#import "WantedByModel.h"
#import "MJRefresh.h"
#import "PersonDetailViewController.h"

static int i = 0;
static NSString *WantedIdentifier = @"wantedcellIdentifier";
@interface WantedBuyTableViewController ()<UITableViewDataSource,UITableViewDelegate,DidSelectHeadDelegate>
@property (nonatomic,strong) NSMutableArray *WantBuyArray;
- (IBAction)AddThing_action:(id)sender;
@end

@implementation WantedBuyTableViewController
-(NSMutableArray *)WantBuyArray
{
 if(_WantBuyArray==nil)
 {
     _WantBuyArray = [NSMutableArray array];
 }
    return _WantBuyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil]];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Updateview:) name:@"wantedbuy" object:nil];
    [self RefershView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [imageView setImage:[UIImage imageNamed:@"WantedBuy_Bg2"]];
    [self.tableView setBackgroundView:imageView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
//    self.WantBuyArray = [NSMutableArray array];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if([[userdefault objectForKey:@"reload"]isEqualToString:@"1"])
    {
            [self.tableView reloadData];
        [userdefault removeObjectForKey:@"reload"];
    }
    [WantedByModel GetdataFormBmobWith:i];
    
    UIImage *image = [UIImage imageNamed:@"WantedBuy_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Updateview:(NSNotification *)fication
{
    NSArray *array = fication.object;
    if(array.count==0)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"SquartNone"]];
        [self.tableView setBackgroundView:imageView];
        return;
    }
    if(i==0)
    {
        self.WantBuyArray = [NSMutableArray array];
        self.WantBuyArray = fication.object;
    }else
    {
        [self.WantBuyArray addObjectsFromArray:fication.object];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.WantBuyArray!=nil)
    {
        return self.WantBuyArray.count;
    }else{
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WantedBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WantedIdentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WantedBuyTableViewCell" owner:nil options:nil]lastObject];
        cell.backgroundColor = [UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:0.8];
    }
    cell.didDelegate = self;
    if(self.WantBuyArray!=nil)
    {
       cell.model = [self.WantBuyArray objectAtIndex:indexPath.section];
//        cell.textLabel.text = @"0000";
    }
    
    return cell;
    
}


#pragma mark --UItableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
if(self.WantBuyArray!=nil)
{
    WantedByModel *model =self.WantBuyArray[indexPath.section];
    return model.height;
}else{
    return 0;
}
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.WantBuyArray!=nil)
    {
         [self performSegueWithIdentifier:@"QiugouSegue" sender:self.WantBuyArray[indexPath.section]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 0.0000001;
    }else{
        return 5;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, 5)];
    imageview.alpha = 0.1;
    return imageview;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[HopeDetailViewController class]])
    {
        HopeDetailViewController *HOPvc = (HopeDetailViewController *)segue.destinationViewController;
        HOPvc.Hopemodel = sender;
    }
}
- (IBAction)AddThing_action:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]intValue]==0)
    {
        [self performSegueWithIdentifier:@"push2" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"push1" sender:nil];
    }
}


//拉动刷新
-(void)RefershView
{
    [self.tableView addHeaderWithTarget:self action:@selector(HeaderRefersh)];
    [self.tableView addFooterWithTarget:self action:@selector(FooterRefersh)];
}
-(void)HeaderRefersh
{
    i=0;
    [WantedByModel GetdataFormBmobWith:i];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    });
}
-(void)FooterRefersh
{
    if(self.WantBuyArray.count>=10*(i+1))
    {
        i++;
        [WantedByModel GetdataFormBmobWith:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        });
    }else{
        [self.tableView footerEndRefreshing];
    }
   
}
-(void)DidselectedWithUsername:(NSString *)username
{
    PersonDetailViewController *perDetail = [[PersonDetailViewController alloc] init];
    perDetail.UserNAME = username;
    [self.navigationController pushViewController:perDetail animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    i =0;
}
@end
