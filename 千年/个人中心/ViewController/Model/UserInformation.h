//
//  UserInformation.h
//  千年
//
//  Created by God on 16/1/6.
//  Copyright © 2016年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *earn;
@property (nonatomic,copy) NSString *expense;


+(void)loaduserinformationFromLoginWithUsername:(NSString *)username;

@end
