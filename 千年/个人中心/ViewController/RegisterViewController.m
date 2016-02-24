//
//  RegisterViewController.m
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIView+Toast.h"
#import "AddpersonInformation.h"
#import "NSString+Mobile.h"
static int i = 0;
@interface RegisterViewController ()
{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *YanZhengMaTextField;
- (IBAction)GetYanzhengmaAction:(id)sender;
- (IBAction)YanzhengAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *YanZhengMaTextField_button;
@property (weak, nonatomic) IBOutlet UIButton *Yanzheng_button;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Register_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_01"]];
    self.userNameTextField.leftView = imageView;
    self.YanZhengMaTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_01"]];
    self.YanZhengMaTextField.leftView = imageView1;
    
    self.YanZhengMaTextField_button.layer.cornerRadius = 2.0;
    self.Yanzheng_button.layer.cornerRadius = 5.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)GetYanzhengmaAction:(id)sender {
    
    if([[self.userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"用户名为空" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    if(![NSString validateMobile:self.userNameTextField.text])
    {
        [self.view makeToast:@"手机号码不正确" duration:1.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
    [bquery whereKey:@"username" equalTo:self.userNameTextField.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==0){
            NSLog(@"可以注册");
            [self GetYanZhengMa];
        }else{
            [self.view makeToast:@"手机号已被注册" duration:2.0 position:@"CSToastPositionCenter"];
            return ;
        }
    }];
}
- (IBAction)YanzhengAction:(id)sender {
    //验证码匹配验证
    [SMSSDK commitVerificationCode:self.YanZhengMaTextField.text phoneNumber:self.userNameTextField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
    [self performSegueWithIdentifier:@"addperson" sender:self.userNameTextField.text];
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
    }];
}

-(void)GetYanZhengMa
{
    if([self.YanZhengMaTextField_button.currentTitle isEqualToString:@"短信验证码"])
    {
        self.YanZhengMaTextField_button.enabled = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changNumber) userInfo:nil repeats:YES];
        [self.YanZhengMaTextField_button setBackgroundColor:[UIColor lightGrayColor]];
        [self.YanZhengMaTextField_button setTitle:@"已发送" forState:UIControlStateNormal];
        self.userNameTextField.enabled = NO;
        //获取短信验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.userNameTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error){
            if (!error) {
                NSLog(@"获取验证码成功");
                [self.view makeToast:@"验证码获取成功,请注意查收" duration:2.0 position:@"CSToastPositionCenter"];
            } else {
                NSLog(@"错误信息：%@",error);
                [self.view makeToast:@"验证码获取失败" duration:2.0 position:@"CSToastPositionCenter"];
            }
        }];
    }
}

-(void)changNumber
{
    [self.YanZhengMaTextField_button setBackgroundColor:[UIColor lightGrayColor]];
    [self.YanZhengMaTextField_button setTitle:[NSString stringWithFormat:@"重新获取%i秒后",300-i] forState:UIControlStateNormal];
    i++;
    if(i>300)
    {
        self.YanZhengMaTextField_button.enabled = YES;
        [self.YanZhengMaTextField_button setBackgroundColor:[UIColor blueColor]];
        [self.YanZhengMaTextField_button setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
        i=0;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[AddpersonInformation class]])
    {
        AddpersonInformation *addVC =(AddpersonInformation *)segue.destinationViewController;
        addVC.userName = sender;
    }
}
@end
