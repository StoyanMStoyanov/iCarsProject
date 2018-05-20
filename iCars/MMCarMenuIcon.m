//
//  MMCarMenuIcon.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMCarMenuIcon.h"

@implementation MMCarMenuIcon

@synthesize carMenuIconImg, carMenuIconLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.carMenuIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 150, 150)];
        self.carMenuIconImg.translatesAutoresizingMaskIntoConstraints = NO;
        self.carMenuIconImg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview: self.carMenuIconImg];
        
        self.carMenuIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 152, 150, 20)];
        self.carMenuIconLabel.backgroundColor = [UIColor whiteColor];
        self.carMenuIconLabel.font = [UIFont fontWithName:@"Arial" size: 13.5f];
        self.carMenuIconLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.carMenuIconLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.carMenuIconLabel.numberOfLines = 0;
        self.carMenuIconLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: self.carMenuIconLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
