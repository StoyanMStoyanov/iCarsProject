//
//  Reminder.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSDate * reminderDate;
@property (nonatomic, retain) NSString * reminderType;
@property (nonatomic, retain) NSNumber * reminderOdometer;
@property (nonatomic, retain) NSString * reminderDetails;
@property (nonatomic, retain) Car *car;

@end
