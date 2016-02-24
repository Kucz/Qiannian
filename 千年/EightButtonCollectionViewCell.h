//
//  EightButtonCollectionViewCell.h
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EightModel;
@interface EightButtonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Eight_image;

@property (weak, nonatomic) IBOutlet UILabel *Eight_label;
@property (nonatomic, strong) EightModel *model;

@end
