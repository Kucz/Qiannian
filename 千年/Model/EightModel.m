//
//  EightModel.m
//  千年
//
//  Created by God on 16/1/3.
//  Copyright © 2016年 God. All rights reserved.
//

#import "EightModel.h"

@implementation EightModel
-(instancetype)initWithClassname:(NSString *)classname andClassImage:(NSString *)classimage
{
    if(self = [super init])
    {
        _class_name = classname;
        _class_image = classimage;
    }
    return self;
}
+(void)Getdata
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Goods_class"];
    [bquery orderByAscending:@"createdAt"];
//    __block int i = 0;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *obj in array)
        {
//            i++;
            EightModel *model = [[EightModel alloc]initWithClassname:[obj objectForKey:@"class_name"] andClassImage:[obj objectForKey:@"class_image"]];
            [dataArray addObject:model];
            if(dataArray.count==array.count)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"eight" object:dataArray];
            }
        }
    }];
}
@end
