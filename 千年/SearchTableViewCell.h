//
//  SearchTableViewCell.h
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearcherModel;

@protocol DidSelectHeadDelegate <NSObject>

@optional
-(void)DidselectedWithUsername:(NSString *)username;

@end

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Goods_imageView;
@property (weak, nonatomic) IBOutlet UIButton *Head_Button;
@property (weak, nonatomic) IBOutlet UILabel *Nick_name_label;
@property (weak, nonatomic) IBOutlet UILabel *Goods_description;
@property (weak, nonatomic) IBOutlet UILabel *Goods_price;
@property (weak, nonatomic) IBOutlet UILabel *Goods_time;

@property (nonatomic ,strong) SearcherModel *model;


@property (nonatomic, weak) id<DidSelectHeadDelegate>DidDelegate;


- (IBAction)headAction:(id)sender;

@end
