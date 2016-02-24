//
//  WantedBuyTableViewCell.h
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WantedByModel;


@protocol DidSelectHeadDelegate <NSObject>

@optional
-(void)DidselectedWithUsername:(NSString *)username;

@end

@interface WantedBuyTableViewCell : UITableViewCell
{
    UILabel *Wanted_description;
}
@property (nonatomic,strong) WantedByModel *model;
@property (weak, nonatomic) IBOutlet UIButton *Head_image;
@property (weak, nonatomic) IBOutlet UILabel *Wanted_title;
@property (weak, nonatomic) IBOutlet UILabel *Wanted_price;
@property (weak, nonatomic) IBOutlet UILabel *Wanted_time;

@property (nonatomic, weak) id<DidSelectHeadDelegate> didDelegate;

@property (nonatomic, assign) CGFloat Height;
- (IBAction)headAction:(id)sender;

@end
