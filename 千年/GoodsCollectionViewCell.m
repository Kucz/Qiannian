//
//  GoodsCollectionViewCell.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "GoodslistModel.h"
#import "UIImageView+WebCache.h"
@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code

}



-(void)setModel:(GoodslistModel *)model
{
    _model = model;
    NSDate *date = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
    int day =(int) ([time integerValue] -[model.goodtime integerValue]) /3600/24;
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.goodimage,Base_url]];
    [self.Good_image sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"GoodBG.png"]];
    UIImageView *state_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
   if(day<3)
    {
        [state_image setImage:[UIImage imageNamed:@"state_new"]];
    }
//   else
//    {
//        [state_image setImage:[UIImage imageNamed:@"state_week"]];
//    }
     [self.Good_image addSubview:state_image];
//    NSLog(@"%i",day);
    
    self.Good_price.text = [NSString stringWithFormat:@"¥%@",model.goodprice];
    self.Good_description.text = model.goodtitle;
    
}

@end
