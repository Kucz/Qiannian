//
//  DetailCommentModel.m
//  千年
//
//  Created by God on 16/1/10.
//  Copyright © 2016年 God. All rights reserved.
//

#import "DetailCommentModel.h"

@implementation DetailCommentModel

//@property (nonatomic,copy) NSString *username;
//@property (nonatomic,copy) NSString *commentId;
//@property (nonatomic,copy) NSString *commentdescription;
//@property (nonatomic,copy) NSString *commenttime;
//@property (nonatomic,copy) NSString *goodId;
//@property (nonatomic,copy) NSString *commentImageUrl;
-(instancetype)initWithCommentDesc:(NSString *)commentdescription Username:(NSString *)username CommentId:(NSString *)commentId CommentTime:(NSString *)commenttime GoodId:(NSString *)goodid RegoodCommentArray:(NSMutableArray *)regoodcommentArray objectId:(NSString *)objectId
{
    if(self = [super init])
    {
        _username = username;
        _commentId = commentId;
        _commentdescription = commentdescription;
        _commenttime = commenttime;
        _goodId = goodid;
        _commentImageUrl = nil;
        _commentNick = nil;
        _userNick = nil;
        _height = 0;
        _Row = 0;
        _objectId = objectId;
        if(regoodcommentArray!=nil)
        {
            _ReGoodCommentArray = [NSMutableArray array];
            _ReGoodCommentArray = regoodcommentArray;
        }else{
            _ReGoodCommentArray = [NSMutableArray array];
        }
        
    }
    return self;
}
+(void)loadFromGoodCommentWithGoodID:(NSString *)goodId
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"GoodComment"];
    [bQuery orderByAscending:@"comment_time"];
    [bQuery whereKey:@"good_id" equalTo:goodId];
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        for(BmobObject *obj in array)
        {
            DetailCommentModel *model = [[DetailCommentModel alloc]initWithCommentDesc:[obj objectForKey:@"comment_description"] Username:[obj objectForKey:@"username"] CommentId:[obj objectForKey:@"comment_id"] CommentTime:[obj objectForKey:@"comment_time"] GoodId:[obj objectForKey:@"good_id"] RegoodCommentArray:[obj objectForKey:@"ReGoodComment"]objectId:[obj objectForKey:@"objectId"]];
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"Login"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for(BmobObject *UserOBJ in array)
                {
                    if([[UserOBJ objectForKey:@"username"]isEqualToString:[obj objectForKey:@"username"]])
                    {
                        model.userNick = [UserOBJ objectForKey:@"nick_name"];
                    }
                    if([[UserOBJ objectForKey:@"username"]isEqualToString:[obj objectForKey:@"comment_id"]])
                    {
                        model.commentNick = [UserOBJ objectForKey:@"nick_name"];
                        model.commentImageUrl = [UserOBJ objectForKey:@"head_url"];
                    }
                    
                    if(model.userNick!=nil&&model.commentNick!=nil)
                    {
                        [dataArray addObject:model];
                        model.userNick = nil;
                    }
                    if(dataArray.count == ArrayCount)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"GoodDetail" object:dataArray];
                    }
                }
            }];
        }
    }];
}



+(void)loadFromGoodCommentWithObjectId:(NSString *)objectId
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"GoodComment"];
    [bQuery orderByAscending:@"comment_time"];
    [bQuery whereKey:@"objectId" equalTo:objectId];
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArrayCount = array.count;
        for(BmobObject *obj in array)
        {
            DetailCommentModel *model = [[DetailCommentModel alloc]initWithCommentDesc:[obj objectForKey:@"comment_description"] Username:[obj objectForKey:@"username"] CommentId:[obj objectForKey:@"comment_id"] CommentTime:[obj objectForKey:@"comment_time"] GoodId:[obj objectForKey:@"good_id"] RegoodCommentArray:[obj objectForKey:@"ReGoodComment"]objectId:[obj objectForKey:@"objectId"]];
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"Login"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                
                for(BmobObject *UserOBJ in array)
                {
                    if([[UserOBJ objectForKey:@"username"]isEqualToString:[obj objectForKey:@"username"]])
                    {
                        model.userNick = [UserOBJ objectForKey:@"nick_name"];
                    }
                    
                    if([[UserOBJ objectForKey:@"username"]isEqualToString:[obj objectForKey:@"comment_id"]])
                    {
                        model.commentNick = [UserOBJ objectForKey:@"nick_name"];
                        model.commentImageUrl = [UserOBJ objectForKey:@"head_url"];
                    }
                    
                    if(model.userNick!=nil&&model.commentNick!=nil)
                    {
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                        [dictionary setObject:model forKey:@"model"];
                        [dictionary setObject:@"2" forKey:@"key"];
                        [dataArray addObject:dictionary];
                        model.userNick = nil;
                        if(dataArray.count == ArrayCount)
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReGoodDetail" object:dataArray];
                        }
                    }
                }
            }];
        }
    }];
}
@end
