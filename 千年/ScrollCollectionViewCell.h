//
//  ScrollCollectionViewCell.h
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>



@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *MypageView;

@property (nonatomic, strong) NSMutableArray *scrollArray;

@end
