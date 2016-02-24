//
//  AddressTableViewCell.h
//  千年
//
//  Created by God on 16/1/5.
//  Copyright © 2016年 God. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@interface AddressTableViewCell : UITableViewCell
//{
//    UILabel *AddressDetailLabel;
//}
@property (nonatomic , strong) UILabel *AddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressName;
@property (weak, nonatomic) IBOutlet UILabel *AddressPhone;

@property (nonatomic, strong) AddressModel *model;

@end
