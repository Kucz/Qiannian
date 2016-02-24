//
//  AddressModel.m
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

//@property (nonatomic,copy) NSString *addresstime;
//@property (nonatomic,copy) NSString *addresscity;
//@property (nonatomic,copy) NSString *addressstreet;
//@property (nonatomic,copy) NSString *addressperson;
//@property (nonatomic,copy) NSString *addressphone;

-(instancetype)initWithAddresstime:(NSString *)addresstime Addresscity:(NSString *)addresscity Addressstreet:(NSString *)addressstreet Addressperson:(NSString *)addressperson Addressphone:(NSString *)addressphone objectId:(NSString *)objectId
{
    if(self=[super init])
    {
        _addresstime = addresstime;
        _addresscity = addresscity;
        _addressstreet = addressstreet;
        _addressperson = addressperson;
        _addressphone = addressphone;
        _objectId = objectId;
//        _height = 0;
    }
    return self;
}



+(void)loadAddressFromAddress
{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Address"];
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Address" object:nil];
        }
        for(BmobObject *obj in array)
        {
            AddressModel *model = [[AddressModel alloc]initWithAddresstime:[obj objectForKey:@"address_time"] Addresscity:[obj objectForKey:@"address_city"] Addressstreet:[obj objectForKey:@"address_street"] Addressperson:[obj objectForKey:@"address_person"] Addressphone:[obj objectForKey:@"address_phone"]objectId:[obj objectForKey:@"objectId"]];
            [dataArray addObject:model];
            
            if(dataArray.count==array.count)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Address" object:dataArray];
            }
        }
    }];
    
}
@end
