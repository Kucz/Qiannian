//
//  HopeCommentModel.h
//  千年
//
//  Created by God on 16/1/9.
//  Copyright © 2016年 God. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HopeCommentModel : NSObject

@property (nonatomic,copy) NSString *objectId;
@property (nonatomic,copy) NSString *comment_nick;
@property (nonatomic,copy) NSString *comment_id;
@property (nonatomic,copy) NSString *comment_time;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *user_nick;
@property (nonatomic,copy) NSString *good_id;
@property (nonatomic,copy) NSString *comment_description;

@property (nonatomic, strong) NSMutableArray *RecommentArray;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSInteger Row;
-(instancetype)initWithCommentId:(NSString *)commentId UserName:(NSString *)username GoodId:(NSString *)goodId CommentDescription:(NSString *)commentdescription CommentTime:(NSString *)comment_time ObjectId:(NSString *)objectId RecommentArray:(NSMutableArray *)recommentArray;
//+(void)LoadDataFromClassComment;
+(void)LoadDataFromClassCommentWithGoodid:(NSString *)Goodid;
+(void)LoadDataFromClassCommentWithobjectId:(NSString *)objectId;
@end
