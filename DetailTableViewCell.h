//
//  DetailTableViewCell.h
//  千年
//
//  Created by God on 16/1/10.
//  Copyright © 2016年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCommentModel.h"

@protocol DidSelectedDelegate <NSObject>

@optional
-(void)didSelectedWithUsername:(NSString *)username1 UserBick:(NSString *)userNick Row:(NSInteger)row;

@end

@interface DetailTableViewCell : UITableViewCell
{
    UIButton *headImageButton;
    UILabel *nickNameLabel;
    UILabel *timeLabel;
    UILabel *CommentLabel;
}
@property (nonatomic, weak) id<DidSelectedDelegate>delegate;
@property (nonatomic, strong) DetailCommentModel *model;
@end
