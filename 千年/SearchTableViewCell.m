//
//  SearchTableViewCell.m
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "SearcherModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation SearchTableViewCell

- (void)awakeFromNib {
    self.Head_Button.layer.cornerRadius = self.Head_Button.bounds.size.width/2;
    self.Head_Button.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(SearcherModel *)model
{
    _model = model;
    [self.Goods_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.goodimage,Base_url]]];
    self.Goods_description.text = model.gooddescription;
    self.Goods_price.text = [NSString stringWithFormat:@"¥%@",model.goodprice];
    
    NSString *time = _model.goodtime;
    NSDate *date = [NSDate date];
    NSString *timenow = [NSString stringWithFormat:@"%li",(long)[date timeIntervalSince1970]];
    int timepre = [timenow intValue]-[time intValue];
    int hour = timepre/3600;
    int min = timepre/60%60;
    int second = timepre%60;
    int day = hour/24;
    int month = day/30;
    if(month>0)
    {
       self.Goods_time.text = [NSString stringWithFormat:@"%i月前",month];
    }else if(day>0)
    {
        self.Goods_time.text = [NSString stringWithFormat:@"%i天前",day];
    }
    else if(hour>0)
    {
        self.Goods_time.text = [NSString stringWithFormat:@"%i小时前",hour];
    }else if(min>0)
    {
        self.Goods_time.text = [NSString stringWithFormat:@"%i分钟前",min];
    }else{
        self.Goods_time.text = [NSString stringWithFormat:@"%i秒前",second];
    }
    
    
    [self.Head_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.headimage,Base_url]] forState:UIControlStateNormal];
    self.Nick_name_label.text = model.nickname;
}

- (IBAction)headAction:(id)sender {
    if([self.DidDelegate respondsToSelector:@selector(DidselectedWithUsername:)])
    {
        [self.DidDelegate DidselectedWithUsername:self.model.good_username];
    }
}
@end
