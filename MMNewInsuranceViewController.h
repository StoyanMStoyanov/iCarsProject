//
//  MMNewInsuranceViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/19/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "Car.h"
#import "MMAppDelegate.h"
#import "Insurance.h"
#import "MMInsurancesViewController.h"

@interface MMNewInsuranceViewController : UIViewController

@property (nonatomic, strong) NSString* selectedTitle;

-(id)initWithCar:(Car*) car;

@end