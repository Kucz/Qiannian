//
//  HopeCommentModel.m
//  千年
//
//  Created by God on 16/1/9.
//  Copyright © 2016年 God. All rights reserved.
//

#import "HopeCommentModel.h"

@implementation HopeCommentModel



//@property (nonatomic,copy) NSString *comment_id;
//@property (nonatomic,copy) NSString *username;
//@property (nonatomic,copy) NSString *good_id;
//@property (nonatomic,copy) NSString *comment_description;


-(instancetype)initWithCommentId:(NSString *)commentId UserName:(NSString *)username GoodId:(NSString *)goodId CommentDescription:(NSString *)commentdescription CommentTime:(NSString *)comment_time ObjectId:(NSString *)objectId RecommentArray:(NSMutableArray *)recommentArray
{
    if(self = [super init])
    {
        _comment_id = commentId;
        _username = username;
        _good_id = goodId;
        _comment_description = commentdescription;
        _comment_time = comment_time;
        _comment_nick = nil;
        _user_nick = nil;
        if(recommentArray!=nil)
        {
            _RecommentArray = [NSMutableArray arrayWithArray:recommentArray];
        }else{
            _RecommentArray = [NSMutableArray array];
        }
        if(objectId!=nil)
        {
           _objectId = objectId;
        }
        _height = 0;
        _Row = 0;
    }
        return self;
}



+(void)LoadDataFromClassCommentWithGoodid:(NSString *)Goodid
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    [bquery whereKey:@"good_id" equalTo:Goodid];
    [bquery orderByAscending:@"comment_time"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArraayCount = array.count;
        for(BmobObject *Bobj in array)
        {
            BmobQuery *CommentUser = [BmobQuery queryWithClassName:@"Login"];
            [CommentUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                HopeCommentModel *model = [[HopeCommentModel alloc]initWithCommentId:[Bobj objectForKey:@"comment_id"] UserName:[Bobj objectForKey:@"username"] GoodId:[Bobj objectForKey:@"good_id"] CommentDescription:[Bobj objectForKey:@"comment_description"]CommentTime:[Bobj objectForKey:@"comment_time"]ObjectId:[Bobj objectForKey:@"objectId"]RecommentArray:[Bobj objectForKey:@"Recomment"]];
                for(BmobObject *obj in array)
                {
                    if([[obj objectForKey:@"username"]isEqualToString:[Bobj objectForKey:@"username"]])
                    {
                        model.user_nick = [obj objectForKey:@"nick_name"];
                    }
                    if([[obj objectForKey:@"username"]isEqualToString:[Bobj objectForKey:@"comment_id"]])
                    {
                        model.comment_nick = [obj objectForKey:@"nick_name"];
                    }
                    if(model.comment_nick!=nil&&model.user_nick!=nil)
                    {
                        [dataArray addObject:model];
                        model.user_nick=nil;
                        if(dataArray.count==ArraayCount)
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"Comment" object:dataArray];
                        }
                    }
                }
            }];
        }
    }];
}

+(void)LoadDataFromClassCommentWithobjectId:(NSString *)objectId
{
    NSMutableArray *dataArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    [bquery whereKey:@"objectId" equalTo:objectId];
    [bquery orderByAscending:@"comment_time"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSInteger ArraayCount = array.count;
        for(BmobObject *Bobj in array)
        {
            BmobQuery *CommentUser = [BmobQuery queryWithClassName:@"Login"];
            [CommentUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                HopeCommentModel *model = [[HopeCommentModel alloc]initWithCommentId:[Bobj objectForKey:@"comment_id"] UserName:[Bobj objectForKey:@"username"] GoodId:[Bobj objectForKey:@"good_id"] CommentDescription:[Bobj objectForKey:@"comment_description"]CommentTime:[Bobj objectForKey:@"comment_time"]ObjectId:[Bobj objectForKey:@"objectId"]RecommentArray:[Bobj objectForKey:@"Recomment"]];
                for(BmobObject *obj in array)
                {
                    if([[obj objectForKey:@"username"]isEqualToString:[Bobj objectForKey:@"username"]])
                    {
                        model.user_nick = [obj objectForKey:@"nick_name"];
                    }
                    if([[obj objectForKey:@"username"]isEqualToString:[Bobj objectForKey:@"comment_id"]])
                    {
                        model.comment_nick = [obj objectForKey:@"nick_name"];
                    }
                    if(model.comment_nick!=nil&&model.user_nick!=nil)
                    {
                        model.user_nick=nil;
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                        [dictionary setObject:model forKey:@"model"];
                        [dictionary setObject:@"1" forKey:@"key"];
                        [dataArray addObject:dictionary];
                        if(dataArray.count==ArraayCount)
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReComment" object:dataArray];
//                            NSLog(@"CZ+++");
                        }
                    }
                }
            }];
        }
    }];
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"ReComment"];
//    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"Comment"];
}

@end
