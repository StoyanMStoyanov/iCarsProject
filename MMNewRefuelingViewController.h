//
//  MMNewRefuelingViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/16/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "Car.h"
#import "MMAppDelegate.h"
#import "Refueling.h"
#import "MMGasolineViewController.h"

@interface MMNewRefuelingViewController : UIViewController

-(id)initWithCar:(Car*) car;

@end
