//
//  GoodDetailViewController.h
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodslistModel.h"
#import "SearcherModel.h"
@interface GoodDetailViewController : UIViewController
@property (nonatomic, strong) GoodslistModel *model;
@property (nonatomic, strong) SearcherModel *searchModel;


@property (nonatomic,copy) NSString *USERNAME;
@property (nonatomic,copy) NSString *USERNICK;
@property (nonatomic, assign) NSInteger ROW;
@end
