//
//  ToolBarView.h
//  UI-时间选择器
//
//  Created by God on 15/12/1.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToolBarView;
@protocol ToolBarViewDelegate <NSObject>
@optional
-(void)toolBarView:(ToolBarView *)toolBarView didselectedCancelButton:(id)sender;
-(void)toolBarView:(ToolBarView *)toolBarView didselectedDoneButton:(id)sender;


@end


@interface ToolBarView : UIToolbar

@property (nonatomic,weak) id<ToolBarViewDelegate>delegate;
- (IBAction)CancelAction:(id)sender;
- (IBAction)DoneAction:(id)sender;

+(instancetype)loadView;

@end
