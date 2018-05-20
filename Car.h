//
//  Car.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense, Insurance, OilChange, Refueling, Reminder, Service;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSNumber * fuelTankCNG;
@property (nonatomic, retain) NSNumber * fuelTankLPG;
@property (nonatomic, retain) NSNumber * fuelTankMain;
@property (nonatomic, retain) NSString * licenseTag;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSSet *oilChanges;
@property (nonatomic, retain) NSSet *refuelings;
@property (nonatomic, retain) NSSet *expenses;
@property (nonatomic, retain) NSSet *insurances;
@property (nonatomic, retain) NSSet *services;
@property (nonatomic, retain) NSSet *reminders;
@end

@interface Car (CoreDataGeneratedAccessors)

- (void)addOilChangesObject:(OilChange *)value;
- (void)removeOilChangesObject:(OilChange *)value;
- (void)addOilChanges:(NSSet *)values;
- (void)removeOilChanges:(NSSet *)values;

- (void)addRefuelingsObject:(Refueling *)value;
- (void)removeRefuelingsObject:(Refueling *)value;
- (void)addRefuelings:(NSSet *)values;
- (void)removeRefuelings:(NSSet *)values;

- (void)addExpensesObject:(Expense *)value;
- (void)removeExpensesObject:(Expense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

- (void)addInsurancesObject:(Insurance *)value;
- (void)removeInsurancesObject:(Insurance *)value;
- (void)addInsurances:(NSSet *)values;
- (void)removeInsurances:(NSSet *)values;

- (void)addServicesObject:(Service *)value;
- (void)removeServicesObject:(Service *)value;
- (void)addServices:(NSSet *)values;
- (void)removeServices:(NSSet *)values;

- (void)addRemindersObject:(Reminder *)value;
- (void)removeRemindersObject:(Reminder *)value;
- (void)addReminders:(NSSet *)values;
- (void)removeReminders:(NSSet *)values;

@end
