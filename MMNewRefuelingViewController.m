//
//  MMNewRefuelingViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/16/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMNewRefuelingViewController.h"

@interface MMNewRefuelingViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIGestureRecognizerDelegate>{
    BOOL isDatePickerViewDrop;
    BOOL isfuelPickerViewDrop;
    BOOL isGasStationViewDrop;
}

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) UILabel *formLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *datePickerButton;
@property (nonatomic, strong) UILabel *totalCostLabel;
@property (nonatomic, strong) UILabel *fuelPriceLabel;
@property (nonatomic, strong) UITextField *totalCostTextField;
@property (nonatomic, strong) UITextField *fuelPriceTextField;
@property (nonatomic, strong) UILabel *litersLabel;
@property (nonatomic, strong) UITextField *litersTextField;
@property (nonatomic, strong) UILabel *odometerLabel;
@property (nonatomic, strong) UITextField *odometerTextField;
@property (nonatomic, strong) UILabel *fullTankSwitchLabel;
@property (nonatomic, strong) UISwitch *fullTankSwitch;
@property (nonatomic, strong) UILabel *fuelTypeLabel;
@property (nonatomic, strong) UIPickerView *fuelTypePicerView;
@property (nonatomic, strong) UIButton *fuelTypePickerButton;
@property (nonatomic, strong) UILabel *gasStationLabel;
@property (nonatomic, strong) UIButton *gasStationPickerButton;
@property (nonatomic, strong) UIPickerView *gasStationPickerView;

@property (nonatomic) NSMutableArray *fuelType;
@property (nonatomic) NSMutableArray *gasStations;

@property (nonatomic, strong) UIScrollView *gazFormView;

@end

@implementation MMNewRefuelingViewController

@synthesize formLabel, dateLabel, totalCostLabel, fuelPriceLabel, litersLabel, odometerLabel,fuelTypeLabel, gasStationLabel, fullTankSwitchLabel;
@synthesize datePicker, totalCostTextField, fuelPriceTextField, litersTextField, odometerTextField, fuelTypePicerView, gasStationPickerButton, dateTextField;
@synthesize carToEdit, datePickerButton, fuelTypePickerButton, gazFormView, gasStationPickerView, fuelType, gasStations, fullTankSwitch;

- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"Зареждане: %@", car.licenseTag];
        carToEdit = car;
        isDatePickerViewDrop = NO;
        isfuelPickerViewDrop = NO;
        isGasStationViewDrop = NO;
        fuelType = [[NSMutableArray alloc] init];
        [fuelType addObject:@"A95"];
        [fuelType addObject:@"A95+"];
        [fuelType addObject:@"A98"];
        [fuelType addObject:@"A98+"];
        [fuelType addObject:@"Diesel"];
        [fuelType addObject:@"LPG"];
        [fuelType addObject:@"CNG"];
        
        gasStations = [[NSMutableArray alloc] init];
        [gasStations addObject:@"Shell"];
        [gasStations addObject:@"OMV"];
        [gasStations addObject:@"Petrol"];
        [gasStations addObject:@"Lukoil"];
        [gasStations addObject:@"EKO "];
        
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect gazFormFrame = [[UIScreen mainScreen] applicationFrame];
    gazFormView = [[RDVKeyboardAvoidingScrollView alloc]initWithFrame:gazFormFrame];
    [gazFormView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [gazFormView setBackgroundColor:[UIColor whiteColor]];
    [gazFormView setAlwaysBounceVertical:YES];
    [gazFormView setAlwaysBounceHorizontal:NO];
    [gazFormView setScrollEnabled:YES];
    
    //self.formLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gazFormFrame.size.width, 30)];
    //self.formLabel.textColor = [UIColor blackColor];
    //self.formLabel.font = [UIFont fontWithName:@"Arial" size:15];
    //self.formLabel.text = @"Зареждане";
    //[gazFormView addSubview:self.formLabel];
    
    //Line
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.formLabel.frame) + 10, gazFormFrame.size.width, 25)];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.dateLabel.text = @"Дата на зареждане:";
    [gazFormView addSubview:self.dateLabel];
    
    self.datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.formLabel.frame) + 10, 400, 25)];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    NSString *formattedDate = [formatter stringFromDate:[NSDate date]];
    [self.datePickerButton setTitle: [NSString stringWithFormat:@"%@", formattedDate] forState: UIControlStateNormal];
    [self.datePickerButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.datePickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.datePickerButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.datePickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.datePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [self.datePickerButton addTarget:self action: @selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [gazFormView addSubview:self.datePickerButton];
    
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateTextField.frame) + 10, gazFormFrame.size.width, 0)];
    [self.datePicker setDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    
    self.totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.dateLabel.frame) + 5, gazFormFrame.size.width / 3, 25)];
    self.totalCostLabel.textColor = [UIColor blackColor];
    self.totalCostLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.totalCostLabel.text = @"Крайна цена:";
    [gazFormView addSubview:self.totalCostLabel];
    
    self.fuelPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalCostLabel.frame), CGRectGetMaxY(self.dateLabel.frame) + 5, (gazFormFrame.size.width - 20) / 3, 25)];
    self.fuelPriceLabel.textColor = [UIColor blackColor];
    self.fuelPriceLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.fuelPriceLabel.text = @"Цена за литър:";
    [gazFormView addSubview:self.fuelPriceLabel];
    
    self.litersLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fuelPriceLabel.frame) + 5, CGRectGetMaxY(self.dateLabel.frame) + 5, (gazFormFrame.size.width - 20) / 3, 25)];
    self.litersLabel.textColor = [UIColor blackColor];
    self.litersLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.litersLabel.text = @"Заредени литри:";
    [gazFormView addSubview:self.litersLabel];
    
    
    self.totalCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.totalCostLabel.frame) + 10, (gazFormFrame.size.width -20) / 3, 25)];
    [self.totalCostTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.totalCostTextField setDelegate:self];
    self.totalCostTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.totalCostTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [gazFormView addSubview: self.totalCostTextField];
    
    self.fuelPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalCostTextField.frame) + 5, CGRectGetMaxY(self.fuelPriceLabel.frame) + 10, (gazFormFrame.size.width - 20) / 3, 25)];
    [self.fuelPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.fuelPriceTextField setDelegate:self];
    self.fuelPriceTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.fuelPriceTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [gazFormView addSubview: self.fuelPriceTextField];
    
    self.litersTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fuelPriceTextField.frame) + 5, CGRectGetMaxY(self.litersLabel.frame) + 10, (gazFormFrame.size.width - 20) / 3, 25)];
    [self.litersTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.litersTextField setDelegate:self];
    self.litersTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.litersTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [gazFormView addSubview: self.litersTextField];
    
    self.odometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.litersTextField.frame) + 10, (gazFormFrame.size.width - 20) / 3, 25)];
    self.odometerLabel.textColor = [UIColor blackColor];
    self.odometerLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.odometerLabel.text = @"Километраж:";
    [gazFormView addSubview:self.odometerLabel];
    
    self.odometerTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.odometerLabel.frame) + 10, (gazFormFrame.size.width - 20) / 3, 25)];
    [self.odometerTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.odometerTextField setDelegate:self];
    self.odometerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.odometerTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [gazFormView addSubview: self.odometerTextField];
    
    self.fullTankSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.odometerTextField.frame) + 40, CGRectGetMaxY(self.litersTextField.frame) + 10, 120, 25)];
    self.fullTankSwitchLabel.textColor = [UIColor blackColor];
    self.fullTankSwitchLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.fullTankSwitchLabel.text = @"Пълен резервоар:";
    [gazFormView addSubview:self.fullTankSwitchLabel];
    
    self.fullTankSwitch = [[UISwitch alloc] initWithFrame:CGRectMake( CGRectGetMaxX(self.odometerTextField.frame) + 60, CGRectGetMaxY(self.odometerTextField.frame) - 30, 60, 20)];
    [self.fullTankSwitch addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullTankSwitch setBackgroundColor:[UIColor clearColor]];
    //[(UILabel *)[[[[[[switchControl subviews] lastObject] subviews]
    //               objectAtIndex:1] subviews] objectAtIndex:0] setText:@"Yes"];
    //[(UILabel *)[[[[[[switchControl subviews] lastObject] subviews]
    //               objectAtIndex:1] subviews] objectAtIndex:1] setText:@"No"];
    
    
    [gazFormView addSubview:self.fullTankSwitch];
    
    
    self.fuelTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.odometerTextField.frame) + 10, (gazFormFrame.size.width - 20) / 3, 25)];
    self.fuelTypeLabel.textColor = [UIColor blackColor];
    self.fuelTypeLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.fuelTypeLabel.text = @"Гориво тип:";
    [gazFormView addSubview:self.fuelTypeLabel];
    
    
    self.fuelTypePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTypeLabel.frame) + 10, 100, 25)];
    [self.fuelTypePickerButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.fuelTypePickerButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.fuelTypePickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.fuelTypePickerButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.fuelTypePickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.datePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [self.fuelTypePickerButton addTarget:self action: @selector(chooseFuelType:) forControlEvents:UIControlEventTouchUpInside];
    [gazFormView addSubview:self.fuelTypePickerButton];

    
    self.fuelTypePicerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fuelTypePickerButton.frame), 50, 0)];
    [self.fuelTypePicerView setDelegate:self];
    [self.fuelTypePicerView setDataSource:self];
    
    
    
    self.gasStationLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(self.odometerTextField.frame) + 10, gazFormFrame.size.width, 25)];
    self.gasStationLabel.textColor = [UIColor blackColor];
    self.gasStationLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.gasStationLabel.text = @"Бензиностанция:";
    [gazFormView addSubview:self.gasStationLabel];
    
    
    
    self.gasStationPickerButton = [[UIButton alloc] initWithFrame:CGRectMake(140, CGRectGetMaxY(self.gasStationLabel.frame) + 10, (gazFormFrame.size.width - 10) / 3, 25)];
    [self.gasStationPickerButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.gasStationPickerButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.gasStationPickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.gasStationPickerButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.gasStationPickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.datePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [self.gasStationPickerButton addTarget:self action: @selector(chooseGasStation:) forControlEvents:UIControlEventTouchUpInside];
    [gazFormView addSubview:self.gasStationPickerButton];
    
    
    self.gasStationPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(self.gasStationPickerButton.frame), 50, 0)];
    [self.gasStationPickerView setDelegate:self];
    [self.gasStationPickerView setDataSource:self];

    
    
    
    //VERY IMPORTANT FOR THE PROPER FUNCTIONALITY OF RDVKeyboardAvoidingScrollView
    [gazFormView setContentSize:CGSizeMake(gazFormFrame.size.width, CGRectGetMaxY(self.gasStationPickerView.frame) + 13.45)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleBordered target:self action:@selector(saveCarButtonAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    self.view = gazFormView;
}


-(void)saveCarButtonAction:(id)sender{
    NSLog(@"novo zarejdane");
    if (self.totalCostTextField.text.length == 0 || self.fuelPriceTextField.text.length == 0 || self.odometerTextField.text.length == 0) {
        UIAlertView *notEnoughCarInfo = [[UIAlertView alloc] initWithTitle:@"Недостатъчна информация!" message:@"Крайна цена, пробег и цена за литър са задължителни полета!!!"delegate:sender cancelButtonTitle:@"Опитайте отново" otherButtonTitles:nil];
        [notEnoughCarInfo show];
    }
    else{
        
        //DRAFT 6it
        
        MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
        Refueling* newRefueling = [NSEntityDescription insertNewObjectForEntityForName:@"Refueling" inManagedObjectContext:appDelegate.managedObjectContext];
        
        newRefueling.refuelingDate = self.datePicker.date;
        
        newRefueling.refuelingTotalCost = @([self.totalCostTextField.text floatValue]);
        newRefueling.odometer = @([self.odometerTextField.text floatValue]);
        newRefueling.fuelPrice = @([self.fuelPriceTextField.text floatValue]);
        
        if (self.litersTextField.text.length != 0) newRefueling.refuelingQantity = @([self.litersTextField.text floatValue]);
        else newRefueling.refuelingQantity = [NSNumber numberWithFloat:[newRefueling.refuelingTotalCost floatValue] / [newRefueling.fuelPrice floatValue]];
        newRefueling.fuelType = [fuelType objectAtIndex:[self.fuelTypePicerView selectedRowInComponent:0]];
        if (self.gasStationPickerButton.titleLabel.text.length != 0) newRefueling.refuelingGasStation = [gasStations objectAtIndex:[self.gasStationPickerView selectedRowInComponent:0]];
        newRefueling.fullTank = [NSNumber numberWithBool: self.fullTankSwitch.on];
        newRefueling.car = carToEdit;
        
        
        
        // Save the object to managedObjectContext
        NSError* newRefuelingError = nil;
        if (![appDelegate.managedObjectContext save:&newRefuelingError]) {
            NSLog(@"New Refueling ERROR: %@ %@", newRefuelingError, [newRefuelingError localizedDescription]);
        }
        else{
            NSLog(@"dobavihte novo zarejdane");
        }
        
        NSError *error01 = nil;
        // Save the object to persistent store
        if (![appDelegate.managedObjectContext save:&error01]) {
            NSLog(@"Can't Save! %@ %@", error01, [error01 localizedDescription]);
        }
        
        //push to gasolineVC
        
        MMGasolineViewController* gasolineVC = [[MMGasolineViewController alloc] initWithCar:carToEdit];
        gasolineVC.lastRefueling = newRefueling;
        [self.navigationController pushViewController:gasolineVC animated:YES];
        
        /*
         - (void)applicationDidEnterBackground:(UIApplication *)application
         {
         NSDate *alertTime = [[NSDate date]
         dateByAddingTimeInterval:10];
         UIApplication* app = [UIApplication sharedApplication];
         UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
         init];
         if (notifyAlarm)
         {
         notifyAlarm.fireDate = alertTime;
         notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
         notifyAlarm.repeatInterval = 0;
         notifyAlarm.soundName = @"bell_tree.mp3";
         notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
         [app scheduleLocalNotification:notifyAlarm];
         }
         }
         */
        
        
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissAll)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    
    [self.view addGestureRecognizer:tap];
}


 - (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate *alertTime = [[NSDate date]
    dateByAddingTimeInterval:10];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
    init];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"bell_tree.mp3";
        notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
        [app scheduleLocalNotification:notifyAlarm];
    }
 }



