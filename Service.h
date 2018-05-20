//
//  Service.h
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Car;

@interface Service : NSManagedObject

@property (nonatomic, retain) NSDate * serviceDate;
@property (nonatomic, retain) NSString * serviceType;
@property (nonatomic, retain) NSNumber * serviceTotalCost;
@property (nonatomic, retain) NSString * serviceLocation;
@property (nonatomic, retain) NSString * serviceDetail;
@property (nonatomic, retain) NSNumber * odometer;
@property (nonatomic, retain) Car *car;

@end
