//
//  NewaddressViewController.m
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import "NewaddressViewController.h"
#import "UIView+Toast.h"
@interface NewaddressViewController ()
{
    NSUserDefaults *userDefaults;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (weak, nonatomic) IBOutlet UITextField *PersonName;
@property (weak, nonatomic) IBOutlet UITextField *PersonPhone;
@property (weak, nonatomic) IBOutlet UITextField *PersonCity;
@property (weak, nonatomic) IBOutlet UITextField *PersonStreet;
- (IBAction)AddAddressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddButton;

@end

@implementation NewaddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *image = [UIImage imageNamed:@"NewAddress_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    if([[userDefaults objectForKey:@"ADDRESS"]isEqualToString:@"1"])
    {
        self.PersonName.text = [self.AddressDict objectForKey:@"Name"];
        self.PersonPhone.text = [self.AddressDict objectForKey:@"Phone"];
        self.PersonCity.text = [self.AddressDict objectForKey:@"City"];
        self.PersonStreet.text = [self.AddressDict objectForKey:@"Street"];
        
        [self.AddButton setTitle:@"更新并保存" forState:UIControlStateNormal];
        
    }else{
        if([[userDefaults objectForKey:@"Login"]isEqualToString:@"1"])
        {
            self.PersonPhone.text = [userDefaults objectForKey:@"username"];
        }
    }
//
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [userDefaults removeObjectForKey:@"ADDRESS"];
    [userDefaults synchronize];
}

- (IBAction)AddAddressAction:(id)sender {
    if([self.PersonName.text isEqualToString:@""])
    {
        [self.view makeToast:@"收件人为空" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    if([self.PersonCity.text isEqualToString:@""])
    {
        [self.view makeToast:@"地址为空" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    if([[userDefaults objectForKey:@"ADDRESS"]isEqualToString:@"1"])
    {
        [self updateAddress];
    }else{
        [self saveAddress];
    }
    
}

//更新原有
-(void)updateAddress
{
    NSDate *nowDate = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%li",(long)[nowDate timeIntervalSince1970]];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Address"];
    [bquery getObjectInBackgroundWithId:[self.AddressDict objectForKey:@"ID"] block:^(BmobObject *object, NSError *error) {
        [object setObject:self.PersonName.text forKey:@"address_person"];
        [object setObject:self.PersonCity.text forKey:@"address_city"];
        [object setObject:self.PersonStreet.text forKey:@"address_street"];
        [object setObject:self.PersonPhone.text forKey:@"address_phone"];
        [object setObject:[userDefaults objectForKey:@"username"] forKey:@"username"];
        [object setObject:time forKey:@"address_time"];
        
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }];
}

//保存新建
-(void)saveAddress
{
    NSDate *nowDate = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%li",(long)[nowDate timeIntervalSince1970]];
    BmobObject *addressobject = [BmobObject objectWithClassName:@"Address"];
    [addressobject setObject:self.PersonName.text forKey:@"address_person"];
    [addressobject setObject:self.PersonCity.text forKey:@"address_city"];
    [addressobject setObject:self.PersonStreet.text forKey:@"address_street"];
    [addressobject setObject:self.PersonPhone.text forKey:@"address_phone"];
    [addressobject setObject:[userDefaults objectForKey:@"username"] forKey:@"username"];
    [addressobject setObject:time forKey:@"address_time"];
    [addressobject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful)
        {
            NSLog(@"添加成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


-(void)dealloc
{
    returnKeyHandler = nil;
}
@end
