//
//  MMCarCustomCell.m
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMCarCustomCell.h"

@implementation MMCarCustomCell

@synthesize carMakeLogo, carMakeLabel, carModelLabel, licenseTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.carMakeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 78, 78)];
        [self.contentView addSubview:self.carMakeLogo];
        
        self.carMakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.5, 27, 84.035, 14)];
        self.carMakeLabel.textColor = [UIColor grayColor];
        self.carMakeLabel.textAlignment = NSTextAlignmentCenter;
        //self.carMakeLabel.backgroundColor = [UIColor whiteColor];
        self.carMakeLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview: self.carMakeLabel];
        
        self.carModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.5, 40, 84.035, 14)];
        self.carModelLabel.textColor = [UIColor grayColor];
        self.carModelLabel.textAlignment = NSTextAlignmentCenter;
        //self.carModelLabel.backgroundColor = [UIColor whiteColor];
        self.carModelLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview: self.carModelLabel];
        

        self.licenseTag = [[UILabel alloc] initWithFrame:CGRectMake(245, 1, 1, 1)];
        self.licenseTag.textColor = [UIColor grayColor];
        //self.licenseTag.backgroundColor = [UIColor whiteColor];
        self.licenseTag.font = [UIFont fontWithName:@"Helvetica-Bold" size:26.0f];
        self.licenseTag.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview: self.licenseTag];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[licenseTag]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(licenseTag)]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
