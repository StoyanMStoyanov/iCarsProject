//
//  MMCarListViewController.h
//  iCars
//
//  Created by Emilian Parvanov on 2/8/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCarCustomCellTableView.h"
#import "MMCarCustomCellCollectionView.h"
#import "MMAddNewCarViewController.h"
#import "MMCarMenuViewController.h"

@interface MMCarListViewController : UIViewController

@property (nonatomic, strong) NSFetchedResultsController *carsFetchResultsController;

@end
