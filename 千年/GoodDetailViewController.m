//
//  GoodDetailViewController.m
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "BuyViewController.h"
#import "UIView+Toast.h"
#import "DetailCommentModel.h"
#import "DetailTableViewCell.h"
#import "PersonDetailViewController.h"
@interface GoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate,DidSelectedDelegate>
{
    NSString *username;
    NSString *nickname;
    NSString *headImage;
    NSString *age;
    NSString *sex;
    
    NSString *objectId;
    NSString *goodtitle;
    NSString *goodprice;
    NSString *goodpricenew;
    NSString *gooddescription;
    NSString *goodimage;
    NSString *goodstate;
    NSString *goodclass;
    NSString *good_username;
    NSString *goodtime;
    NSString *goodbuy;
    NSString *goodrate;

    UITableView *Detailtableview;
    UIScrollView *GoodScrollView;
    
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@property (weak, nonatomic) IBOutlet UIButton *collection_button;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) NSMutableArray *CommentArray;
- (IBAction)BuyAction:(id)sender;
- (IBAction)collect_action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
- (IBAction)CommentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *ButtomView;

@property (weak, nonatomic) IBOutlet UILabel *GoodrateLabel;

@end

@implementation GoodDetailViewController
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
    
    self.navigationController.navigationBar.hidden = NO;
    
    UIImage *image  = [UIImage imageNamed:@"GoodDeatil_Bg"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationController.navigationBar.hidden = NO;
    GoodScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, winWidth, winHeight-44-64)];
    [self.view addSubview:GoodScrollView];
    //Scrollview背景色
    GoodScrollView.backgroundColor =  [UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:1.0];
    
    [super viewDidLoad];
    [self SetUpView]; //留言创建

     [self UpdateUIVIEW];//赋值
    self.ButtomView.layer.borderWidth = 1;
    self.ButtomView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [DetailCommentModel loadFromGoodCommentWithGoodID:objectId];//加载留言
    //留言监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UpdateTableview:) name:@"GoodDetail" object:nil];
//键盘适配
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    //判断用户是否收藏过此商品
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"good_id" equalTo:objectId];
    [bquery whereKey:@"username" equalTo:[userdefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==1)
        {
            self.collectButton.selected = YES;
        }else{
            self.collectButton.selected = NO;
        }
    }];
    
    

}
-(void)UpdateTableview:(NSNotification *)notification
{
    self.CommentArray = notification.object;
    [Detailtableview reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CommentArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"12300"];
    if(cell == nil)
    {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12300"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.delegate = self;
    }
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    DetailCommentModel *model = self.CommentArray[indexPath.row];
    model.Row = indexPath.row;
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentModel *model = self.CommentArray[indexPath.row];
    return model.height;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"评论%li",self.CommentArray.count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCommentModel *ReGoodComment = self.CommentArray[indexPath.row];
    NSUserDefaults *userDefasult = [NSUserDefaults standardUserDefaults];
    [userDefasult setObject:@"1" forKey:@"ReGoodComment"];
    [userDefasult synchronize];
    self.ROW = indexPath.row;
    NSString *LoginUser = [userDefasult objectForKey:@"nick_name"];
    
    UIView *textView = [self.view viewWithTag:100];
    [UIView animateWithDuration:0.1 animations:^{
        textView.transform = CGAffineTransformMakeTranslation(0, -49);
    }];
    UITextField *textField = [self.view viewWithTag:101];
    textField.placeholder = [NSString stringWithFormat:@"%@回复%@",LoginUser,ReGoodComment.commentNick];
}


