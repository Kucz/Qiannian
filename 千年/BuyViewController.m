//
//  BuyViewController.m
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import "BuyViewController.h"
#import "UIImageView+WebCache.h"
#import "AddGoodsViewController.h"
#import "UIView+Toast.h"
#import <BmobPay/BmobPay.h>
@interface BuyViewController ()<BmobPayDelegate>
{
     NSString *ObjectId,*GoodPrice,*GoodName,*GoodDescription,*BuyId,*userName;
}
@property (weak, nonatomic) IBOutlet UIImageView *GoodImage;
@property (weak, nonatomic) IBOutlet UILabel *GoodTitle;
@property (weak, nonatomic) IBOutlet UILabel *GoodPaymoney;
@property (weak, nonatomic) IBOutlet UILabel *Goodprice;
- (IBAction)ChoseAddressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *BuyName;
@property (weak, nonatomic) IBOutlet UILabel *BuyAddress;
@property (weak, nonatomic) IBOutlet UIButton *ChoseButton;
- (IBAction)BuyACTION:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *BuyPhone;
@end

@implementation BuyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(self.buyname&&self.buyphone&&self.buyaddress)
    {
        self.BuyName.text = self.buyname;
        self.BuyPhone.text = self.buyphone;
        self.BuyAddress.text = self.buyaddress;
        [self.ChoseButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    UIImage *image = [UIImage imageNamed:@"SureOrder_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.goodModel!=nil)
    {
        [self.GoodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.goodModel.goodimage,Base_url]]];
        self.Goodprice.text = [NSString stringWithFormat:@"¥%@",self.goodModel.goodprice];
        self.GoodTitle.text = self.goodModel.goodtitle;
        self.GoodPaymoney.text = self.goodModel.goodprice;
        
        ObjectId = self.goodModel.objectId;
        GoodName = self.goodModel.goodtitle;
        GoodPrice = self.goodModel.goodprice;
        GoodDescription = self.goodModel.gooddescription;
        userName = self.goodModel.username;
        
    }else{
        [self.GoodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.searchModel.goodimage,Base_url]]];
        self.Goodprice.text = [NSString stringWithFormat:@"¥%@",self.searchModel.goodprice];
        self.GoodTitle.text = self.searchModel.goodtitle;
        self.GoodPaymoney.text = self.searchModel.goodprice;
        
        ObjectId = self.searchModel.objectId;
        GoodName = self.searchModel.goodtitle;
        GoodPrice = self.searchModel.goodprice;
        GoodDescription = self.searchModel.gooddescription;
        userName = self.searchModel.username;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChoseAddressAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddGoodsViewController *addressVC = [story instantiateViewControllerWithIdentifier:@"Address"];
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (IBAction)BuyACTION:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if([self.BuyAddress.text isEqualToString:@""])
    {
        [self.view makeToast:@"请选择地址" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    BmobPay* bPay = [[BmobPay alloc] init];
    bPay.delegate = self;
    //设置商品价格、商品名、商品描述
    [bPay setPrice:[NSNumber numberWithFloat:[GoodPrice floatValue]]];
    [bPay setProductName:GoodPrice];
    [bPay setBody:GoodDescription];
    //appScheme为创建项目第4步中在URL Schemes中添加的标识
    [bPay setAppScheme:@"QianNian"];
    //调用支付宝支付
    [bPay payInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BuyId = bPay.tradeNo;
            NSDate *date = [NSDate date];
            NSString *time = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
            BmobObject *userOBJ = [BmobObject objectWithClassName:@"BuyOrder"];
            
            [userOBJ setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
            [userOBJ setObject:GoodName forKey:@"GoodName"];
            [userOBJ setObject:GoodDescription forKey:@"GoodDescription"];
            [userOBJ setObject:GoodPrice forKey:@"GoodPrice"];
            [userOBJ setObject:time forKey:@"BuyTime"];
            [userOBJ setObject:ObjectId forKey:@"GoodObjectId"];
            [userOBJ setObject:bPay.tradeNo forKey:@"BuyOrder_id"];
            [userOBJ setObject:@"0" forKey:@"GoodState"];
            [userOBJ saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
    //                    NSLog(@"订单上传成功");
                }
            }];
        } else{
//            NSLog(@"%@",[error description]);
        }
    }];
    
    
}

/**
 * @brief 支付成功时返回事件
 *
 */
-(void)paySuccess
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alter show];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"BuyOrder"];
    [bquery whereKey:@"BuyOrder_id" equalTo:BuyId];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = array.firstObject;
        
        [obj setObject:@"1" forKey:@"GoodState"];
        
        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//            NSLog(@"订单状态更新成功");
        }];
    }];
    
    BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"Goods"];
    [bquery1 whereKey:@"ObjectId" equalTo:ObjectId];
    [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *goodObject = array.firstObject;
        
        [goodObject setObject:@"0" forKey:@"good_buy"];
        [goodObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
//                NSLog(@"商品已经卖出,状态改变");
            }
        }];
    }];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobObject *userObject = [BmobObject objectWithClassName:@"Collect"];
    
   [userObject setObject:userName forKey:@"username"];
    [userObject setObject:ObjectId forKey:@"Saleout_id"];
    [userObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"成功");
    }];
    
    BmobObject *BuyObject = [BmobObject objectWithClassName:@"Collect"];
    [BuyObject setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
    [BuyObject setObject:ObjectId forKey:@"Buyed_id"];
    [BuyObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
         NSLog(@"成功");
    }];
    
    BmobQuery *userQuery = [BmobQuery queryWithClassName:@"Login"];
    [userQuery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *userObj = array.lastObject;
        [userObj setObject:GoodPrice forKey:@"Expense"];
        [userObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"成功");
        }];
    }];
    
}
/**
 *
 * @brief 支付失败时返回事件
 *
 * @param errorCode 错误码
 */
-(void)payFailWithErrorCode:(int) errorCode
{
    switch(errorCode){
            
        case 6001:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户中途取消" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 6002:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接出错" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 4000:{
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"订单支付失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
    }
}

/**
 * @brief 支付发生未知错误时返回事件
 */
-(void)payUnknow
{
    NSLog(@"未知");
}

@end
