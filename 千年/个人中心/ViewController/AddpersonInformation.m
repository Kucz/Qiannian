//
//  AddpersonInformation.m
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import "AddpersonInformation.h"
#import "ToolBarView.h"
#import "UIView+Toast.h"
#import "LoginViewController1.h"

@interface AddpersonInformation ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ToolBarViewDelegate>
{
    NSString *Url;
    UIPickerView *sexpickerview;
    UIDatePicker *agedatapickerview;
    
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
- (IBAction)Head_iamgeSet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *head_image;

@property (weak, nonatomic) IBOutlet UITextField *nick_name;
@property (weak, nonatomic) IBOutlet UITextField *sex_textfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
- (IBAction)Register_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *upLoadProgess;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;

@end

@implementation AddpersonInformation
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.head_image.layer.cornerRadius = self.head_image.bounds.size.width/2;
    self.head_image.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.RegisterButton setBackgroundColor:[UIColor lightGrayColor]];
    self.RegisterButton.enabled = NO;
    
    
    sexpickerview = [[UIPickerView alloc]init];
    sexpickerview.delegate =self;
    sexpickerview.dataSource =self;
    self.sex_textfield.inputView = sexpickerview;
    
    agedatapickerview = [[UIDatePicker alloc]init];
    agedatapickerview.datePickerMode=UIDatePickerModeDate;
    self.ageTextField.inputView = agedatapickerview;
    ToolBarView *toolbar = [ToolBarView loadView];
    self.ageTextField.inputAccessoryView = toolbar;
    toolbar.delegate = self;
    agedatapickerview.maximumDate = [NSDate date];
    
    
    // Do any additional setup after loading the view.
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Register_Action:(id)sender {
    
    if([[self.nick_name.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"用户名为空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if([[self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        [self.view makeToast:@"用户密码为空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    if(self.passwordTextField.text.length<6&&self.passwordTextField.text.length>20)
    {
        [self.view makeToast:@"密码不合法,请检查长度" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    [self saveData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[LoginViewController1 class]])
    {
        LoginViewController1 *LoginVC = (LoginViewController1 *)segue.destinationViewController;
        LoginVC.username = self.userName;
    }
}


-(void)saveData
{
    BmobObject *userObject = [[BmobObject alloc]initWithClassName:@"Login"];
    [userObject setObject:self.userName forKey:@"username"];
    [userObject setObject:self.passwordTextField.text forKey:@"password"];
    [userObject setObject:self.sex_textfield.text forKey:@"sex"];
    [userObject setObject:self.nick_name.text forKey:@"nick_name"];
    [userObject setObject:self.ageTextField.text forKey:@"age"];
    [userObject setObject:Url forKey:@"head_url"];
    [userObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful)
        {
            [self performSegueWithIdentifier:@"register" sender:self.userName];
        }
    }];
}
- (IBAction)Head_iamgeSet:(id)sender {
    __block NSUInteger sourceType = 0;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"从相册选择");
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self chooseImage:sourceType];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        //因为模拟器不支持拍照功能 所以需要判断是否支持拍照功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self chooseImage:sourceType];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起,您的手机不支持照相机" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//调用照相机或者相册
- (void)chooseImage:(NSUInteger)sourcetype{
    //1.创建UIImagePickerController对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //2.设置代理
    imagePickerController.delegate = self;
    //3.是否允许图片编辑
    imagePickerController.allowsEditing = YES;
    //4.设置是选择图片还是开启照相机
    imagePickerController.sourceType = sourcetype;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    [self.head_image setBackgroundImage:image forState:UIControlStateNormal];
    
    NSData *data=UIImageJPEGRepresentation(image,1);
    [BmobProFile uploadFileWithFilename:@".jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        if (isSuccessful) {
            //打印文件名
            NSLog(@"filename %@",filename);
            //打印url
            Url = url;
            NSLog(@"url %@",url);
            NSLog(@"bmobFile:%@\n",bmobFile);
        } else {
            if (error) {
                NSLog(@"error %@",error);
            }
        }
    } progress:^(CGFloat progress) {
        NSLog(@"progress %f",progress);
        [self.upLoadProgess setProgress:progress];
        if(progress==1)
        {
            [self.RegisterButton setBackgroundColor:[UIColor redColor]];
            self.RegisterButton.enabled = YES;
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --性别选择
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row==0)
    {
        return @"男";
    }else{
        return @"女";
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row==0)
    {
        self.sex_textfield.text=@"男";
    }else{
        self.sex_textfield.text=@"女";
    }
}
#pragma mark --datepickerview
-(void)toolBarView:(ToolBarView *)toolBarView didselectedCancelButton:(id)sender
{
    [self.view endEditing:YES];
}
-(void)toolBarView:(ToolBarView *)toolBarView didselectedDoneButton:(id)sender
{
    NSDate *nowdate = [NSDate date];
    [self.view endEditing:YES];
    NSDate *date =agedatapickerview.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *str = [formatter stringFromDate:date];
    NSString *str1 = [str substringToIndex:4];
    NSString *str2 = [formatter stringFromDate:nowdate];
    NSString *str3 = [str2 substringToIndex:4];
    int i =[str3 intValue]-[str1 intValue]+1;
    self.ageTextField.text = [NSString stringWithFormat:@"%i",i];
    [self.ageTextField setTextAlignment:NSTextAlignmentCenter];
}
-(void)dealloc
{
    returnKeyHandler = nil;
}

@end
