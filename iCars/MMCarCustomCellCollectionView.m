//
//  MMCarCustomCellCollectionView.m
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMCarCustomCellCollectionView.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMCarCustomCellCollectionView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize carMakeLabel, carMakeLogo, carModelLabel, licenseTag;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor redColor];
        
        self.carMakeLogo = [[UIImageView alloc] init];
        self.carMakeLogo.translatesAutoresizingMaskIntoConstraints = NO;
        self.carMakeLogo.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview: self.carMakeLogo];
        
        self.carMakeLabel = [[UILabel alloc] init];
        self.carMakeLabel.textColor = [UIColor blackColor];
        self.carMakeLabel.backgroundColor = [UIColor whiteColor];
        self.carMakeLabel.font = [UIFont fontWithName:@"Arial" size: 28.0f];
        self.carMakeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.carMakeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.carMakeLabel.numberOfLines = 0;
        [self.contentView addSubview: self.carMakeLabel];
        
        self.carModelLabel = [[UILabel alloc] init];
        self.carModelLabel.textColor = [UIColor blackColor];
        self.carModelLabel.backgroundColor = [UIColor whiteColor];
        self.carModelLabel.font = [UIFont fontWithName:@"Arial" size: 20.0f];
        self.carModelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.carModelLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.carModelLabel.numberOfLines = 0;
        [self.contentView addSubview: self.carModelLabel];
        
        self.licenseTag = [[UILabel alloc] init];
        self.licenseTag.textColor = [UIColor blackColor];
        self.licenseTag.backgroundColor = [UIColor whiteColor];
        self.licenseTag.font = [UIFont fontWithName:@"Arial" size: 20.0f];
        self.licenseTag.translatesAutoresizingMaskIntoConstraints = NO;
        self.licenseTag.lineBreakMode = NSLineBreakByWordWrapping;
        self.licenseTag.numberOfLines = 0;
        [self.contentView addSubview: self.licenseTag];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[carMakeLogo]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2-[carMakeLogo]-1-[carMakeLabel]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,carMakeLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[carMakeLogo(==carMakeLabel)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,carMakeLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2-[carMakeLogo]-1-[carModelLabel]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,carModelLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[carMakeLogo(==carModelLabel)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,carModelLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2-[carMakeLogo]-1-[licenseTag]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,licenseTag)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[carMakeLogo(==licenseTag)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLogo,licenseTag)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[carMakeLabel]-2-[carModelLabel]-2-[licenseTag]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(carMakeLabel, carModelLabel, licenseTag)]];
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------