//
//  MMNewServiceViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/18/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "Car.h"
#import "MMAppDelegate.h"
#import "Service.h"
#import "MMServicesViewController.h"
#import "MMNewReminderViewController.h"

@interface MMNewServiceViewController : UIViewController

@property (nonatomic, strong) NSString* selectedTitle;
@property (nonatomic, strong) NSString* selectedAddress;

-(id)initWithCar:(Car*) car;

@end
