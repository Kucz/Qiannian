//
//  PersonView.h
//  千年
//
//  Created by God on 16/1/14.
//  Copyright © 2016年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearcherModel;
@class WantedByModel;

@protocol DidTableDelegate<NSObject>
@optional
-(void)didSelectedWithSelectedNumber:(NSInteger)number SearchModel:(SearcherModel *)model;
-(void)didSelectedWithSelectedNumber:(NSInteger)number WantedModel:(WantedByModel *)model;
@end



@interface PersonView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<DidTableDelegate>Diddelegate;

@property (nonatomic, strong) UITableView *mytab;
@property (nonatomic, assign) int selected;
@property (nonatomic, strong) NSMutableArray *searchModel;
@property (nonatomic, strong) NSMutableArray *wantedModel;

-(instancetype)init;
@end
