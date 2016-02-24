//
//  AddWantedViewController.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "AddWantedViewController.h"
#import "WantedBuyTableViewController.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "EightModel.h"
#import "ClassView.h"
#import "UIButton+WebCache.h"

@interface AddWantedViewController ()
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
//    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}
@property (weak, nonatomic) IBOutlet UITextField *wanted_title;
@property (weak, nonatomic) IBOutlet UITextField *wanted_class;
@property (weak, nonatomic) IBOutlet UITextField *wanted_price;
@property (weak, nonatomic) IBOutlet UITextView *wanted_description;
- (IBAction)SaveWantedBuyAction:(id)sender;
- (IBAction)ChoseClassAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *ClassArraay;
@end

@implementation AddWantedViewController
-(NSMutableArray *)ClassArraay
{
    if(_ClassArraay == nil)
    {
        _ClassArraay = [NSMutableArray array];
    }
    return _ClassArraay;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    Color.rgb(175, 226, 243)
    [self.view setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:1.0]];
    
    self.tabBarController.tabBar.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"WantedIssue_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self setUpView];
    // Do any additional setup after loading the view.
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)SaveWantedBuyAction:(id)sender {
    NSDate *nowDate = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%li",(long)[nowDate timeIntervalSince1970]];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    BmobObject *addObject  =[BmobObject objectWithClassName:@"WantedBuy"];
    if([self.wanted_title.text isEqualToString:@""]||[self.wanted_class.text isEqualToString:@""]||[self.wanted_price.text isEqualToString:@""]||[self.wanted_description.text isEqualToString:@""])
    {
        [self.view makeToast:@"输入项有空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    if(self.wanted_description.text.length>5&&self.wanted_description.text.length<100)
    {
            [addObject setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
            [addObject setObject:self.wanted_title.text forKey:@"wanted_title"];
            [addObject setObject:self.wanted_class.text forKey:@"wanted_class"];
            [addObject setObject:self.wanted_price.text forKey:@"wanted_price"];
            [addObject setObject:self.wanted_description.text forKey:@"wanted_description"];
            [addObject setObject:time forKey:@"wanted_time"];
            [addObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
//                    NSLog(@"保存成功");
                    [self saveDateToCollectWith:time];
//                    [self.navigationController popViewControllerAnimated:YES];
                    AppDelegate *app = [UIApplication sharedApplication].delegate;
                    TabBarViewController *tabVC = [[TabBarViewController alloc]init];
                    tabVC.selectedIndex = 1;
                    app.window.rootViewController = tabVC;
                }
            }];
    }
}

- (IBAction)ChoseClassAction:(id)sender {
    [EightModel Getdata];
    [self.view endEditing:YES];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setClassButton:) name:@"eight" object:nil];
    for(UIView *view in [self.view subviews])
    {
        if(view.tag!=11111)
        {
            view
            .hidden = YES;
        }
    }
    ClassView *CLASSVIEW = [self.view viewWithTag:11111];
    [UIView animateWithDuration:0.5 animations:^{
       CLASSVIEW.transform = CGAffineTransformMakeTranslation(0,-CLASSVIEW.bounds.size.height);
    }];
}
-(void)setClassButton:(NSNotification *)notification
{
     self.ClassArraay = notification.object;
    ClassView *CLASSVIEW = [self.view viewWithTag:11111];
    int i = 0;
    for(ClassView *classVIEW in [CLASSVIEW subviews])
    {
        EightModel *model = self.ClassArraay[i];
        i++;
        [classVIEW.classBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.class_image,Base_url]] forState:UIControlStateNormal];
        classVIEW.classLab.text = model.class_name;
    }
}

-(void)setUpView
{
    CGFloat Magin = 10;
    CGFloat ViewWidth = (winWidth-5*10)/4;
    CGFloat ViewHeight = ViewWidth + 30;
    UIView *Classview = [[UIView alloc] initWithFrame:CGRectMake(0, winHeight, winWidth, winWidth)];
    Classview.alpha = 1.0;
    Classview.tag = 11111;
    for(int i=0;i<8;i++)
    {
        int col = i/4;
        int row = i%4;
        ClassView *classView = [[ClassView alloc] initWithFrame:CGRectMake(Magin+(ViewWidth+Magin)*row, Magin+(ViewHeight+Magin)*col, ViewWidth, ViewHeight)];
        classView.classBtn.tag = 100+i;
        classView.classBtn.layer.cornerRadius = classView.classBtn.bounds.size.width/2.0;
        classView.classBtn.layer.masksToBounds = YES;
        [classView.classBtn addTarget:self action:@selector(UpdateImage:) forControlEvents:UIControlEventTouchUpInside];
        [Classview addSubview:classView];
    }
    [self.view addSubview:Classview];
}

-(void)UpdateImage:(UIButton *)sender
{
    self.navigationController.navigationBar.hidden = NO;
    ClassView *CLASSVIEW = [self.view viewWithTag:11111];
    EightModel *model = self.ClassArraay[sender.tag-100];
    self.wanted_class.text = model.class_name;
    CLASSVIEW.transform = CGAffineTransformIdentity;
    for(UIView *view in [self.view subviews])
    {
        if(view.tag!=11111)
        {
            view.hidden = NO;
        }
    }
}

-(void)saveDateToCollectWith:(NSString *)time
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WantedBuy"];
    [bquery whereKey:@"wanted_time" equalTo:time];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *wantedobj = array.firstObject;
        BmobObject *UserObject = [BmobObject objectWithClassName:@"Collect"];
        [UserObject setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
        [UserObject setObject:[wantedobj objectForKey:@"objectId"] forKey:@"wanted_id"];
        [UserObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
//                NSLog(@"shojhdsafhjkdfghdkjsghhsdjkghsdfjklhgsdjk");
            }
        }];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    self.navigationController.navigationBar.hidden = NO;
    
    ClassView *classview = [self.view viewWithTag:11111];
    if(classview)
    {
        [UIView animateWithDuration:0.5 animations:^{
            classview.transform = CGAffineTransformIdentity;
            for(UIView *view in [self.view subviews])
            {
                if(view.tag!=11111)
                {
                    view.hidden = NO;
                }
            }
        }];
    }
}
-(void)dealloc
{
    returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
