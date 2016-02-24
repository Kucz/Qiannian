//
//  GoodslistModel.m
//  千年
//
//  Created by God on 16/1/4.
//  Copyright © 2016年 God. All rights reserved.
//

#import "GoodslistModel.h"

@implementation GoodslistModel
//@property (nonatomic,copy) NSString *username;
//@property (nonatomic,copy) NSString *nickname;
//@property (nonatomic,copy) NSString *headimage;
//@property (nonatomic,copy) NSString *age;
//@property (nonatomic,copy) NSString *sex;

-(instancetype)initWithGoodtitle:(NSString *)goodtitle Goodprice:(NSString *)goodprice Goodprcenew:(NSString *)goodpricenew Gooddescription:(NSString *)gooddescription GoodImage:(NSString *)goodimage Goodstate:(NSString *)goodstate Goodclass:(NSString *)goodclass GoodUsername:(NSString *)username GoodTime:(NSString *)goodtime GoodBuy:(NSString *)goodbuy GoodRate:(NSString *)goodrate objectId:(NSString *)objectId Nickname:(NSString *)nickname Headimage:(NSString *)headimage Age:(NSString *)age Sex:(NSString *)sex userName:(NSString *)userName;
{
    if(self = [super init])
    {
        _objectId = objectId;
        _goodtitle = goodtitle;
        _goodprice = goodprice;
        _goodpricenew = goodpricenew;
        _gooddescription = gooddescription;
        _goodimage = goodimage;
        _goodstate = goodstate;
        _goodclass = goodclass;
        _good_username = username;
        _goodtime = goodtime;
        _goodbuy = goodbuy;
        _goodrate = goodrate;
        
        _username = userName;
        _nickname = nickname;
        _headimage = headimage;
        _age = age;
        _sex = sex;
    }
    return self;
}




+(void)loaddataFromGoods:(int)i
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
     [bquery orderByDescending:@"good_time"];
    [bquery whereKey:@"good_buy" equalTo:@"1"];
    bquery.limit = 10;
    bquery.skip = 10*i;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GoodList" object:nil];
        }
        for(BmobObject *obj in array)
        {
            BmobQuery *userQuery = [BmobQuery queryWithClassName:@"Login"];
            [userQuery whereKey:@"username" equalTo:[obj objectForKey:@"username"]];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                BmobObject *userObj = array.firstObject;
                GoodslistModel *model = [[GoodslistModel alloc]initWithGoodtitle:[obj objectForKey:@"good_name"] Goodprice:[obj objectForKey:@"good_price"] Goodprcenew:[obj objectForKey:@"good_pricenew"] Gooddescription:[obj objectForKey:@"good_description"] GoodImage:[obj objectForKey:@"good_image"] Goodstate:[obj objectForKey:@"good_state"] Goodclass:[obj objectForKey:@"good_class"] GoodUsername:[obj objectForKey:@"username"] GoodTime:[obj objectForKey:@"good_time"] GoodBuy:[obj objectForKey:@"good_buy"] GoodRate:[obj objectForKey:@"good_rate"]objectId:[obj objectForKey:@"objectId"]Nickname:[userObj objectForKey:@"nick_name"] Headimage:[userObj objectForKey:@"head_url"] Age:[userObj objectForKey:@"age"] Sex:[userObj objectForKey:@"sex"]userName:[userObj objectForKey:@"username"]];
                [dataArray addObject:model];
                if(dataArray.count==ArrayCount)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"GoodList" object:dataArray];
                }
            }];
        }
    }];
}
@end
