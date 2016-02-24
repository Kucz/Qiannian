//
//  ResetViewController.m
//  千年
//
//  Created by God on 15/12/30.
//  Copyright © 2015年 God. All rights reserved.
//

#import "ResetViewController.h"
#import "LoginViewController1.h"
#import "UIView+Toast.h"
@interface ResetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpassWordTextField;
- (IBAction)Sure_action:(id)sender;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)Sure_action:(id)sender {
    if([[self.passWordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"密码为空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if(self.passWordTextField.text.length>5&&self.passWordTextField.text.length<21)
    {
        if([self.passWordTextField.text isEqualToString:self.newpassWordTextField.text])
        {
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
            [bquery whereKey:@"username" equalTo:self.userName];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if(array.count==0)
                {
                    [self.view makeToast:@"用户不存在" duration:2.0 position:@"CSToastPositionCenter"];
                    return ;
                }else{
                    BmobObject *userObject =array.lastObject;
                    [userObject setObject:self.passWordTextField.text forKey:@"password"];
                    [userObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        NSLog(@"更新成功");
                        [self performSegueWithIdentifier:@"Login" sender:self.userName];
                    }];
                }
            }];
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[LoginViewController1 class]])
    {
        LoginViewController1 *LoginVC = (LoginViewController1 *)segue.destinationViewController;
        LoginVC.username = self.userName;
    }
}

@end
