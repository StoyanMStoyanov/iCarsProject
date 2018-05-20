//
//  Insurance.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Insurance : NSManagedObject

@property (nonatomic, retain) NSDate * insurancePaymentDate;
@property (nonatomic, retain) NSDate * insuranceDueDate;
@property (nonatomic, retain) NSNumber * insuranceID;
@property (nonatomic, retain) NSNumber * insuranceTotalCost;
@property (nonatomic, retain) NSString * insuranceNotes;
@property (nonatomic, retain) NSString * insuraneType;
@property (nonatomic, retain) NSString * insuranceCompany;
@property (nonatomic, retain) Car *car;

@end
