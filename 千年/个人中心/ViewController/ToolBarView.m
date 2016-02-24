//
//  ToolBarView.m
//  UI-时间选择器
//
//  Created by God on 15/12/1.
//  Copyright © 2015年 God. All rights reserved.
//

#import "ToolBarView.h"

@implementation ToolBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)CancelAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(toolBarView:didselectedCancelButton:)])
    {
        [self.delegate toolBarView:self didselectedCancelButton:sender];
    }
}

- (IBAction)DoneAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(toolBarView:didselectedDoneButton:)])
    {
        [self.delegate toolBarView:self didselectedDoneButton:sender];
    }
}

+(instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ToolBarView" owner:nil options:nil]lastObject];
}

@end
