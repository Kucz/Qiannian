//
//  DetailCommentModel.h
//  千年
//
//  Created by God on 16/1/10.
//  Copyright © 2016年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailCommentModel : NSObject
@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *commentdescription;
@property (nonatomic,copy) NSString *commenttime;
@property (nonatomic,copy) NSString *goodId;
@property (nonatomic,copy) NSString *commentImageUrl;
@property (nonatomic,copy) NSString *userNick;
@property (nonatomic,copy) NSString *commentNick;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *ReGoodCommentArray;

@property (nonatomic, assign) NSInteger Row;
+(void)loadFromGoodCommentWithGoodID:(NSString *)goodId;

+(void)loadFromGoodCommentWithObjectId:(NSString *)objectId;
@end
