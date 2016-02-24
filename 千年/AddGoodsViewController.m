//
//  AddGoodsViewController.m
//  千年
//
//  Created by God on 16/1/4.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LoginViewController1.h"
#import "UIView+Toast.h"
//#import "IQKeyboardReturnKeyHandler.h"
//#import "IQUIView+IQKeyboardToolbar.h"
@interface AddGoodsViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *Url;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImage;
@property (weak, nonatomic) IBOutlet UITextField *GoodsTitle;
@property (weak, nonatomic) IBOutlet UITextField *GoodsPrice;
@property (weak, nonatomic) IBOutlet UITextField *GoodsPrice_new;
@property (weak, nonatomic) IBOutlet UITextField *GoodsState;
@property (weak, nonatomic) IBOutlet UITextView *GoodsDescription;
@property (weak, nonatomic) IBOutlet UILabel *GoodsClass;
- (IBAction)GoodsImageAction:(id)sender;
- (IBAction)FabuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *UpLoadProgress;
@property (weak, nonatomic) IBOutlet UILabel *UploadLabel;
@property (weak, nonatomic) IBOutlet UIButton *SureButton;
- (IBAction)AbandonAction:(id)sender;
@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.GoodsClass.text = self.Goodsclass;
    
    self.SureButton.backgroundColor = [UIColor lightGrayColor];
    self.SureButton.enabled = NO;
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
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
- (IBAction)FabuAction:(id)sender {
    [self.view endEditing:YES];
    
    if([self.GoodsTitle.text isEqualToString:@""])
    {
        return;
    }
    if([self.GoodsPrice.text isEqualToString:@""])
    {
        self.GoodsPrice.text = @"0";
    }
    if([self.GoodsPrice_new.text isEqualToString:@""])
    {
        return;
    }
    if([self.GoodsState.text isEqualToString:@""])
    {
        return;
    }
    if([self.GoodsDescription.text isEqualToString:@""])
    {
        return;
    }
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    
//   if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
//   {
       [self saveData];
       AppDelegate *app = [UIApplication sharedApplication].delegate;
       TabBarViewController *tabVC = [[TabBarViewController alloc]init];
       tabVC.selectedIndex = 0;
       app.window.rootViewController = tabVC;
//   }else{
//
//       [self.view makeToast:@"未登录" duration:2.0 position:@"CSToastPositionCenter"];
//       
////       NSLog(@"qingd")
////       UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////       LoginViewController1 *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginView"];
////       [self.navigationController pushViewController:loginVC animated:YES];
//   }
//    [self dismissViewControllerAnimated:YES completion:nil];
  
    
    
}
-(void)saveData
{
    NSDate *nowDate = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%li",(long)[nowDate timeIntervalSince1970]];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    BmobObject *userObject = [[BmobObject alloc]initWithClassName:@"Goods"];
    [userObject setObject:self.GoodsTitle.text forKey:@"good_name"];
    [userObject setObject:self.GoodsPrice.text forKey:@"good_price"];
    [userObject setObject:self.GoodsDescription.text forKey:@"good_description"];
    [userObject setObject:self.GoodsPrice_new.text forKey:@"nick_name"];
    [userObject setObject:self.GoodsState.text forKey:@"good_state"];
    [userObject setObject:Url forKey:@"good_image"];
    [userObject setObject:[userdefaults objectForKey:@"username"] forKey:@"username"];
    [userObject setObject:self.GoodsClass.text forKey:@"good_class"];
    [userObject setObject:self.GoodsPrice_new.text forKey:@"good_pricenew"];
    [userObject setObject:time forKey:@"good_time"];
    [userObject setObject:@"1" forKey:@"good_buy"];
    [userObject setObject:@"0" forKey:@"good_rate"];
    [userObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful)
        {
            [self saveDateToCollectWith:time];
        }
    }];
}

-(void)saveDateToCollectWith:(NSString *)time
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
    [bquery whereKey:@"good_time" equalTo:time];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *wantedobj = array.firstObject;
        BmobObject *UserObject = [BmobObject objectWithClassName:@"Collect"];
        [UserObject setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
        [UserObject setObject:[wantedobj objectForKey:@"objectId"] forKey:@"sale_id"];
        [UserObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                NSLog(@"shojhdsafhjkdfghdkjsghhsdjkghsdfjklhgsdjk");
            }
        }];
    }];
}


- (IBAction)GoodsImageAction:(id)sender {
    __block NSUInteger sourceType = 0;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
            [alertController addAction:[UIAlertAction actionWithTitle:@"没钱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    imagePickerController.allowsEditing = NO;
    //4.设置是选择图片还是开启照相机
    imagePickerController.sourceType = sourcetype;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    self.UploadLabel.hidden = NO;
    self.UpLoadProgress.hidden = NO;
    [self.GoodsImage setImage:image];
    
    
    NSData *data=UIImageJPEGRepresentation(image,0.1);
    [BmobProFile uploadFileWithFilename:@".jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
        if (isSuccessful) {
            //打印文件名
            NSLog(@"filename %@",filename);
            //打印url
            Url = url;
//            NSLog(@"url %@",url);
//            NSLog(@"bmobFile:%@\n",bmobFile);
        } else {
            if (error) {
                NSLog(@"error %@",error);
            }
        }
    } progress:^(CGFloat progress) {
        NSLog(@"progress %f",progress);
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.UpLoadProgress setProgress:progress];
            self.UploadLabel.text = [NSString stringWithFormat:@"%.2f%%100",progress*100];
            if([self.UploadLabel.text isEqualToString:@"100.00%100"])
            {
                self.UploadLabel.text = @"完成";
                self.UploadLabel.textColor = [UIColor redColor];
                
                self.SureButton.backgroundColor = [UIColor redColor];
                self.SureButton.enabled = YES;
            }
        }];
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)AbandonAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"放弃发布" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"残忍退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dealloc
{
    returnKeyHandler = nil;
}

@end
