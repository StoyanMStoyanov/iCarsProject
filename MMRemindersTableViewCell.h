//
//  MMRemindersTableViewCell.h
//  iCars
//
//  Created by Alexandar Drajev on 2/19/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRemindersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end
