//
//  MMGasolineViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "Car.h"
#import "Refueling.h"

#import "MMCarMenuViewController.h"

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

#import "MMNewRefuelingViewController.h"

@interface MMGasolineViewController : UIViewController <RNFrostedSidebarDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) Refueling* lastRefueling;

-(id)initWithCar:(Car*) car;

@end
