//
//  MMNewReminderViewController.h
//  iCars
//
//  Created by Alexandar Drajev on 2/19/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "RDVKeyboardAvoidingScrollView.h"
#import "MMRemindersViewController.h"


@interface MMNewReminderViewController : UIViewController <UIPickerViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *odometerTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeLabel;

@property(nonatomic, strong) Car* carToEdit;

-(id)initWithCar: (Car*) car;
- (id)initWithNibName:(NSString*) nibName details: (NSString*) details andType: (int)type;

@end
