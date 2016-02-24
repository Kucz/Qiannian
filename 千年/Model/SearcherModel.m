//
//  SearcherModel.m
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import "SearcherModel.h"
@implementation SearcherModel

-(instancetype)initWithGoodtitle:(NSString *)goodtitle Goodprice:(NSString *)goodprice Goodprcenew:(NSString *)goodpricenew Gooddescription:(NSString *)gooddescription GoodImage:(NSString *)goodimage Goodstate:(NSString *)goodstate Goodclass:(NSString *)goodclass GoodUsername:(NSString *)username GoodTime:(NSString *)goodtime GoodBuy:(NSString *)goodbuy objectId:(NSString *)objectId goodrate:(NSString *)goodrate Nickname:(NSString *)nickname Headimage:(NSString *)headimage Age:(NSString *)age Sex:(NSString *)sex
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
        
        _nickname = nickname;
        _headimage = headimage;
        _age = age;
        _sex = sex;
    }
    return self;
}
+(void)loaddataFromGoodsWithClassName:(NSString *)classname
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
    [bquery orderByDescending:@"good_time"];
    [bquery whereKey:@"good_class" equalTo:classname];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SegueSearchArray" object:nil];
        }
        for(BmobObject *obj in array)
        {
            BmobQuery *UserObj = [BmobQuery queryWithClassName:@"Login"];
            [UserObj whereKey:@"username" equalTo:[obj objectForKey:@"username"]];
            [UserObj findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                BmobObject *UserObject = array.firstObject;
                SearcherModel *model = [[SearcherModel alloc]initWithGoodtitle:[obj objectForKey:@"good_name"] Goodprice:[obj objectForKey:@"good_price"] Goodprcenew:[obj objectForKey:@"good_pricenew"] Gooddescription:[obj objectForKey:@"good_description"] GoodImage:[obj objectForKey:@"good_image"] Goodstate:[obj objectForKey:@"good_state"] Goodclass:[obj objectForKey:@"good_class"] GoodUsername:[obj objectForKey:@"username"] GoodTime:[obj objectForKey:@"good_time"] GoodBuy:[obj objectForKey:@"good_buy"]objectId:[obj objectForKey:@"objectId"]goodrate:[obj objectForKey:@"good_rate"]Nickname:[UserObject objectForKey:@"nick_name"] Headimage:[UserObject objectForKey:@"head_url"] Age:[UserObject objectForKey:@"age"] Sex:[UserObject objectForKey:@"sex"]];
                [dataArray addObject:model];
                if(dataArray.count==ArrayCount)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchArray" object:dataArray];
                }
            }];
        }
    }];
}


+(void)loaddataFromGoodsWithUserName:(NSString *)username
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
    [bquery orderByDescending:@"good_time"];
    [bquery whereKey:@"username" equalTo:username];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PerSearchArray" object:nil];
        }
        for(BmobObject *obj in array)
        {
            BmobQuery *UserObj = [BmobQuery queryWithClassName:@"Login"];
            [UserObj whereKey:@"username" equalTo:[obj objectForKey:@"username"]];
            [UserObj findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                BmobObject *UserObject = array.firstObject;
                SearcherModel *model = [[SearcherModel alloc]initWithGoodtitle:[obj objectForKey:@"good_name"] Goodprice:[obj objectForKey:@"good_price"] Goodprcenew:[obj objectForKey:@"good_pricenew"] Gooddescription:[obj objectForKey:@"good_description"] GoodImage:[obj objectForKey:@"good_image"] Goodstate:[obj objectForKey:@"good_state"] Goodclass:[obj objectForKey:@"good_class"] GoodUsername:[obj objectForKey:@"username"] GoodTime:[obj objectForKey:@"good_time"] GoodBuy:[obj objectForKey:@"good_buy"]objectId:[obj objectForKey:@"objectId"]goodrate:[obj objectForKey:@"good_rate"]Nickname:[UserObject objectForKey:@"nick_name"] Headimage:[UserObject objectForKey:@"head_url"] Age:[UserObject objectForKey:@"age"] Sex:[UserObject objectForKey:@"sex"]];
                [dataArray addObject:model];
                if(dataArray.count==ArrayCount)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"PerSearchArray" object:dataArray];
                }
            }];
        }
    }];
}

