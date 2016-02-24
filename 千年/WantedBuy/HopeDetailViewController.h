//
//  HopeDetailViewController.h
//  千年
//
//  Created by God on 15/12/27.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WantedByModel;
@interface HopeDetailViewController : UIViewController

@property (nonatomic,strong) WantedByModel *Hopemodel;

@property (nonatomic, copy) NSString *ReNameID;
@property (nonatomic,copy) NSString *ReNick;

@end
