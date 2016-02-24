//
//  AboutMeTableCell.h
//  千年
//
//  Created by God on 16/1/25.
//  Copyright © 2016年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HopeCommentModel;
@class DetailCommentModel;

@protocol DidSelectedDelegate <NSObject>

@optional
-(void)ChooseWantedButton:(UIButton *)btn;
-(void)ChooseGoodButton:(UIButton *)btn;
@end



@interface AboutMeTableCell : UITableViewCell

@property (nonatomic, weak) id<DidSelectedDelegate>delegate;
@property (nonatomic, strong) HopeCommentModel *hopeModel;
@property (nonatomic, strong) DetailCommentModel *detailModel;

@end
