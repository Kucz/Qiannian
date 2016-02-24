//
//  WantedBuyTableViewCell.m
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import "WantedBuyTableViewCell.h"
#import "WantedByModel.h"
#import "UIButton+WebCache.h"
@implementation WantedBuyTableViewCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(WantedByModel *)model
{
    _model = model;
    Wanted_description = [[UILabel alloc]init];
    Wanted_description.numberOfLines = 0;
    [self SetUpView];
    [self addSubview:Wanted_description];
}
-(void)SetUpView
{
    self.Head_image.layer.cornerRadius = self.Head_image.bounds.size.width/2;
    self.Head_image.layer.masksToBounds = YES;
    [self.Head_image sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_model.ImageUrl,Base_url]] forState:UIControlStateNormal];
    self.Wanted_title.text = _model.Title;
    self.Wanted_price.text = [NSString stringWithFormat:@"¥%@",_model.Price];
    
    self.Wanted_time.text = [NSString timeWithString:_model.Time];
    
    Wanted_description.text = _model.Description;
    [Wanted_description setTextColor:[UIColor lightGrayColor]];
    CGFloat wanted_height =  CGRectGetMinY(self.Wanted_time.frame);
    CGFloat wanted_width = winWidth - self.Wanted_time.bounds.size.width - 20;
    CGSize Wanted_size = [Wanted_description.text boundingRectWithSize:CGSizeMake(wanted_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    [Wanted_description setFrame:CGRectMake(10, wanted_height, Wanted_size.width, Wanted_size.height)];
    Wanted_description.font = [UIFont systemFontOfSize:14];
    _model.height = CGRectGetMaxY(Wanted_description.frame)+20;
}
- (IBAction)headAction:(id)sender {
    if([self.didDelegate respondsToSelector:@selector(DidselectedWithUsername:)])
    {
        [self.didDelegate DidselectedWithUsername:self.model.userName];
    }
    
}
@end
