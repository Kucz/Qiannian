//
//  UserInformation.m
//  千年
//
//  Created by God on 16/1/6.
//  Copyright © 2016年 God. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

-(instancetype)initWithUsername:(NSString *)username password:(NSString *)password nickName:(NSString *)nickname age:(NSString *)age sex:(NSString *)sex headUrl:(NSString *)headurl createdAt:(NSString *)createdAt Earn:(NSString *)earn Expense:(NSString *)expense
{
    if(self = [super init])
    {
        _username = username;
        _password = password;
        _nickname = nickname;
        _age = age;
        _sex = sex;
        _headUrl = headurl;
        _createdAt = createdAt;
        _earn = earn;
        _expense = expense;
    }
    return self;
}
+(void)loaduserinformationFromLoginWithUsername:(NSString *)username
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Login"];
    [bquery whereKey:@"username" equalTo:username];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = array.firstObject;
        UserInformation *information = [[UserInformation alloc]initWithUsername:[obj objectForKey:@"username"] password:[obj objectForKey:@"password"] nickName:[obj objectForKey:@"nick_name"] age:[obj objectForKey:@"age"] sex:[obj objectForKey:@"sex"] headUrl:[obj objectForKey:@"head_url"] createdAt:[obj objectForKey:@"createdAt"]Earn:[obj objectForKey:@"Earn"] Expense:[obj objectForKey:@"Expense"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserInfo" object:information];
    }];
}

@end
