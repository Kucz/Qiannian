//
//  NSString+Mobile.h
//  千年
//
//  Created by God on 15/12/28.
//  Copyright © 2015年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Mobile)
/**
 *  验证手机号是否正确
 *
 *  @param mobileNum 手机号
 *
 *  @return 是Yes否No
 */
+(BOOL)validateMobile:(NSString *)mobileNum;
/**
 *  检验时间
 *
 *  @param time 秒数
 *
 *  @return 结果
 */
+(NSString *)timeWithString:(NSString *)time;
/**
 *  检查网络
 *
 *  @return yes/no
 */
+ (BOOL)connectedToNetwork;
@end
