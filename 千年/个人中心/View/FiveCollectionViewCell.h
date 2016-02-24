//
//  FiveCollectionViewCell.h
//  千年
//
//  Created by God on 15/12/24.
//  Copyright © 2015年 God. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Five_ImageView;
- (IBAction)Five_Button:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Five_Button_Text;

@end
