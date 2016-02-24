//
//  ForgetViewController.m
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import "ForgetViewController.h"
#import "NSString+Mobile.h"
#import "UIView+Toast.h"
#import "ResetViewController.h"
static int i = 0;
@interface ForgetViewController ()
{
    NSTimer *timer;
}
//@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *YanzhengmaTextField;
- (IBAction)YanZheng_Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Yanzheng_button;
- (IBAction)YanZheng_Last_Action:(id)sender;

@end

@implementation ForgetViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Yanzheng_button.layer.cornerRadius = 10.0;
    
    UIImage *image = [UIImage imageNamed:@"ReSetPassWord_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)changNumber
{
    [self.Yanzheng_button setBackgroundColor:[UIColor lightGrayColor]];
    [self.Yanzheng_button setTitle:[NSString stringWithFormat:@"重新获取%i秒后",300-i] forState:UIControlStateNormal];
    
    i++;
    if(i>300)
    {
        self.Yanzheng_button.enabled = YES;
        [self.Yanzheng_button setBackgroundColor:[UIColor blueColor]];
        [self.Yanzheng_button setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
        i=0;
    }
}

- (IBAction)YanZheng_Action:(id)sender {
    if([[self.UserNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"手机号为空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if(![NSString validateMobile:self.UserNameTextField.text])
    {
        [self.view makeToast:@"手机号码不合法" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if([self.Yanzheng_button.currentTitle isEqualToString:@"重置密码"]||[self.Yanzheng_button.currentTitle isEqualToString:@"重新获取"])
    {
       self.Yanzheng_button.enabled = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changNumber) userInfo:nil repeats:YES];
        [self.Yanzheng_button setBackgroundColor:[UIColor lightGrayColor]];
        [self.Yanzheng_button setTitle:@"已发送" forState:UIControlStateNormal];
       // 获取短信验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.UserNameTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error){
            if (!error) {
                NSLog(@"获取验证码成功");
            } else {
                NSLog(@"错误信息：%@",error);
            }
        }];
    }
}
- (IBAction)YanZheng_Last_Action:(id)sender {
    [SMSSDK commitVerificationCode:self.YanzhengmaTextField.text phoneNumber:self.UserNameTextField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"Forget" sender:self.UserNameTextField.text];
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[ResetViewController class]])
    {
        ResetViewController *resetVC = (ResetViewController *)segue.destinationViewController;
        resetVC.userName = (NSString *)sender;
    }
}
@end
