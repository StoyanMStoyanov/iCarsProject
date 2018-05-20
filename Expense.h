//
//  Expense.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSDate * expenseDate;
@property (nonatomic, retain) NSString * expenseType;
@property (nonatomic, retain) NSNumber * expenseTotalCost;
@property (nonatomic, retain) NSString * expenseLocation;
@property (nonatomic, retain) NSString * expenseDetails;
@property (nonatomic, retain) Car *car;

@end
