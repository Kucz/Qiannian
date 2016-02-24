//
//  WantedByModel.h
//  千年
//
//  Created by God on 15/12/30.
//  Copyright © 2015年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WantedByModel : NSObject
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ImageUrl;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Price;
@property (nonatomic,copy) NSString *Time;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) NSString *objectId;
//@property (weak, nonatomic) IBOutlet UIButton *Head_image;
//@property (weak, nonatomic) IBOutlet UILabel *Wanted_title;
//@property (weak, nonatomic) IBOutlet UILabel *Wanted_price;
//
+(void)GetdataFormBmobWith:(int)i;
+(void)GetdataFormUsername:(NSString *)username;
//@property (weak, nonatomic) IBOutlet UILabel *Wanted_time;

-(instancetype)initWithImageurl:(NSString *)imageurl andTitle:(NSString *)title andPrice:(NSString *)price andTime:(NSString *)time andDescription:(NSString *)descriptio andName:(NSString *)name andObjectId:(NSString *)objectId userName:(NSString *)username;
@end
