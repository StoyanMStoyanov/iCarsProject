//
//  MMGasStationsViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "RNFrostedSidebar.h"
#import "Car.h"

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
#import <MapKit/MapKit.h>

@interface MMGasStationsViewController : UIViewController <RNFrostedSidebarDelegate, MKMapViewDelegate, NSURLConnectionDelegate>

-(id)initWithCar:(Car*) car;

@end