- (void)keyboardWasShown:(NSNotification *)aNotification {
    
    self.gasStationPickerView.frame = CGRectMake(150, CGRectGetMaxY(self.gasStationPickerButton.frame), 0, 0);
    self.gasStationPickerView.hidden = YES;
    isGasStationViewDrop = NO;
    
    self.fuelTypePicerView.frame = CGRectMake(0, CGRectGetMaxY(self.fuelTypePickerButton.frame), 0, 0);
    self.fuelTypePicerView.hidden = YES;
    isfuelPickerViewDrop = NO;
    
    self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.dateTextField.frame) + 10, 0, 0);
    self.datePicker.hidden = YES;
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    self.fuelPriceLabel.hidden = NO;
    self.fuelPriceTextField.hidden = NO;
    self.litersLabel.hidden = NO;
    self.litersTextField.hidden = NO;
    self.odometerLabel.hidden = NO;
    self.odometerTextField.hidden = NO;
    self.fullTankSwitchLabel.hidden = NO;
    self.fullTankSwitch.hidden = NO;
    isDatePickerViewDrop = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) actionSwitch:(id)sender{
    NSLog(@"This is full tank switch.");
}





-(void) dismissAll{
    
    [self.view endEditing:YES];
    
    self.gasStationPickerView.frame = CGRectMake(150, CGRectGetMaxY(self.gasStationPickerButton.frame), 0, 0);
    self.gasStationPickerView.hidden = YES;
    isGasStationViewDrop = NO;
    
    self.fuelTypePicerView.frame = CGRectMake(0, CGRectGetMaxY(self.fuelTypePickerButton.frame), 0, 0);
    self.fuelTypePicerView.hidden = YES;
    isfuelPickerViewDrop = NO;
    
    self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.dateTextField.frame) + 10, 0, 0);
    self.datePicker.hidden = YES;
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    self.fuelPriceLabel.hidden = NO;
    self.fuelPriceTextField.hidden = NO;
    self.litersLabel.hidden = NO;
    self.litersTextField.hidden = NO;
    self.odometerLabel.hidden = NO;
    self.odometerTextField.hidden = NO;
    self.fullTankSwitchLabel.hidden = NO;
    self.fullTankSwitch.hidden = NO;
    isDatePickerViewDrop = NO;
    NSLog(@"pribra se ");

}

