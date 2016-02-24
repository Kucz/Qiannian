//
//  AddressTableViewCell.m
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressModel.h"
@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUp
{
//    for(UIView *view in [self subviews])
//    {
//        [view removeFromSuperview];
//    }
    
    self.AddressDetailLabel = [[UILabel alloc]init];
    self.AddressDetailLabel.numberOfLines = 0;
    [self addSubview:self.AddressDetailLabel];
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    [self setUp];
    [self setUpWithModel:model];
//    self.addresscell.text = [NSString stringWithFormat:@"%@%@,联系电话:%@",model.addresscity,model.addressstreet,model.addressphone];
}


-(void)setUpWithModel:(AddressModel *)model
{
    self.AddressName.text = model.addressperson;
    self.AddressPhone.text = model.addressphone;
    
    self.AddressDetailLabel.text = [NSString stringWithFormat:@"%@-%@",model.addresscity,model.addressstreet];
    CGFloat address_width = winWidth - (CGRectGetMinX(self.AddressName.frame)*2);
    CGSize address_size = [self.AddressDetailLabel.text boundingRectWithSize:CGSizeMake(address_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    [self.AddressDetailLabel setFrame:CGRectMake(CGRectGetMinX(self.AddressName.frame), CGRectGetMaxY(self.AddressName.frame), address_width, address_size.height)];
    [self.AddressDetailLabel setFont:[UIFont systemFontOfSize:15]];
//    model.height = CGRectGetMaxY(AddressDetailLabel.frame)+10;
}

@end
