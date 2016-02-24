//
//  LoginViewController1.m
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import "LoginViewController1.h"
#import "NSString+Mobile.h"
#import "UIView+Toast.h"
//#import "EaseMob.h"
#import "MBProgressHUD.h"
#import "AddWantedViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
@interface LoginViewController1 ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (weak, nonatomic) IBOutlet UITextField *userNametextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordtextField;
- (IBAction)LoginAction:(id)sender;
- (IBAction)ForgetPasswordAction:(id)sender;
- (IBAction)RegisterAction:(id)sender;
@end

@implementation LoginViewController1
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"Login_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    self.userNametextField.text = [userDefault objectForKey:@"username"];
    
    if(self.username!=nil)
    {
        self.userNametextField.text=self.username;
        self.userNametextField.enabled = NO;
    }
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"登录中";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginAction:(id)sender {
    [self.view endEditing:YES];
    
    if([[self.userNametextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"用户名为空" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    if(![NSString validateMobile:self.userNametextField.text])
    {
        [self.view makeToast:@"手机号不合法" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    if([self.passWordtextField.text isEqualToString:@""])
    {
        [self.view makeToast:@"密码为空" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
    [bquery whereKey:@"username" equalTo:self.userNametextField.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = [array lastObject];
        if([self.passWordtextField.text isEqualToString:[obj objectForKey:@"password"]])
        {
            [HUD show:YES];
            NSLog(@"登录成功");
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.userNametextField.text forKey:@"username"];
            [userDefault setObject:@"1" forKey:@"Login"];
            
            [userDefault synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [userDefault setObject:@"1" forKey:@"Logining"];
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                TabBarViewController *TabVC = [[TabBarViewController alloc]init];
                TabVC.selectedIndex = 3;
                app.window.rootViewController = TabVC;
                 [HUD hide:YES];
            });
        }else{
            [self.view makeToast:@"密码错误,请重新输入" duration:1.0 position:@"CSToastPositionCenter"];
        }
    }];
}
-(void)dealloc
{
    returnKeyHandler = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)ForgetPasswordAction:(id)sender {
}

- (IBAction)RegisterAction:(id)sender {
}
@end
