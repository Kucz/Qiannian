//
//  TabBarViewController.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "TabBarViewController.h"
#import "XZMTabbarExtension.h"
#import "AppDelegate.h"
#import "CenterViewController.h"
#import "LoginViewController1.h"
#import "UIView+Toast.h"
#import "AboutMeViewController.h"
#import "HopeCommentModel.h"
static int bagdeCount = 0;
@interface TabBarViewController ()<UITabBarControllerDelegate>
{
    NSTimer *timer;
    NSString *CommentTime;
    NSString *GoodCommentTime;
//    AboutMeViewController *ab;
    UINavigationController *nav3;
    
    NSString *PlistPath;
    NSMutableArray *CommentArray;
}
@end

@implementation TabBarViewController


+(void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];

    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
//    Color.rgb(29, 153, 229)
    selDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:29/255.0 green:153/255.0 blue:229/255.0 alpha:1.0];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    CommentArray = [NSMutableArray array];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"GoodUpdate"]isEqualToString:@""])
    {
        [self getMaxUpdateWithClass:@"GoodComment"];
    }else{
        GoodCommentTime = [userDefault objectForKey:@"GoodUpdate"];
    }
    
    if([[userDefault objectForKey:@"WantedUpdate"]isEqualToString:@""])
    {
        [self getMaxUpdateWithClass:@"Comment"];
    }else{
        CommentTime = [userDefault objectForKey:@"WantedUpdate"];
    }
    PlistPath = [NSString stringWithFormat:@"%@/Library/Caches/Comment.plist",NSHomeDirectory()];
    CommentArray = [self ReturnCommentplist:PlistPath];
    
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Update:) userInfo:nil repeats:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav1 = [sb instantiateViewControllerWithIdentifier:@"shouye"];
//    UINavigationController *nav1 = [sb]
    UINavigationController *nav2 = [sb instantiateViewControllerWithIdentifier:@"wanted"];
    nav3 = [sb instantiateViewControllerWithIdentifier:@"message"];
    UINavigationController *nav4 = [sb instantiateViewControllerWithIdentifier:@"person"];
    UIImage *image = [UIImage imageNamed:@"add_02"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarController.tabBarItem setImage:image];
//    [self setupNav:nav1 withImaheName:@"01_home"];
    [self setupNav:nav1 withImaheName:@"Home_icon"];
    [self setupNav:nav2 withImaheName:@"Wanted_icon"];
    [self setupNav:nav3 withImaheName:@"About_icon"];
    [self setupNav:nav4 withImaheName:@"Person_icon"];
    [self.tabBar setUpTabBarCenterButton:^(UIButton * _Nullable centerButton) {
        [centerButton setBackgroundImage:[UIImage imageNamed:@"Add_icon"] forState:UIControlStateNormal];
        [centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
    }];
    self.delegate = self;

//    NSLog(@"%@",NSHomeDirectory());
    
}

-(void)chickCenterButton
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        CenterViewController *centerVC = [[CenterViewController alloc]init];
        [self presentViewController:centerVC animated:YES completion:nil];
    }else{
        [self.view makeToast:@"您未登录,请登录" duration:2.0 position:@"CSToastPositionCenter"];
    }
   
}

-(void)Update:(NSTimer *)time
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        if([[userDefault objectForKey:@"clear"]isEqualToString:@"1"])
        {
            CommentArray = [self ReturnCommentplist:PlistPath];
            [userDefault removeObjectForKey:@"clear"];
            [userDefault synchronize];
        }
        [self getUpdateTimeWithTimeSecond:[GoodCommentTime integerValue]];
        [self getUpdateCommentTimeWithTimeSecond:[CommentTime integerValue]];
    }else{
        [timer invalidate];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupNav:(UINavigationController *)navVC  withImaheName:(NSString *)imageName
{
    UINavigationController *nav = navVC;
    UIImage *image = [UIImage imageNamed:imageName];
     UIImage *image1 = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.image = image1;
    nav.tabBarItem.selectedImage =image;
    [self addChildViewController:nav];
}
-(void)getMaxUpdateWithClass:(NSString *)className
{
    __block int i =0;
    BmobQuery *bquery = [BmobQuery queryWithClassName:className];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = array.firstObject;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[obj objectForKey:@"updatedAt"]];
        NSString *string = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
        GoodCommentTime = string;
        for(BmobObject *userObj in array)
        {
            i++;
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:[userObj objectForKey:@"updatedAt"]];
            NSString *stringSub = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
            if([GoodCommentTime integerValue]<[stringSub integerValue])
            {
                if([className isEqualToString:@"GoodComment"])
                {
                     GoodCommentTime = stringSub;
                }else{
                    CommentTime = stringSub;
                }
            }
        }
    }];
}

