//
//  JHGuideViewController.m
//  Biu
//
//  Created by he on 16/1/26.
//  Copyright © 2016年 he. All rights reserved.
//

#import "JHGuideViewController.h"
#import "JHGuideViewCell.h"

@interface JHGuideViewController ()<UICollectionViewDelegateFlowLayout>
{
    UIPageControl *pageControl;
}
//@property (nonatomic, strong) NSArray *guideImageArray;
@end

@implementation JHGuideViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    
    //定义布局方式
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    layout.itemSize = [UIScreen mainScreen].bounds.size;//设置item的大小
    layout.minimumLineSpacing = 0;

    return [self initWithCollectionViewLayout:layout];
}

//- (NSArray *)guideImageArray{
//    if (_guideImageArray==nil) {
//        _guideImageArray = @[];
//    }
//    
//    return _guideImageArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  设置collectonView 的属性
     */
    self.collectionView.pagingEnabled = YES; //分页效果
    self.collectionView.bounces = NO;//禁用弹簧效果
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[JHGuideViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-40, self.view.frame.size.width-200, 30)];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:89/255.0 green:179/255.0 blue:243/255.0 alpha:1.0];
    [self.view addSubview:pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
    [pageControl setCurrentPage:currentPage];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGuideViewCell *cell = (JHGuideViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.imageName = [NSString stringWithFormat:@"Guide_%li",(long)indexPath.row+1];
    
    cell.currentIndex = (int)indexPath.row;
    
    return cell;
}




@end