-(void)chooseGasStation:(id)sender{
    
    if (!isGasStationViewDrop) {
        [UIView animateWithDuration:0.01 animations:^{
            self.gasStationPickerView.frame = CGRectMake(150, CGRectGetMaxY(self.fuelTypePickerButton.frame), 100, 162.0);
            self.gasStationPickerView.hidden = NO;
            [gazFormView addSubview:gasStationPickerView];
            [self.view endEditing:YES];
            
            
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"poqvi se gasStationPickerView");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            self.gasStationPickerView.frame = CGRectMake(150, CGRectGetMaxY(self.gasStationPickerButton.frame), 0, 0);
            self.gasStationPickerView.hidden = YES;
            
            NSLog(@"pribra se gasStationPickerView");
            
        }];
    }
    isGasStationViewDrop = !isGasStationViewDrop;
    
}


-(void)chooseFuelType:(id)sender{
    
    if (!isfuelPickerViewDrop) {
        [UIView animateWithDuration:0.01 animations:^{
            self.fuelTypePicerView.frame = CGRectMake(0, CGRectGetMaxY(self.fuelTypePickerButton.frame), 100, 162.0);
            self.fuelTypePicerView.hidden = NO;
            [gazFormView addSubview:fuelTypePicerView];
            [self.view endEditing:YES];
            
            
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"poqvi se pickerView");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            self.fuelTypePicerView.frame = CGRectMake(0, CGRectGetMaxY(self.fuelTypePickerButton.frame), 0, 0);
            self.fuelTypePicerView.hidden = YES;
            
            
            NSLog(@"pribra se pickerView");
            
        }];
    }
    isfuelPickerViewDrop = !isfuelPickerViewDrop;
    
}