-(void)SetScrollView
{
    //商品图片
    UIImageView *GoodImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, winWidth, winWidth)];
    [GoodImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",goodimage,Base_url]]];
    [GoodScrollView addSubview:GoodImage];
    
    //头像
    UIButton *HeadImage = [[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(GoodImage.frame)+5, 30, 30)];
    HeadImage.layer.cornerRadius = 15;
    HeadImage.layer.masksToBounds = YES;
//    [HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headImage,Base_url]] forState:UIControlStateNormal ];
//    [HeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headImage,Base_url]] forState:forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headImage"]];
    
    [HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headImage,Base_url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Headimage"]];
    
    [HeadImage addTarget:self action:@selector(ChoseHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    [GoodScrollView addSubview:HeadImage];
    //昵称
    UILabel *nickNameLabel = [[UILabel alloc]init];
    nickNameLabel.text = nickname;
    CGSize Nickname_size = [nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [nickNameLabel setFrame:CGRectMake(CGRectGetMaxX(HeadImage.frame)+10, CGRectGetMaxY(GoodImage.frame)+5, Nickname_size.width, Nickname_size.height)];
    [GoodScrollView addSubview:nickNameLabel];
    //价格
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.text = [NSString stringWithFormat:@"¥:%@",goodprice];
    CGSize price_size = [priceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [priceLabel setFrame:CGRectMake(winWidth-price_size.width-10,  CGRectGetMaxY(GoodImage.frame)+5, price_size.width, price_size.height)];
    [priceLabel setTextColor:[UIColor redColor]];
    [GoodScrollView addSubview:priceLabel];
    //标题
    UILabel *titlelabel= [[UILabel alloc]init];
    titlelabel.text = goodtitle;
    CGSize title_size = [titlelabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [titlelabel setFrame:CGRectMake(CGRectGetMinX(nickNameLabel.frame), CGRectGetMaxY(nickNameLabel.frame)+5, title_size.width, title_size.height)];
    [titlelabel setTextColor:[UIColor redColor]];
    [GoodScrollView addSubview:titlelabel];
    //分割线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame)+10, winWidth, 1)];
    [view setBackgroundColor:[UIColor redColor]];
    [GoodScrollView addSubview:view];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = [NSString timeWithString:goodtime];
    CGSize time_size = [timeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [timeLabel setFrame:CGRectMake(winWidth-time_size.width-5, CGRectGetMaxY(view.frame)+5, time_size.width, time_size.height)];
    [GoodScrollView addSubview:timeLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc]init];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = gooddescription;
    CGFloat desc_W = winWidth-time_size.width-10;
    CGSize desc_size = [descriptionLabel.text boundingRectWithSize:CGSizeMake(desc_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    [descriptionLabel setFrame:CGRectMake(5, CGRectGetMinY(timeLabel.frame), desc_size.width, desc_size.height)];
    [GoodScrollView addSubview:descriptionLabel];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(descriptionLabel.frame)+10, winWidth, 1)];
    secondView.backgroundColor = [UIColor redColor];
    [ GoodScrollView addSubview:secondView];

    Detailtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(secondView.frame), winWidth, 200) style:UITableViewStylePlain];
    Detailtableview.dataSource = self;
    Detailtableview.delegate = self;
    Detailtableview.tableFooterView = [UIView new];
    //Tableview背景色
    [Detailtableview setBackgroundColor:[UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:1.0]];
    
    [GoodScrollView addSubview:Detailtableview];
    [GoodScrollView setContentSize:CGSizeMake(winWidth, CGRectGetMaxY(secondView.frame)+200)];
}

-(void)ChoseHeadImage:(UIButton *)sender
{
    PersonDetailViewController *personVC = [[PersonDetailViewController alloc] init];
    personVC.UserNAME = good_username;
    [self.navigationController pushViewController:personVC animated:YES];
    
}


-(void)UpdateUIVIEW
{
    if(self.model!=nil)
    {
        username = self.model.username;
        nickname = self.model.nickname;
        headImage = self.model.headimage;
        age = self.model.age;
        sex = self.model.sex;
        objectId = self.model.objectId;
        goodtitle = self.model.goodtitle;
        goodprice = self.model.goodprice;
        goodpricenew = self.model.goodpricenew;
        gooddescription = self.model.gooddescription;
        goodimage = self.model.goodimage;
        goodstate = self.model.goodstate;
        goodclass = self.model.goodclass;
        good_username = self.model.good_username;
        goodtime = self.model.goodtime;
        goodbuy = self.model.goodbuy;
        goodrate = self.model.goodrate;
        if([goodrate intValue]!=0)
        {
            self.GoodrateLabel.text = self.model.goodrate;
        }else
        {
            self.GoodrateLabel.text = @"0";
        }
    }else if(self.searchModel!=nil)
    {
        username = self.searchModel.username;
        nickname = self.searchModel.nickname;
        headImage = self.searchModel.headimage;
        age = self.searchModel.age;
        sex = self.searchModel.sex;
        objectId = self.searchModel.objectId;
        goodtitle = self.searchModel.goodtitle;
        goodprice = self.searchModel.goodprice;
        goodpricenew = self.searchModel.goodpricenew;
        gooddescription = self.searchModel.gooddescription;
        goodimage = self.searchModel.goodimage;
        goodstate = self.searchModel.goodstate;
        goodclass = self.searchModel.goodclass;
        good_username = self.searchModel.good_username;
        goodtime = self.searchModel.goodtime;
        goodbuy = self.searchModel.goodbuy;
        goodrate = self.searchModel.goodrate;

        if([goodrate intValue]!=0)
        {
            self.GoodrateLabel.text = self.model.goodrate;
        }else
        {
            self.GoodrateLabel.text = @"0";
        }
    }
    [self SetScrollView];
    self.isCollect = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[BuyViewController class]]&&[segue.identifier isEqualToString:@"buySegue"])
    {
        BuyViewController *buyVC = (BuyViewController *)segue.destinationViewController;
        if(self.model!=nil)
        {
            buyVC.goodModel = self.model;
        }else if(self.searchModel!=nil)
        {
            buyVC.searchModel = self.searchModel;
        }
    }
}
- (IBAction)BuyAction:(id)sender {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:@"buySegue" sender:Nil];
    }else{
        [self.view makeToast:@"请先登录" duration:2.0 position:@"CSToastPositionCenter"];
    }
    
    
//    self prepareForSegue:<#(nonnull UIStoryboardSegue *)#> sender:<#(nullable id)#>
    
}