-(void)getUpdateTimeWithTimeSecond:(NSInteger)Second
{
    __block int i = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"GoodComment"];
    bquery.limit = 1000;
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger arrayCount = array.count;
        NSString *stringsub;
        stringsub = GoodCommentTime;
        for(BmobObject *uobj in array)
        {
            i++;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:[uobj objectForKey:@"updatedAt"]];
            NSString *string = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
            if([string integerValue]>Second)
            {
                if([stringsub integerValue]<[string integerValue])
                {
                    stringsub = string;
                }
                if(![[userDefault objectForKey:@"username"]isEqualToString:[uobj objectForKey:@"comment_id"]])
                {
                    if([uobj objectForKey:@"ReGoodComment"]!=nil)
                    {
                        bagdeCount++;
                        NSMutableDictionary *ComDictionary = [NSMutableDictionary dictionary];
                        ComDictionary = [self changeWithBmobObject:uobj WithState:4];
                        [self SaveArray:ComDictionary];
                    }else{
                        bagdeCount++;
                        NSMutableDictionary *ComDictionary = [NSMutableDictionary dictionary];
                        ComDictionary = [self changeWithBmobObject:uobj WithState:3];
                        [self SaveArray:ComDictionary];
                    }
                }
            }
            
            if(arrayCount==i)
            {
                GoodCommentTime = stringsub;
                [userDefault setObject:GoodCommentTime forKey:@"GoodUpdate"];
                [userDefault synchronize];
            }
            if([[userDefault objectForKey:@"username"]isEqualToString:[uobj objectForKey:@"comment_id"]])
            {
                nav3.tabBarItem.badgeValue = nil;
            }else{
                if(bagdeCount>0)
                {
                    nav3.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",bagdeCount];
                }
            }
        }
    }];
}

-(void)getUpdateCommentTimeWithTimeSecond:(NSInteger)Second
{
    __block int i = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    bquery.limit = 1000;
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger arrayCount = array.count;
        NSString *stringsub;
        stringsub = CommentTime;
        for(BmobObject *uobj in array)
        {
            i++;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:[uobj objectForKey:@"updatedAt"]];
            NSString *string = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
            if([string integerValue]>Second)
            {
                if([stringsub integerValue]<[string integerValue])
                {
                    stringsub = string;
                }
                if([uobj objectForKey:@"Recomment"]!=nil)
                {
                   bagdeCount++;
                    NSMutableDictionary *ComDictionary = [NSMutableDictionary dictionary];
                    ComDictionary = [self changeWithBmobObject:uobj WithState:2];
                    [self SaveArray:ComDictionary];
                }else{
                   bagdeCount++;
                    
                    NSMutableDictionary *ComDictionary = [NSMutableDictionary dictionary];
                    ComDictionary = [self changeWithBmobObject:uobj WithState:1];
                    [self SaveArray:ComDictionary];
                }
            }
            
            if(arrayCount==i)
            {
                CommentTime = stringsub;
                [userDefault setObject:CommentTime forKey:@"WantedUpdate"];
                [userDefault synchronize];
            }
            
            if(bagdeCount>0)
            {
                nav3.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",bagdeCount];
            }
        }
    }];
}

-(NSMutableDictionary *)changeWithBmobObject:(BmobObject *)uobj WithState:(NSInteger)state
{
    
    NSMutableDictionary *ComDictionary  =[NSMutableDictionary dictionary];
    [ComDictionary setObject:[uobj objectForKey:@"comment_id"] forKey:@"CommentId"];
    [ComDictionary setObject:[uobj objectForKey:@"username"] forKey:@"username"];
    [ComDictionary setObject:[uobj objectForKey:@"good_id"] forKey:@"goodId"];
    [ComDictionary setObject:[uobj objectForKey:@"comment_description"] forKey:@"CommentDesc"];
    [ComDictionary setObject:[uobj objectForKey:@"comment_time"] forKey:@"CommentTime"];
    [ComDictionary setObject:[uobj objectForKey:@"objectId"] forKey:@"objectId"];
    
    if(state==2)
    {
      [ComDictionary setObject:[uobj objectForKey:@"Recomment"] forKey:@"Recomment"];
      [ComDictionary setObject:@"2" forKey:@"CommentClass"];        //求购回复评论
    }else if(state==1){
        [ComDictionary setObject:@"1" forKey:@"CommentClass"];      //求购回复
    }else if (state==3)
    {
        [ComDictionary setObject:@"3" forKey:@"CommentClass"];      //商品留言
    }else{
        [ComDictionary setObject:@"4" forKey:@"CommentClass"];      //商品留言回复
        [ComDictionary setObject:[uobj objectForKey:@"ReGoodComment"] forKey:@"Recomment"];
    }
    
    return ComDictionary;
}

-(void)SaveArray:(NSMutableDictionary *)tmpDict
{
    int j = -1;
    for(int i = 0 ;i<CommentArray.count;i++)
    {
        NSDictionary *tmpDict1 = CommentArray[i];
        if([[tmpDict1 objectForKey:@"objectId"]isEqualToString:[tmpDict objectForKey:@"objectId"]])
        {
            j=i;
        }
    }
    
    if(j>=0)
    {
        [CommentArray removeObjectAtIndex:j];
    }
    [CommentArray addObject:tmpDict];
    if(CommentArray!=nil)
    {
        [CommentArray writeToFile:PlistPath atomically:YES];
    }

}

#pragma mark UITabbarviewControllerDelegate  
//如果选择了第三个视图，那么就把角标归零
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if(nav == nav3)
    {
        bagdeCount = 0;
        nav3.tabBarItem.badgeValue = nil;
    }
}

-(NSMutableArray *)ReturnCommentplist:(NSString *)plistPath
{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    if(array!=nil)
    {
         dataArray =[array mutableCopy];
    }
    return dataArray;
}

@end
