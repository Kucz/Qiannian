//
//  EightButtonCollectionViewCell.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "EightButtonCollectionViewCell.h"
#import "EightModel.h"
#import "UIImageView+WebCache.h"

@implementation EightButtonCollectionViewCell

- (void)awakeFromNib {
//    if(winHeight==568)
//    {
//        self.Eight_image.layer.cornerRadius = self.Eight_image.bounds.size.width/3.0+1;
//    }else
//    {
//         self.Eight_image.layer.cornerRadius = self.Eight_image.bounds.size.width/2.3+1;
//    }
//    
//    self.Eight_image.layer.masksToBounds = YES;
}


-(void)setModel:(EightModel *)model
{
    _model= model;
    self.Eight_label.text = model.class_name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.class_image,Base_url]];
    [self.Eight_image sd_setImageWithURL:url];
}

-(void)setimage
{
    
}
@end
