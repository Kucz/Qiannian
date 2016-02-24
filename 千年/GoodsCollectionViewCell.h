//
//  GoodsCollectionViewCell.h
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodslistModel;
@interface GoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Good_image;
@property (weak, nonatomic) IBOutlet UILabel *Good_description;
@property (weak, nonatomic) IBOutlet UILabel *Good_price;


@property (nonatomic, strong) GoodslistModel *model;
@end
