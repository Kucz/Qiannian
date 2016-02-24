//
//  GoodslistModel.h
//  千年
//
//  Created by God on 16/1/4.
//  Copyright © 2016年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodslistModel : NSObject
//Login
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *headimage;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *sex;
//Goods
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *goodtitle;
@property (nonatomic,copy) NSString *goodprice;
@property (nonatomic,copy) NSString *goodpricenew;
@property (nonatomic,copy) NSString *gooddescription;
@property (nonatomic,copy) NSString *goodimage;
@property (nonatomic,copy) NSString *goodstate;
@property (nonatomic,copy) NSString *goodclass;
@property (nonatomic,copy) NSString *good_username;
@property (nonatomic,copy) NSString *goodtime;
@property (nonatomic,copy) NSString *goodbuy;
@property (nonatomic,copy) NSString *goodrate;

+(void)loaddataFromGoods:(int)i;
//+(GoodslistModel *)LoaddataFormGoodsWithObjectId:(NSString *)objectId;
//-(instancetype)initWithGoodtitle:(NSString *)goodtitle Goodprice:(NSString *)goodprice Goodprcenew:(NSString *)goodpricenew Gooddescription:(NSString *)gooddescription GoodImage:(NSString *)goodimage Goodstate:(NSString *)goodstate Goodclass:(NSString *)goodclass GoodUsername:(NSString *)username GoodTime:(NSString *)goodtime GoodBuy:(NSString *)goodbuy GoodRate:(NSString *)goodrate objectId:(NSString *)objectId;
-(instancetype)initWithGoodtitle:(NSString *)goodtitle Goodprice:(NSString *)goodprice Goodprcenew:(NSString *)goodpricenew Gooddescription:(NSString *)gooddescription GoodImage:(NSString *)goodimage Goodstate:(NSString *)goodstate Goodclass:(NSString *)goodclass GoodUsername:(NSString *)username GoodTime:(NSString *)goodtime GoodBuy:(NSString *)goodbuy GoodRate:(NSString *)goodrate objectId:(NSString *)objectId Nickname:(NSString *)nickname Headimage:(NSString *)headimage Age:(NSString *)age Sex:(NSString *)sex userName:(NSString *)username;
@end
