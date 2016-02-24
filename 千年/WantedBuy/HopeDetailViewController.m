//
//  HopeDetailViewController.m
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import "HopeDetailViewController.h"
#import "UIButton+WebCache.h"
#import "WantedByModel.h"
#import "UIView+Toast.h"
#import "HopeCommentModel.h"
#import "HopeCommentCell.h"
#import "PersonDetailViewController.h"
@interface HopeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DidselectDelegate>
{
    HopeCommentModel *Remodel;
    UILabel *label;
    UITableView *HopeTableView;
    
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    
}
- (IBAction)Head_action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *head_image;
@property (weak, nonatomic) IBOutlet UILabel *nick_name;
@property (weak, nonatomic) IBOutlet UILabel *hope_time;
@property (weak, nonatomic) IBOutlet UILabel *hope_title;
@property (weak, nonatomic) IBOutlet UILabel *hope_price;

@property (weak, nonatomic) IBOutlet UITextField *CommentTextField;


@property (nonatomic, strong) NSMutableArray *CommentArray;
- (IBAction)AddCommentAction:(id)sender;


@end

@implementation HopeDetailViewController
-(NSMutableArray *)CommentArray
{
    if(_CommentArray == nil)
    {
        _CommentArray = [NSMutableArray array];
    }
    return _CommentArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [HopeCommentModel LoadDataFromClassCommentWithGoodid:self.Hopemodel.objectId];
    
    UIImage *image = [UIImage imageNamed:@"WantedDetail_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [self setupHopeView];
    [self.view addSubview:label];
    
    UIView *Lastview = [self.view viewWithTag:10001];
    HopeTableView = [[UITableView alloc]init];
    CGFloat Tableview_Y = CGRectGetMaxY(Lastview.frame);
    CGFloat Tableview_height = winHeight-44 -Tableview_Y;
    [HopeTableView setFrame:CGRectMake(0, Tableview_Y, winWidth, Tableview_height)];
    HopeTableView.tableFooterView = [UIView new];
    [self.view addSubview:HopeTableView];
    HopeTableView.dataSource = self;
    HopeTableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(XXX:) name:@"Comment" object:nil];
    [HopeTableView setBackgroundColor:[UIColor colorWithRed:175/255.0 green:226/255.0 blue:243/255.0 alpha:0.9]];
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
}
-(void)XXX:(NSNotification *)notification
{
//    NSArray *array =[NSArray arrayWithArray:notification.object];
    self.CommentArray = notification.object;
//    [self.CommentArray addObjectsFromArray:notification.object];
    [HopeTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HopeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if(cell == nil)
    {
        cell = [[HopeCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.model = self.CommentArray[indexPath.row];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor= [[UIColor lightGrayColor]CGColor];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"留言%li",self.CommentArray.count];
}
#pragma mark UItableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HopeCommentCell *cell = [[HopeCommentCell alloc]init];
    HopeCommentModel *model = self.CommentArray[indexPath.row];
    model.Row= indexPath.row;
    cell.model  = model;
    return cell.Height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *LoginUser = [userdefault objectForKey:@"nick_name"];
    [userdefault setObject:@"1" forKey:@"Recomment"];
    Remodel = self.CommentArray[indexPath.row];
    [self.CommentTextField becomeFirstResponder];
    self.CommentTextField.placeholder = [NSString stringWithFormat:@"%@回复%@",LoginUser,Remodel.comment_nick];
    [userdefault synchronize];
}



-(void)setupHopeView
{
    [self.head_image sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.Hopemodel.ImageUrl,Base_url]] forState:UIControlStateNormal];
    self.hope_price.text = [NSString stringWithFormat:@"¥:%@",self.Hopemodel.Price];
    self.hope_title.text = self.Hopemodel.Title;
    self.nick_name.text = self.Hopemodel.name;
    self.hope_time.text = [NSString timeWithString:self.Hopemodel.Time];
    label.text = [NSString stringWithFormat:@"描述:%@",self.Hopemodel.Description];
    CGFloat hope_x = 10;
    CGFloat hope_y = CGRectGetMaxY(self.hope_price.frame);
    CGSize Hope_size = [label.text boundingRectWithSize:CGSizeMake(winWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}context:nil].size;
    [label setFrame:CGRectMake(hope_x, hope_y, Hope_size.width, Hope_size.height)];
    label.font = [UIFont systemFontOfSize:12];
    UIView *BlackView = [[UIView alloc]init];
    CGFloat black_Y = CGRectGetMaxY(label.frame);
//    Color.rgb(178, 226, 242)
    [BlackView setBackgroundColor:[UIColor darkGrayColor]];
    [BlackView setFrame:CGRectMake(0, black_Y, winWidth, 1)];
    BlackView.tag = 10001;
    [self.view addSubview:BlackView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)Head_action:(id)sender {
    
    PersonDetailViewController *perdetaiVC = [[PersonDetailViewController alloc] init];
    perdetaiVC.UserNAME = self.Hopemodel.userName;
    [self.navigationController pushViewController:perdetaiVC animated:YES];
    
    
}

- (IBAction)AddCommentAction:(id)sender {
    [self.view endEditing:YES];
     self.CommentTextField.placeholder =@"请输入留言";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]intValue]!=1)
    {
        [self.view makeToast:@"您还未登陆,不能留言" duration:2.0 position:@"CSToastPositionCenter"];
        [userDefault removeObjectForKey:@"Recomment"];
        return;
    }
    if([self.CommentTextField.text isEqualToString:@""])
    {
        [self.view makeToast:@"留言内容为空" duration:2.0 position:@"CSToastPositionCenter"];
        [userDefault removeObjectForKey:@"Recomment"];
        return;
    }
    
    if([[userDefault objectForKey:@"Recomment"]isEqualToString:@"1"])
    {
        [userDefault removeObjectForKey:@"Recomment"];
        [userDefault synchronize];
        if([[userDefault objectForKey:@"RECOMMENT"]isEqualToString:@"2"])
        {
            [userDefault removeObjectForKey:@"RECOMMENT"];
            [userDefault synchronize];
            
            NSMutableArray *ReComArray = [NSMutableArray array];
            [ReComArray addObject:[userDefault objectForKey:@"username"]];
            [ReComArray addObject:self.ReNameID];
            [ReComArray addObject:[userDefault objectForKey:@"nick_name"]];
            [ReComArray addObject:self.ReNick];
            [ReComArray addObject:self.CommentTextField.text];
            [Remodel.RecommentArray addObject:ReComArray];
            
        }else{
            NSMutableArray *ReComArray = [NSMutableArray array];
            [ReComArray addObject:[userDefault objectForKey:@"username"]];
            [ReComArray addObject:Remodel.comment_id];
            [ReComArray addObject:[userDefault objectForKey:@"nick_name"]];
            [ReComArray addObject:Remodel.comment_nick];
            [ReComArray addObject:self.CommentTextField.text];
            [Remodel.RecommentArray addObject:ReComArray];
        }
        
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
        [bquery whereKey:@"objectId" equalTo:Remodel.objectId];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *reobj = array.lastObject;
            [reobj setObject:Remodel.RecommentArray forKey:@"Recomment"];
            [reobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [HopeCommentModel LoadDataFromClassCommentWithGoodid:self.Hopemodel.objectId];
            }];
        }];
        self.CommentTextField.text = nil;
    }else{
        NSDate *date = [NSDate date];
        NSString *time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
        BmobObject *object = [BmobObject objectWithClassName:@"Comment"];
        [object setObject:time forKey:@"comment_time"];
        [object setObject:self.CommentTextField.text forKey:@"comment_description"];
        [object setObject:self.Hopemodel.objectId forKey:@"good_id"];
        [object setObject:self.Hopemodel.userName forKey:@"username"];
        [object setObject:[userDefault objectForKey:@"username"] forKey:@"comment_id"];
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                HopeCommentModel *model = [[HopeCommentModel alloc]initWithCommentId:[userDefault objectForKey:@"username"]  UserName:self.Hopemodel.userName GoodId:self.Hopemodel.objectId CommentDescription:self.CommentTextField.text CommentTime:time ObjectId:[object objectForKey:@"objectId"]RecommentArray:nil];
                model.comment_nick = [userDefault objectForKey:@"nick_name"];
                [self.CommentArray addObject:model];
                [HopeTableView reloadData];
                
                self.CommentTextField.text = nil;
            }
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark DidSelectDelegate
-(void)didSelectedWithUserName:(NSString *)username UserNick:(NSString *)userNick Row:(NSInteger)row
{
    
    Remodel = self.CommentArray[row];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [self.CommentTextField becomeFirstResponder];
    self.CommentTextField.placeholder = [NSString stringWithFormat:@"%@回复%@",[userdefault objectForKey:@"nick_name"],userNick];
    [userdefault setObject:@"1" forKey:@"Recomment"];
    [userdefault setObject:@"2" forKey:@"RECOMMENT"];
    [userdefault synchronize];
    
    self.ReNameID = username;
    self.ReNick = userNick;
    
}
-(void)dealloc
{
    returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
@end
