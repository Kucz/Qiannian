//
//  ExpendViewController.m
//  千年
//
//  Created by God on 16/1/28.
//  Copyright © 2016年 God. All rights reserved.
//

#import "ExpendViewController.h"
#import "UserInformation.h"
@interface ExpendViewController ()
{
    NSUserDefaults *userDefault ;
}
@property (weak, nonatomic) IBOutlet UILabel *EarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *ExpenseLabel;

@end

@implementation ExpendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    [UserInformation loaduserinformationFromLoginWithUsername:[userDefault objectForKey:@"username"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Update:) name:@"UserInfo" object:nil];
    
    self.EarnLabel.text = @"0";
    self.ExpenseLabel.text = @"0";
    
    UIImage *image = [UIImage imageNamed:@"MyEarn"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.na
    // Do any additional setup after loading the view from its nib.
}

-(void)Update:(NSNotification *)notification
{
    UserInformation *model = notification.object;
    if(model.earn ==Nil)
    {
        self.EarnLabel.text = @"0";
    }else{
        self.EarnLabel.text = model.earn;
    }
    if(model.expense == Nil)
    {
        self.ExpenseLabel.text = @"0";
    }else{
        self.ExpenseLabel.text = model.expense;
    }
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

@end