-(NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}


     - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
    {
        if (pickerView == fuelTypePicerView) {
            [self.fuelTypePickerButton setTitle: [NSString stringWithFormat:@"%@", [self.fuelType objectAtIndex:row]] forState: UIControlStateNormal];
        }
        else if (pickerView == gasStationPickerView){
            [self.gasStationPickerButton setTitle: [NSString stringWithFormat:@"%@", [self.gasStations objectAtIndex:row]] forState: UIControlStateNormal];
        }
        
    }
     
     - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
    {
        if (pickerView == fuelTypePicerView) {
            return [self.fuelType count];
        }
        else return [self.gasStations count];
    }
     
     - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
    {
        if (pickerView == self.fuelTypePicerView) {
            return [self.fuelType objectAtIndex:row];
        }
        else if (pickerView == self.gasStationPickerView){
            return [self.gasStations objectAtIndex:row];
            
        }
        else return nil;
    }


//-----------------------------------------------------------------------
-(void)chooseDate:(id)sender{
    
        if (!isDatePickerViewDrop) {
            //[self.datePicker reloadData];
            [UIView animateWithDuration:0.01 animations:^{
                self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.dateTextField.frame) + 30, 320, 150);
                self.datePicker.hidden = NO;
                [gazFormView addSubview:datePicker];
                self.totalCostLabel.hidden = YES;
                self.totalCostTextField.hidden = YES;
                self.fuelPriceLabel.hidden = YES;
                self.fuelPriceTextField.hidden = YES;
                self.litersLabel.hidden = YES;
                self.litersTextField.hidden = YES;
                self.odometerLabel.hidden = YES;
                self.odometerTextField.hidden = YES;
                self.fullTankSwitchLabel.hidden = YES;
                self.fullTankSwitch.hidden = YES;
                [self.view endEditing:YES];
                
            } completion:^(BOOL finished) {
                //[self.view reloadData];
                NSLog(@"poqvi se");
            }];
        }
        else{
            [UIView animateWithDuration:0.01 animations:^{
                self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.dateTextField.frame) + 10, 0, 0);
                self.datePicker.hidden = YES;
                self.totalCostLabel.hidden = NO;
                self.totalCostTextField.hidden = NO;
                self.fuelPriceLabel.hidden = NO;
                self.fuelPriceTextField.hidden = NO;
                self.litersLabel.hidden = NO;
                self.litersTextField.hidden = NO;
                self.odometerLabel.hidden = NO;
                self.odometerTextField.hidden = NO;
                self.fullTankSwitchLabel.hidden = NO;
                self.fullTankSwitch.hidden = NO;
                NSLog(@"pribra se ");
                
            }];
        }
        isDatePickerViewDrop = !isDatePickerViewDrop;
    
}




-(void)showDatePicker:(id)sender
{
    
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    
    [picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    picker.frame = CGRectMake(0.0, 35, pickerSize.width, 150);
    picker.backgroundColor = [UIColor blackColor];
    [self.view addSubview:picker];
    
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    [self.datePickerButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePicker.date]] forState:UIControlStateNormal ];
    //return [NSString stringWithFormat:@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]];
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Auto/Rotation CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotate {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else return NO;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait |
    UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
