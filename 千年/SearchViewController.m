//
//  SearchViewController.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearcherModel.h"
#import "GoodDetailViewController.h"
#import "PersonDetailViewController.h"
#import "ShouYeViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,DidSelectHeadDelegate>
{
    NSMutableArray *searchDataArray;
    UITextField *SearchTextField;
}
@property (weak, nonatomic) IBOutlet UITableView *MySearchTableView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchDataArray = [NSMutableArray array];
    self.MySearchTableView.delegate = self;
    self.MySearchTableView.dataSource = self;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    if([self.className isEqualToString:@"数码"]||[self.className isEqualToString:@"交通工具"]||[self.className isEqualToString:@"书籍"]||[self.className isEqualToString:@"包箱"]||[self.className isEqualToString:@"衣服"]||[self.className isEqualToString:@"生活文体"]||[self.className isEqualToString:@"饰品"]||[self.className isEqualToString:@"其它"])
    {
        [SearcherModel loaddataFromGoodsWithClassName:self.className];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdatatableView:) name:@"SearchArray" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView) name:@"SegueSearchArray" object:nil];
    SearchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, winWidth-150, 30)];
    SearchTextField.placeholder = @"搜索二宝";
    SearchTextField.leftViewMode= UITextFieldViewModeAlways;
    SearchTextField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_01"]];
    [SearchTextField setBackgroundColor:[UIColor whiteColor]];
    SearchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    SearchTextField.layer.cornerRadius = 8.0;
    self.navigationItem.titleView=SearchTextField;
    
    UIBarButtonItem *right_item = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(SearchGoodsData)];
    [right_item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = right_item;
    
    self.MySearchTableView.tableFooterView = [UIView new];
}
-(void)updateView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [imageView setImage:[UIImage imageNamed:@"ClassNone"]];
    [self.MySearchTableView setBackgroundView:imageView];
}
-(void)UpdatatableView:(NSNotification *)fication
{
    searchDataArray = fication.object;
    if(searchDataArray.count<=0)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"SearchNone"]];
        [self.MySearchTableView setBackgroundView:imageView];
        return;
    }else{
        //        Color.rgb(175, 226, 243)
        [self.MySearchTableView setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
    }
    [self.MySearchTableView setBackgroundView:nil];
    [self.MySearchTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Mycell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
    }
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0].CGColor;
//    cell.layer.borderColor = [UIColor redColor].CGColor;
    
    cell.DidDelegate = self;
    SearcherModel *model = searchDataArray[indexPath.row];
    cell.model = model;
//    cell.layer.borderWidth = 1;
//    [cell.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];

    return cell;
}
#pragma mark --UitableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SearchTextField resignFirstResponder];
    SearcherModel *model = searchDataArray[indexPath.row];
    [self performSegueWithIdentifier:@"mysegue" sender:model];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[GoodDetailViewController class]])
    {
        GoodDetailViewController *goodDetailVC = (GoodDetailViewController *)segue.destinationViewController;
        goodDetailVC.searchModel =sender;
    }
}
-(void)DidselectedWithUsername:(NSString *)username
{
    PersonDetailViewController *perDetailVC = [[PersonDetailViewController alloc] init];
    perDetailVC.UserNAME = username;
    [self.navigationController pushViewController:perDetailVC animated:YES];
}
//搜索方法
-(void)SearchGoodsData
{
//    [self.view endEditing:YES];
    [SearchTextField resignFirstResponder];
    if([SearchTextField.text isEqualToString:@""])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"SearchNone"]];
        [self.MySearchTableView setBackgroundView:imageView];
        
        searchDataArray = nil;
        [self.MySearchTableView reloadData];
        return;
    }
    [SearcherModel loaddataFromGoodsWithGoodDescription:SearchTextField.text];
    [self.MySearchTableView setBackgroundView:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
