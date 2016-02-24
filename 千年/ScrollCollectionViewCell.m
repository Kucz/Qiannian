//
//  ScrollCollectionViewCell.m
//  千年
//
//  Created by God on 15/12/25.
//  Copyright © 2015年 God. All rights reserved.
//

#import "ScrollCollectionViewCell.h"

@implementation ScrollCollectionViewCell
//{
//    NSTimer *timer;
//}
- (void)awakeFromNib {
    // Initialization code
    self.MypageView.currentPageIndicatorTintColor = [UIColor greenColor];
    self.MypageView.tintColor = [UIColor whiteColor];
    
//    [self.MyScrollView setBackgroundColor:[UIColor clearColor]];
    self.MyScrollView.bounces = NO;
//    self.scor
}


-(void)setScrollArray:(NSMutableArray *)scrollArray
{
    _scrollArray = scrollArray;
    
    [self.MyScrollView setContentSize:CGSizeMake(winWidth*scrollArray.count, 150)];
    [self setUpUiWithArray:scrollArray];
    
}

-(void)setUpUiWithArray:(NSMutableArray *)dataArray
{
    self.MypageView.numberOfPages = dataArray.count;
    self.MypageView.currentPage = 0;
    for(int i = 0; i < dataArray.count ; i++)
    {
        UIButton *BanButton = [[UIButton alloc]initWithFrame:CGRectMake(winWidth*i, 0, winWidth, 150*winHeight/568)];
        [BanButton setBackgroundImage:[UIImage imageNamed:dataArray[i]] forState:UIControlStateNormal];
        [BanButton addTarget:self action:@selector(ClickView) forControlEvents:UIControlEventTouchUpInside];
        [self.MyScrollView addSubview:BanButton];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(ScrollImage1) userInfo:nil repeats:YES];
}
//scrollview的点击
-(void)ClickView
{
    
}

-(void)ScrollImage1
{
    if(self.MyScrollView.contentOffset.x == winWidth*(self.scrollArray.count - 1))
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.MyScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.MyScrollView.contentOffset = CGPointMake(self.MyScrollView.contentOffset.x+winWidth, 0);
        }];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.MypageView.currentPage = scrollView.contentOffset.x/winWidth;
    if(self.MyScrollView.contentOffset.x > winWidth*(self.scrollArray.count - 1))
    {
        [UIView animateWithDuration:1.0 animations:^{
           self.MyScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(ScrollImage1) userInfo:nil repeats:YES];
}
@end
