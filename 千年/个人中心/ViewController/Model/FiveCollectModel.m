//
//  FiveCollectModel.m
//  千年
//
//  Created by God on 16/1/7.
//  Copyright © 2016年 God. All rights reserved.
//

#import "FiveCollectModel.h"
#import "SearcherModel.h"
@implementation FiveCollectModel

//http://newfile.codenow.cn:8080/030F5B564E8344829CE70017F209316D.jpg

//http://newfile.codenow.cn:8080/18B93674633F46A987E79EC7D3B0BF59.jpg

+(void)loadDataFromTable:(NSString *)table objectKey:(NSString *)KEY
{
    __block int i = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collect"];
    [bquery whereKey:@"username" equalTo:[userDefault objectForKey:@"username"]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count==0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FiveCollect" object:nil];
        }
        for(BmobObject *obj in array)
        {
             i++;
            BmobQuery *Goodquery = [BmobQuery queryWithClassName:table];
            [Goodquery getObjectInBackgroundWithId:[obj objectForKey:KEY] block:^(BmobObject *object, NSError *error) {
                if(!error)
                {
                    SearcherModel *model = [[SearcherModel alloc]initWithGoodtitle:[object objectForKey:@"good_name"] Goodprice:[object objectForKey:@"good_price"] Goodprcenew:[object objectForKey:@"good_pricenew"] Gooddescription:[object objectForKey:@"good_description"] GoodImage:[object objectForKey:@"good_image"] Goodstate:[object objectForKey:@"good_state"] Goodclass:[object objectForKey:@"good_class"] GoodUsername:[object objectForKey:@"username"] GoodTime:[object objectForKey:@"good_time"] GoodBuy:[object objectForKey:@"good_buy"]objectId:[object objectForKey:@"objectId"]goodrate:[object objectForKey:@"good_rate"]Nickname:nil Headimage:nil Age:nil Sex:nil];
                    [dataArray addObject:model];
                }else{
                    NSLog(@"%@",error);
                }
                if(i==array.count)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FiveCollect" object:dataArray];
                }
            }];
        }
    }];
    
}




//-(GoodslistModel *)LoaddataFormGoodsWithObjectId:(NSString *)objectId
//{
//    
//}


@end
