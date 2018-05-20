//
//  MMCarMenuViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "MMCarMenuIcon.h"

#import "MMCarListViewController.h"

#import "MMGasolineViewController.h"
#import "MMOilViewController.h"
#import "MMGasStationsViewController.h"
#import "MMServicesViewController.h"
#import "MMServicesMapViewController.h"
#import "MMRemindersViewController.h"
#import "MMInsurancesViewController.h"
#import "MMInsuranceOfficesViewController.h"
#import "MMExpensesViewController.h"
#import "MMSummaryViewController.h"
#import "MMChartsViewController.h"

@interface MMCarMenuViewController : UIViewController

-(id)initWithCar:(Car*) car;

@end
