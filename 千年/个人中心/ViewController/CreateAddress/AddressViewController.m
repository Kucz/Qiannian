//
//  AddressViewController.m
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddressModel.h"
#import "BuyViewController.h"
#import "NewaddressViewController.h"
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *AddressList;
@property (weak, nonatomic) IBOutlet UITableView *AddressTableView;
- (IBAction)CreateNewAdd_Action:(id)sender;

@end

@implementation AddressViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
     self.tabBarController.tabBar.hidden = YES;
    [AddressModel loadAddressFromAddress];

    UIImage *image = [UIImage imageNamed:@"AddressDetail_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.AddressTableView setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
    
    [self.AddressTableView setBackgroundView:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.AddressTableView.dataSource = self;
    self.AddressTableView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateAddressList:) name:@"Address" object:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    self.AddressTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}
-(void)UpdateAddressList:(NSNotification *)fication
{
    self.AddressList = fication.object;
    if(self.AddressList.count == 0)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageview setImage:[UIImage imageNamed:@"AddressNone"]];
        [self.AddressTableView setBackgroundView:imageview];
        return;
    }
    [self.AddressTableView reloadData];
}

-(NSMutableArray *)AddressList
{
    if(_AddressList==nil)
    {
        _AddressList = [NSMutableArray array];
//        [AddressModel loadAddressFromAddress];
    }
    return _AddressList;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.AddressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell==nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AddressTableViewCell" owner:nil options:nil].lastObject;
    }
    AddressModel *model = self.AddressList[indexPath.row];
    cell.model = model;
    cell.layer.borderWidth = 1;
    [cell.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)CreateNewAdd_Action:(id)sender {
//    NSLog(@"new");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     AddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger Count = self.navigationController.viewControllers.count;
    NSLog(@"%li",Count);
    if(Count==4||Count==5||Count==6)
    {
        BuyViewController *buyVC = [self.navigationController.viewControllers objectAtIndex:Count-2];
       
        buyVC.buyname = cell.AddressName.text;
        buyVC.buyphone = cell.AddressPhone.text;
        buyVC.buyaddress = cell.AddressDetailLabel.text;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        AddressModel *model = self.AddressList[indexPath.row];
        NSMutableDictionary *AddressDirctionary = [NSMutableDictionary dictionary];
        [AddressDirctionary setObject:model.addressperson forKey:@"Name"];
        [AddressDirctionary setObject:model.addressphone forKey:@"Phone"];
        [AddressDirctionary setObject:model.addresscity forKey:@"City"];
        [AddressDirctionary setObject:model.addressstreet forKey:@"Street"];
        [AddressDirctionary setObject:model.objectId forKey:@"ID"];
        [self performSegueWithIdentifier:@"NEWADDRESS" sender:AddressDirctionary];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"1" forKey:@"ADDRESS"];
        [userDefault synchronize];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[NewaddressViewController class]])
    {
        NewaddressViewController *NewVC =(NewaddressViewController *)segue.destinationViewController;
        NewVC.AddressDict = (NSMutableDictionary *)sender;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
