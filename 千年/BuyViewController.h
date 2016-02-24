//
//  BuyViewController.h
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodslistModel.h"
#import "SearcherModel.h"
@interface BuyViewController : UIViewController

@property (nonatomic, strong) GoodslistModel *goodModel;
@property (nonatomic, strong) SearcherModel *searchModel;

@property (nonatomic,copy) NSString *buyname;
@property (nonatomic,copy) NSString *buyphone;
@property (nonatomic,copy) NSString *buyaddress;
@end