+(void)loaddataFromGoodsWithGoodDescription:(NSString *)gooddescription
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
    [bquery orderByDescending:@"good_time"];
//    [bquery whereKey:@"good_description" equalTo:gooddescription];
    [bquery whereKey:@"good_description" matchesWithRegex:gooddescription];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        if(array.count==0)
        {
               [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchArray" object:nil];
        }
        for(BmobObject *obj in array)
        {
            BmobQuery *UserObj = [BmobQuery queryWithClassName:@"Login"];
            [UserObj whereKey:@"username" equalTo:[obj objectForKey:@"username"]];
            [UserObj findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                BmobObject *UserObject = array.firstObject;
                SearcherModel *model = [[SearcherModel alloc]initWithGoodtitle:[obj objectForKey:@"good_name"] Goodprice:[obj objectForKey:@"good_price"] Goodprcenew:[obj objectForKey:@"good_pricenew"] Gooddescription:[obj objectForKey:@"good_description"] GoodImage:[obj objectForKey:@"good_image"] Goodstate:[obj objectForKey:@"good_state"] Goodclass:[obj objectForKey:@"good_class"] GoodUsername:[obj objectForKey:@"username"] GoodTime:[obj objectForKey:@"good_time"] GoodBuy:[obj objectForKey:@"good_buy"]objectId:[obj objectForKey:@"objectId"]goodrate:[obj objectForKey:@"good_rate"]Nickname:[UserObject objectForKey:@"nick_name"] Headimage:[UserObject objectForKey:@"head_url"] Age:[UserObject objectForKey:@"age"] Sex:[UserObject objectForKey:@"sex"]];
                [dataArray addObject:model];
                if(dataArray.count==ArrayCount)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchArray" object:dataArray];
                }
                
                
            }];
        }
    }];
}

+(void)loaddateFromCollectWithUsername:(NSString *)username
{
   __block int i = 0;
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"username" equalTo:username];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BuySearchArray" object:nil];
        }else{
            
            for(BmobObject *collectObject in array)//遍历Collect
            {
                if([collectObject objectForKey:@"Buyed_id"]!=nil)
                {
                    NSLog(@"%@",[collectObject objectForKey:@"Buyed_id"]);
                    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods"];
                    [bquery whereKey:@"objectId" equalTo:[collectObject objectForKey:@"Buyed_id"]];
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        BmobObject *Uobj = array.lastObject;

                        
                        BmobQuery *UserObj = [BmobQuery queryWithClassName:@"Login"];
                        [UserObj whereKey:@"username" equalTo:[Uobj objectForKey:@"username"]];
                        [UserObj findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            
                            
                            BmobObject *UserObject = array.firstObject;
                            SearcherModel *model = [[SearcherModel alloc]initWithGoodtitle:[Uobj objectForKey:@"good_name"] Goodprice:[Uobj objectForKey:@"good_price"] Goodprcenew:[Uobj objectForKey:@"good_pricenew"] Gooddescription:[Uobj objectForKey:@"good_description"] GoodImage:[Uobj objectForKey:@"good_image"] Goodstate:[Uobj objectForKey:@"good_state"] Goodclass:[Uobj objectForKey:@"good_class"] GoodUsername:[Uobj objectForKey:@"username"] GoodTime:[Uobj objectForKey:@"good_time"] GoodBuy:[Uobj objectForKey:@"good_buy"]objectId:[Uobj objectForKey:@"objectId"]goodrate:[Uobj objectForKey:@"good_rate"]Nickname:[UserObject objectForKey:@"nick_name"] Headimage:[UserObject objectForKey:@"head_url"] Age:[UserObject objectForKey:@"age"] Sex:[UserObject objectForKey:@"sex"]];
                            
                            
                              [dataArray addObject:model];
                            if(![[collectObject objectForKey:@"Buyed_id"]isEqualToString:@""])
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"BuySearchArray" object:dataArray];
                            }
                        }];
                        
                        
                        
                    }];
                }else{
                    i++;
                }
            }
            if(i!=0)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"BuySearchArray" object:nil];
            }
            
        }
    }];
}
@end
