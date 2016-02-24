//
//  SettingViewController.m
//  千年
//
//  Created by God on 16/1/6.
//  Copyright © 2016年 God. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "UIView+Toast.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *SetTableView;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
- (IBAction)ChangepasswordAction:(id)sender;
- (IBAction)AboutUSAction:(id)sender;


- (IBAction)ExitAction:(id)sender;
- (IBAction)CleanCacheAction:(id)sender;


@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"Setting——Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [SetTableView setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    SetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, winWidth, winHeight-64-49)];
    SetTableView.dataSource = self;
    SetTableView.delegate = self;
    
//    [self setUpAboutMe];
//    SetTableView.allowsSelection = NO;
//    SetTableView.all
    SetTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:SetTableView];
    [self SetChangView];//修改密码
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetChangView
{
    
    UIView *ChangepassView = [[UIView alloc]initWithFrame:CGRectMake(winWidth,0, winWidth, winHeight)];
    ChangepassView.tag = 100;
    [ChangepassView setBackgroundColor:[UIColor colorWithRed:181/255.0 green:226/255.0 blue:241/255.0 alpha:1.0]];
    [ChangepassView setAlpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, winWidth, 40)];
    label.text = @"修改密码";
    [label setTextAlignment:NSTextAlignmentCenter];

    [ChangepassView addSubview:label];
    UITextField *PhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, winWidth-20, 30)];
    UITextField *textFiele1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, winWidth-20, 30)];
    UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 200, winWidth-20, 30)];
    PhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [lab1 setFont:[UIFont systemFontOfSize:12]];
    [lab1 setText:@"手机号"];
    [lab1 setTextColor:[UIColor lightGrayColor]];
    PhoneNumber.leftView = lab1;
    PhoneNumber.tag = 101;
    PhoneNumber.layer.cornerRadius = 5.0;
    PhoneNumber.layer.borderWidth = 1;
    [PhoneNumber.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [lab2 setFont:[UIFont systemFontOfSize:12]];
    [lab2 setText:@"旧密码"];
    [lab2 setTextColor:[UIColor lightGrayColor]];
    textFiele1.leftViewMode = UITextFieldViewModeAlways;
    textFiele1.leftView = lab2;
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [lab3 setFont:[UIFont systemFontOfSize:12]];
    [lab3 setText:@"新密码"];
    [lab3 setTextColor:[UIColor lightGrayColor]];
    textField2.leftViewMode = UITextFieldViewModeAlways;
    textField2.leftView = lab3;
    textFiele1.layer.cornerRadius = 5.0;
    textFiele1.layer.borderWidth = 1;
    [textFiele1.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    textField2.layer.cornerRadius = 5.0;
    textField2.layer.borderWidth = 1;
    [textField2.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [textFiele1 setSecureTextEntry:YES];
    [textField2 setSecureTextEntry:YES];
    [textFiele1 setPlaceholder:@"请输入旧密码"];
    [textField2 setPlaceholder:@"请输入新密码"];
    textFiele1.tag = 102;
    textField2.tag = 103;
    [ChangepassView addSubview:PhoneNumber];
    [ChangepassView addSubview:textFiele1];
    [ChangepassView addSubview:textField2];
    
    UIButton *SureButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 250, winWidth/2-10, 30)];
    [SureButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [SureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [SureButton addTarget:self action:@selector(SureAction) forControlEvents:UIControlEventTouchUpInside];
    [ChangepassView addSubview:SureButton];
    
    UIButton *CancelButton = [[UIButton alloc]initWithFrame:CGRectMake(winWidth/2, 250, winWidth/2-10, 30)];
    [CancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [CancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(CancelAction) forControlEvents:UIControlEventTouchUpInside];
    [ChangepassView addSubview:CancelButton];
    [self.view addSubview:ChangepassView];
}

-(void)SureAction
{
     UITextField *textField = (UITextField *)[self.view viewWithTag:101];
    UITextField *PasstextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *NewpasstextField = (UITextField *)[self.view viewWithTag:103];
   if([textField.text isEqualToString:@""])
   {
       [self.view makeToast:@"账户为空" duration:2.0 position:@"CSToastPositionCenter"];
       return;
   }
    if([PasstextField.text isEqualToString:@""])
    {
        [self.view makeToast:@"请输入原密码" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    if([NewpasstextField.text isEqualToString:@""])
    {
        [self.view makeToast:@"请输入新密码" duration:2.0 position:@"CSToastPositionCenter"];
    }
    
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
    [bquery whereKey:@"username" equalTo:textField.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==0)
        {
            [self.view makeToast:@"用户名不存在,请查证" duration:2.0 position:@"CSToastPositionCenter"];
            return ;
        }
        BmobObject *Userobj = array.firstObject;
        if([[Userobj objectForKey:@"password"]isEqualToString:PasstextField.text])
        {
            NSLog(@"密码一致");
            [Userobj setObject:NewpasstextField.text forKey:@"password"];
            [Userobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    NSLog(@"更改成功");
                    [self.view makeToast:@"密码修改成功" duration:0.2 position:@"CSToastPositionCenter"];
                    [UIView animateWithDuration:0.2 animations:^{
                        self.navigationController.navigationBar.hidden = NO;
                        UIView *changeView = [self.view viewWithTag:100];
                        changeView.transform = CGAffineTransformMakeTranslation(winWidth, 0);
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setObject:@"0" forKey:@"Login"];
                        [userDefault synchronize];
                    }];
                    textField.text = @"";
                    PasstextField.text = @"";
                    NewpasstextField.text = @"";
                }
            }];
        }else{
            NSLog(@"密码不一致");
            [self.view makeToast:@"原始密码不正确" duration:2.0 position:@"CSToastPositionCenter"];
            return;
        }
    }];
    
}

