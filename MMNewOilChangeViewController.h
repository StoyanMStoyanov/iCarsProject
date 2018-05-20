//
//  MMNewOilChangeViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/18/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "Car.h"
#import "MMAppDelegate.h"
#import "OilChange.h"
#import "Reminder.h"
#import "MMOilViewController.h"

@interface MMNewOilChangeViewController : UIViewController

-(id)initWithCar:(Car*) car;

@end
