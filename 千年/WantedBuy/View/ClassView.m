//
//  ClassView.m
//  千年
//
//  Created by God on 16/1/15.
//  Copyright © 2016年 God. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self =[super initWithFrame:frame])
    {
        self.frame = frame;
        _classBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.width)];
        _classLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width, self.bounds.size.width, self.bounds.size.height-self.bounds.size.width)];
        _classLab.textAlignment = NSTextAlignmentCenter;
        [_classLab setFont:[UIFont systemFontOfSize:12]];
        _classLab.textColor = [UIColor redColor];
        [self addSubview:_classBtn];
        [self addSubview:_classLab];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
