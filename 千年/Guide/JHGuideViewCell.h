//
//  JHGuideViewCell.h
//  Biu
//
//  Created by he on 16/1/26.
//  Copyright © 2016年 he. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHGuideViewController;
@interface JHGuideViewCell : UICollectionViewCell

/**
 *  接收图片名称
 */
@property (nonatomic, strong) NSString *imageName;

/**
 *  告知当前cell是第几张图片
 */
@property (nonatomic, assign) int currentIndex;

/**
 *  不推荐
 */
//@property (nonatomic, strong) JHGuideViewController *guideVc;
@end