- (IBAction)collect_action:(id)sender {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"good_id" equalTo:objectId];
    [bquery whereKey:@"username" equalTo:[userdefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       if(array.count==1)
       {
           [self deteleCollection];
           self.collectButton.selected = NO;
       }else{
           [self saveCollection];
           self.collectButton.selected = YES;
       }
    }];
}
//保存收藏记录到服务器
-(void)saveCollection
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BOOL ishave = NO;
        for(BmobObject *obj in array)
        {
            if([[obj objectForKey:@"good_id"]isEqualToString:objectId])
            {
                ishave = YES;
            }
        }
        if(!ishave){
            BmobObject *collect  = [BmobObject objectWithClassName:@"Collect"];
            [collect setObject:[userDefault objectForKey:@"username"] forKey:@"username"];
            [collect setObject:objectId forKey:@"good_id"];
            
            [collect saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    goodrate = [NSString stringWithFormat:@"%i",[goodrate intValue]+1];
                    [self updateModel];
                    self.GoodrateLabel.text = goodrate;
                   [self UpdateGoods];
                }
            }];
        }
    }];
}
//更新商品的收藏数量
-(void)UpdateGoods
{
    BmobQuery *goodquery = [BmobQuery queryWithClassName:@"Goods"];
    [goodquery whereKey:@"objectId" equalTo:objectId];
    [goodquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *goodObject = array.firstObject;
        [goodObject setObject:goodrate forKey:@"good_rate"];
        [goodObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        }];
    }];
}
//删除收藏记录到服务器
-(void)deteleCollection
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *obj in array)
        {
            if([[obj objectForKey:@"good_id"]isEqualToString:objectId])
            {
                [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    goodrate = [NSString stringWithFormat:@"%i",[goodrate intValue]-1];
                    [self updateModel];
                    if([goodrate intValue]<=0)
                    {
                        self.GoodrateLabel.text = @"0";
                    }else{
                        self.GoodrateLabel.text = goodrate;
                    }
                    [self UpdateGoods];
                }];
            }
        }
    }];
}
-(void)updateModel
{
    if(self.model!=nil)
    {
        self.model.goodrate = goodrate;
    }else{
        self.searchModel.goodrate = goodrate;
    }
}
-(void)SetUpView
{
    UIView *TextView = [[UIView alloc]initWithFrame:CGRectMake(0, winHeight, winWidth, 49)];
    UITextField *CommentTextfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 7, winWidth-60, 35)];
    UIButton *SureButton = [[UIButton alloc]initWithFrame:CGRectMake(winWidth-50, 7, 40, 35)];
    TextView.backgroundColor = [UIColor whiteColor];
    TextView.tag = 100;
    CommentTextfield.tag = 101;
    CommentTextfield.layer.cornerRadius = 8.0;
    CommentTextfield.layer.borderWidth = 1;
    CommentTextfield.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [SureButton setTitle:@"留言" forState:UIControlStateNormal];
    [SureButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [SureButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [SureButton addTarget:self action:@selector(CommentAction) forControlEvents:UIControlEventTouchUpInside];
    [CommentTextfield setPlaceholder:@"请输入留言"];
    [TextView addSubview:SureButton];
    [TextView addSubview:CommentTextfield];
    [self.view addSubview:TextView];
}
//保存留言
-(void)CommentAction
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [self.view endEditing:YES];
    UIView *textView = [self.view viewWithTag:100];
    textView.transform = CGAffineTransformIdentity;
    UITextField *textField = [self.view viewWithTag:101];
    
    
    if([textField.text isEqualToString:@""])
    {
        [self.view makeToast:@"留言内容为空" duration:2.0 position:@"CSToastPositionCenter"];
        return;
    }
    
    if([[userDefault objectForKey:@"ReGoodComment"]isEqualToString:@"1"])
    {
        DetailCommentModel *model = self.CommentArray[self.ROW];

        [userDefault removeObjectForKey:@"ReGoodComment"];
        [userDefault synchronize];
        if([[userDefault objectForKey:@"REGOODCOMMENT"]isEqualToString:@"2"])
        {
            [userDefault removeObjectForKey:@"REGOODCOMMENT"];
            [userDefault synchronize];
            NSMutableArray *REGoodArray = [NSMutableArray array];
            [REGoodArray addObject:[userDefault objectForKey:@"username"]];
            [REGoodArray addObject:self.USERNAME];
            [REGoodArray addObject:[userDefault objectForKey:@"nick_name"]];
            [REGoodArray addObject:self.USERNICK];
            [REGoodArray addObject:textField.text];
            [model.ReGoodCommentArray addObject:REGoodArray];
        }else{
            NSMutableArray *REGoodArray = [NSMutableArray array];
            [REGoodArray addObject:[userDefault objectForKey:@"username"]];
            [REGoodArray addObject:model.commentId];
            [REGoodArray addObject:[userDefault objectForKey:@"nick_name"]];
            [REGoodArray addObject:model.commentNick];
            [REGoodArray addObject:textField.text];
            [model.ReGoodCommentArray addObject:REGoodArray];
        }
        BmobQuery *bquery  = [BmobQuery queryWithClassName:@"GoodComment"];
        [bquery whereKey:@"objectId" equalTo:model.objectId];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *bObject = array.lastObject;
            [bObject setObject:model.ReGoodCommentArray forKey:@"ReGoodComment"];
            [bObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful)
                {
                    [DetailCommentModel loadFromGoodCommentWithGoodID:model.goodId];
                    textField.text = @"";
                    textField.placeholder=@"";
                }
            }];
        }];
    }else{
        BmobObject *GoodObject = [BmobObject objectWithClassName:@"GoodComment"];
        [GoodObject setObject:textField.text forKey:@"comment_description"];
        [GoodObject setObject:[userDefault objectForKey:@"username"] forKey:@"comment_id"];
        [GoodObject setObject:username forKey:@"username"];
        [GoodObject setObject:objectId forKey:@"good_id"];
        NSDate *date = [NSDate date];
        NSString *time = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
        [GoodObject setObject:time forKey:@"comment_time"];
        [GoodObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if(isSuccessful)
            {
                DetailCommentModel *model = [[DetailCommentModel alloc]init];
                model.commenttime = time;
                model.commentdescription = textField.text;
                model.commentId = [userDefault objectForKey:@"username"];
                model.commentNick = [userDefault objectForKey:@"nick_name"];
                model.commentImageUrl = [userDefault objectForKey:@"head_url"];
                [DetailCommentModel loadFromGoodCommentWithGoodID:objectId];
                textField.text = @"";
            }
        }];
    }
}
//留言 点击事件
- (IBAction)CommentAction:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"Login"]intValue]==1)
    {
        UIView *textView = [self.view viewWithTag:100];
        [UIView animateWithDuration:0.1 animations:^{
            textView.transform = CGAffineTransformMakeTranslation(0, -49);
        }];
    }else{
        [self.view makeToast:@"请先登陆" duration:2.0 position:@"CSToastPositionCenter"];
    }
}
//通过点击昵称回复
-(void)didSelectedWithUsername:(NSString *)username1 UserBick:(NSString *)userNick Row:(NSInteger)row
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"1" forKey:@"ReGoodComment"];
    [userDefault setObject:@"2" forKey:@"REGOODCOMMENT"];
    [userDefault synchronize];
    
    UIView *textView = [self.view viewWithTag:100];
    [UIView animateWithDuration:0.1 animations:^{
        textView.transform = CGAffineTransformMakeTranslation(0, -49);
    }];
    UITextField *textField = [self.view viewWithTag:101];
    [textField becomeFirstResponder];
    textField.placeholder = [NSString stringWithFormat:@"%@回复%@",[userDefault objectForKey:@"nick_name"],userNick];
    self.USERNAME = username1;
    self.USERNICK = userNick;
    self.ROW = row;
}

-(void)dealloc
{
    returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}

@end
