//
//  OilChange.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface OilChange : NSManagedObject

@property (nonatomic, retain) NSDate * oilChangeDate;
@property (nonatomic, retain) NSNumber * oilNextChangeOdometer;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) NSNumber * oilChangeTotalCost;
@property (nonatomic, retain) NSString * oilChangeDetails;
@property (nonatomic, retain) Car *car;

@end
