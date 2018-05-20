//
//  MMRemindersViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVKeyboardAvoidingScrollView.h"
#import "RNFrostedSidebar.h"
#import "Car.h"
#import "Reminder.h"
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
#import "MMAppDelegate.h"
#import "MMRemindersTableViewCell.h"
#import "MMNewReminderViewController.h"

@interface MMRemindersViewController : UITableViewController <RNFrostedSidebarDelegate, UITableViewDataSource, UITableViewDelegate>

-(id)initWithCar:(Car*) car;

@end
