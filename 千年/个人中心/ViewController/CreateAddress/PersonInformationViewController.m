//
//  PersonInformationViewController.m
//  千年
//
//  Created by God on 16/1/6.
//  Copyright © 2016年 God. All rights reserved.
//

#import "PersonInformationViewController.h"
#import "UIImageView+WebCache.h"
@interface PersonInformationViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *Url;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)ChangeHeadImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *SextextField;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
- (IBAction)UpdateInformationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *DetailInformationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActionJUNHUA;
@property (weak, nonatomic) IBOutlet UIButton *SureButton;

@end

@implementation PersonInformationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    self.ActionJUNHUA.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"PersonCenter_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
//    self.ActionJUNHUA.isAnimating = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headButton.layer.cornerRadius = self.headButton.bounds.size.width/2.0;
    self.headButton.layer.masksToBounds = YES;
    
    self.headImage.layer.cornerRadius = self.headImage.bounds.size.width/2.0;
    self.headImage.layer.masksToBounds = YES;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]intValue]==1)
    {
        BmobQuery *bmobQuery = [BmobQuery queryWithClassName:@"Login"];
        [bmobQuery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
        [bmobQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *userObject = array.lastObject;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[userObject objectForKey:@"head_url"],Base_url]]];
            self.nickName.text = [userObject objectForKey:@"nick_name"];
            self.SextextField.text = [userObject objectForKey:@"sex"];
            self.DetailInformationLabel.text = [NSString stringWithFormat:@"加入闲淘时间%@",[userObject objectForKey:@"createdAt"]];
        }];
    }
    
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
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

- (IBAction)ChangeHeadImageAction:(id)sender {
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
    
    self.SureButton.backgroundColor = [UIColor lightGrayColor];
    self.SureButton.enabled = NO;
    
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
        if(progress<1)
        {
            self.ActionJUNHUA.hidden = NO;
            [self.ActionJUNHUA startAnimating];
        }else{
            [self.ActionJUNHUA stopAnimating];
            self.ActionJUNHUA.hidden = YES;
             [self.headImage setImage:image];
            self.SureButton.backgroundColor = [UIColor redColor];
            self.SureButton.enabled = YES;
        }
        
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)UpdateInformationAction:(id)sender {
    [self UpdateInformation];
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)UpdateInformation
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
    [bquery whereKey:@"username" equalTo:[userdefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *userObject = array.lastObject;
        [userObject setObject:self.SextextField.text forKey:@"sex"];
        [userObject setObject:self.nickName.text forKey:@"nick_name"];
        if(![Url isEqualToString:@""]){
            [userObject setObject:Url forKey:@"head_url"];
        }
        [userObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"更新成功");
             [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

-(void)dealloc{
    returnKeyHandler = nil;
}
@end
