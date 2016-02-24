//
//  HopeCommentCell.h
//  千年
//
//  Created by God on 16/1/9.
//  Copyright © 2016年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HopeCommentModel.h"
@protocol DidselectDelegate <NSObject>

@optional
-(void)didSelectedWithUserName:(NSString *)username UserNick:(NSString *)userNick Row:(NSInteger)row;

@end


@interface HopeCommentCell : UITableViewCell
{
    UILabel *CommentMan;
    UILabel *CenterLabel;
    UILabel *HopeMan;
    UILabel *HopeComment;
    UILabel *TimeLabel;

    
//    UIButton *RecommentUser;
//    UIButton *REcommentMan;
//    UILabel *ContentLabel;
//    UILabel *
    
}

@property (nonatomic, weak) id<DidselectDelegate>delegate;
@property (nonatomic, strong) HopeCommentModel *model;
@property (nonatomic, assign) CGFloat Height;

@end
