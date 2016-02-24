//
//  AddressModel.h
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *addresstime;
@property (nonatomic,copy) NSString *addresscity;
@property (nonatomic,copy) NSString *addressstreet;
@property (nonatomic,copy) NSString *addressperson;
@property (nonatomic,copy) NSString *addressphone;
@property (nonatomic, assign) CGFloat height;
+(void)loadAddressFromAddress;

@end
