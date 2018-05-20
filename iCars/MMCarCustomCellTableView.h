//
//  MMCarCustomCellTableView.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCarCustomCellTableView : UITableViewCell

@property (nonatomic, strong) UIImageView* carMakeLogo;
@property (nonatomic, strong) UILabel* carMakeLabel;
@property (nonatomic, strong) UILabel* carModelLabel;
@property (nonatomic, strong) UILabel* licenseTag;

@end
