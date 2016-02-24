//
//  WantedByModel.m
//  千年
//
//  Created by God on 15/12/30.
//  Copyright © 2015年 God. All rights reserved.
//

#import "WantedByModel.h"

@implementation WantedByModel
-(instancetype)initWithImageurl:(NSString *)imageurl andTitle:(NSString *)title andPrice:(NSString *)price andTime:(NSString *)time andDescription:(NSString *)descriptio andName:(NSString *)name andObjectId:(NSString *)objectId userName:(NSString *)username
{
    if(self=[super init])
    {
        _name = name;
        _Time = time;
        _Title =title;
        _Price = price;
        _ImageUrl = imageurl;
        _Description = descriptio;
        _objectId = objectId;
        _userName = username;
        _height = 0;
    }
    return self;
}
+(void)GetdataFormBmobWith:(int)i
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataArray = [NSMutableArray array];
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"WantedBuy"];
    [bquery orderByDescending:@"createdAt"];
    bquery.limit = 10;
    bquery.skip = 10*i;
    if([[userDefault objectForKey:@"Getmywanted"]isEqualToString:@"1"])
    {
        [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    }
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            int i = (int)array.count;
            if(array.count==0)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wantedbuy" object:dataArray];
            }
            for(BmobObject *wantObject in array)
            {
                BmobQuery *query = [BmobQuery queryWithClassName:@"Login"];
                [query whereKey:@"username" equalTo:[wantObject objectForKey:@"username"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    BmobObject *obj = array.lastObject;
                    WantedByModel *model = [[WantedByModel alloc]initWithImageurl:[obj objectForKey:@"head_url"] andTitle:[wantObject objectForKey:@"wanted_title"] andPrice:[wantObject objectForKey:@"wanted_price"] andTime:[wantObject objectForKey:@"wanted_time"] andDescription:[wantObject objectForKey:@"wanted_description"] andName:[obj objectForKey:@"nick_name"]andObjectId:[wantObject objectForKey:@"objectId"]userName:[wantObject objectForKey:@"username"]];
                    [dataArray addObject:model];
                    if(dataArray.count==i)
                    {     
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"wantedbuy" object:dataArray];
                    }
                }];
            }
        }];
}

+(void)GetdataFormUsername:(NSString *)username
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WantedBuy"];
    [bquery orderByDescending:@"createdAt"];
    [bquery whereKey:@"username" equalTo:username];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        int i = (int)array.count;
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Perwantedbuy" object:nil];
        }
        for(BmobObject *wantObject in array)
        {
            BmobQuery *query = [BmobQuery queryWithClassName:@"Login"];
            [query whereKey:@"username" equalTo:[wantObject objectForKey:@"username"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                BmobObject *obj = array.lastObject;
                WantedByModel *model = [[WantedByModel alloc]initWithImageurl:[obj objectForKey:@"head_url"] andTitle:[wantObject objectForKey:@"wanted_title"] andPrice:[wantObject objectForKey:@"wanted_price"] andTime:[wantObject objectForKey:@"wanted_time"] andDescription:[wantObject objectForKey:@"wanted_description"] andName:[obj objectForKey:@"nick_name"]andObjectId:[wantObject objectForKey:@"objectId"]userName:[wantObject objectForKey:@"username"]];
                [dataArray addObject:model];
                if(dataArray.count==i)
                {
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"Perwantedbuy" object:dataArray];
                }
            }];
        }
    }];
}

@end