-(void)CancelAction
{
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationController.navigationBar.hidden = NO;
        UIView *changeView = [self.view viewWithTag:100];
        changeView.transform = CGAffineTransformMakeTranslation(winWidth, 0);
    }];
    UITextField *textField = (UITextField *)[self.view viewWithTag:101];
    UITextField *PasstextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *NewpasstextField = (UITextField *)[self.view viewWithTag:103];
    textField.text = @"";
    PasstextField.text = @"";
    NewpasstextField.text = @"";
}
-(void)Changepassword
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:101];
    UIView *changView = [self.view viewWithTag:100];
    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
    if([[UserDefaults objectForKey:@"Login"]isEqualToString:@"1"])
    {
        textField.text = [UserDefaults objectForKey:@"username"];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationController.navigationBar.hidden = YES;
        changView.transform = CGAffineTransformMakeTranslation(-winWidth, 0);
    }];
}
- (IBAction)ChangepasswordAction:(id)sender {
    
    
}

- (IBAction)AboutUSAction:(id)sender {
}

- (IBAction)ExitAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"手滑了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"残忍退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
//        [userdefault removeObjectForKey:@"username"];
        [userdefault removeObjectForKey:@"Login"];
        [userdefault removeObjectForKey:@"Logining"];
        [userdefault removeObjectForKey:@"nick_name"];
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        TabBarViewController *tabVC = [[TabBarViewController alloc]init];
        tabVC.selectedIndex = 3;
        app.window.rootViewController = tabVC;
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)CleanCacheAction:(id)sender {
    if([self filepath]==0)
    {
        NSLog(@"0M缓存");
    }else{
        [self clearCach];
        NSLog(@"%.2f",[self filepath]);
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTable"];
    if(cell== nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SetTable"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderWidth = 1;
//        Color.rgb(59, 181, 250)
        cell.layer.borderColor = [UIColor colorWithRed:59/255.0 green:181/255.0 blue:250/255.0 alpha:1.0].CGColor;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if(indexPath.row==0)
    {
        cell.textLabel.text = @"修改密码";
    }else if (indexPath.row==1)
    {
        cell.textLabel.text = @"关于我们";
    }else if (indexPath.row==2)
    {
        cell.textLabel.text = @"清除缓存";
        if([self filepath]==0)
        {
            cell.detailTextLabel.text = @"暂无缓存";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self filepath]];
        }
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:@"1" forKey:@"clear"];
        [userdefault synchronize];
        
    }else{
        cell.textLabel.text = @"版本号";
        cell.detailTextLabel.text = @"V1.0.1";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        [self Changepassword];
    }else if(indexPath.row==1)
    {
        self.navigationController.navigationBar.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
//
            [self setUpAboutMe];
//            UIView *view1 =[self.view viewWithTag:200];
//            NSLog(@"%@",view1);
//            
//             view1.transform = CGAffineTransformMakeTranslation(-winWidth*2, 0);
        }];
    }else if (indexPath.row==2)
    {
        [self clearCach];
    }
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
}




#pragma mark 计算缓存
//计算缓存大小
-(float)filepath{
    
    //获得缓存路径
    NSString*cachpath  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [self folderSizeAtPath:cachpath];
    
}


//遍历缓存目录下的文件大小
-(float)folderSizeAtPath:(NSString *)folderPath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        return 0.0;
    }else{
        
        NSEnumerator *childfile = [[manager subpathsAtPath:folderPath] objectEnumerator];
        
        NSString *filename;
        
        long long folderSize=0.0;
        
        while ((filename =[childfile nextObject]) !=nil ) {
            
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:filename];
            
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
            
        }
        
        return folderSize/(1024.0*1024.0);
    }
    
}

//计算单个缓存文件的大小
-(long long)fileSizeAtPath:(NSString *)filepath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filepath]) {
        
        return [[manager attributesOfItemAtPath:filepath error:nil] fileSize];
        
    }
    
    return 0.0;
}


//清理缓存
-(void)clearCach{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //缓存路径
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //缓存下的所有文件
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *filepath in files) {
            
            NSError *error;
            
            NSString *path = [cachPath stringByAppendingPathComponent:filepath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        [self performSelectorOnMainThread:@selector(clearSuccess) withObject:nil waitUntilDone:YES];
        
    });
    
}

-(void)setUpAboutMe
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [imageview setImage:[UIImage imageNamed:@"AboutMeImage"]];
    imageview.userInteractionEnabled = YES;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    imageview.tag = 1000;
    backButton.tag = 1001;
    [self.view addSubview:imageview];
    [self.view addSubview:backButton];
}

//清除成功
-(void)clearSuccess{
    
    [self.view makeToast:@"清除缓存成功" duration:1.0 position:@"center"];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    [SetTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)backView:(UIButton *)sender
{
    UIView *view = [self.view viewWithTag:1001];
    UIView *view1 = [self.view viewWithTag:1000];
    
    [view removeFromSuperview];
    [view1 removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
//    view.transform = CGAffineTransformIdentity;
}

-(void)dealloc
{
    returnKeyHandler = nil;
}
@end
