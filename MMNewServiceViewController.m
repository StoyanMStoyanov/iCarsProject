//
//  MMNewServiceViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/18/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMNewServiceViewController.h"

@interface MMNewServiceViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIGestureRecognizerDelegate>{
    BOOL isDatePickerViewDrop;
    BOOL isServiceTypePickerViewDrop;
}
@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong, getter = theNewServiceView)UIScrollView *newServiceView;

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *datePickerButton;

@property (nonatomic, strong) UILabel *serviceTypeLabel;
@property (nonatomic, strong) UIButton *serviceTypePickerButton;
@property (nonatomic, strong) UIPickerView *serviceTypePickerView;

@property (nonatomic, strong) UILabel *totalCostLabel;
@property (nonatomic, strong) UITextField *totalCostTextField;

@property (nonatomic, strong) UILabel *odometerLabel;
@property (nonatomic, strong) UITextField *odometerTextField;

@property (nonatomic, strong) UILabel *serviceLocationLabel;
@property (nonatomic, strong) UITextField *serviceLocationTextField;

@property (nonatomic, strong) UILabel *serviceDetailsLabel;
@property (nonatomic, strong) UITextField *serviceDetailsTextField;

@property (nonatomic, strong) UILabel *wantReminderLabel;
@property (nonatomic, strong) UISwitch *wantReminderSwitch;

@property (nonatomic) NSArray *serviceTypeArray;

@end

@implementation MMNewServiceViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize carToEdit;

@synthesize newServiceView;

@synthesize dateLabel, datePicker, datePickerButton;
@synthesize serviceTypeLabel, serviceTypePickerButton, serviceTypePickerView;
@synthesize totalCostLabel, totalCostTextField;
@synthesize odometerLabel, odometerTextField;
@synthesize serviceLocationLabel, serviceLocationTextField;
@synthesize serviceDetailsLabel, serviceDetailsTextField;
@synthesize wantReminderLabel, wantReminderSwitch;

@synthesize serviceTypeArray;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"remont %@", car.licenseTag];
        carToEdit = car;
        
        isDatePickerViewDrop = NO;
        isServiceTypePickerViewDrop = NO;
        
        self.serviceTypeArray = [[NSArray alloc] initWithObjects:@"Климатична система", @"Въздушен филтър", @"Акумулатор", @"Предп. колани", @" Шаси", @"Спирачна система", @"Филтър купе", @"Съединител", @"Охлаждане ДВГ", @"ДВГ", @"Изпускателна система", @"Горивен филтър", @"Огледала", @"Отопление", @"Клаксон", @"ГТП", @"Светлини", @"Нови гуми", @"Маслен филтър", @"Друго", @"Кормилна уредба", @"Трансмисия", @"Налягане на гумите", @"Ходова част", @"Интериор", @"Екстериор", @"Окачване", nil];    
    }
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - MainView + SaveButton + SwitchAction CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    self.newServiceView = [[RDVKeyboardAvoidingScrollView alloc]initWithFrame:applicationFrame];
    [self.newServiceView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.newServiceView setBackgroundColor:[UIColor whiteColor]];
    [self.newServiceView setAlwaysBounceVertical:YES];
    [self.newServiceView setAlwaysBounceHorizontal:NO];
    [self.newServiceView setScrollEnabled:YES];
    
    
    //----------DatePicker----------//
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, applicationFrame.size.width, 25)];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.dateLabel.text = @"Дата:";
    [self.newServiceView addSubview:self.dateLabel];
    
    self.datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame) + 10, applicationFrame.size.width/2, 25)];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    NSString *formattedDate = [formatter stringFromDate:[NSDate date]];
    [self.datePickerButton setTitle: [NSString stringWithFormat:@"%@", formattedDate] forState: UIControlStateNormal];
    [self.datePickerButton setTitle: [NSString stringWithFormat:@"%@", formattedDate] forState: UIControlStateNormal];
    [self.datePickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.datePickerButton setTitle: [NSString stringWithFormat:@"%@", formattedDate] forState: UIControlStateNormal];
    [self.datePickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.datePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [self.datePickerButton addTarget:self action: @selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.newServiceView addSubview:self.datePickerButton];
    
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, applicationFrame.size.width, 0)];
    [self.datePicker setDate:[NSDate date]];
    [self.datePicker addTarget:self action:@selector(serivceDateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    //----------ServiceTypePicker----------//
    
    self.serviceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.datePickerButton.frame) + 10, applicationFrame.size.width, 25)];
    self.serviceTypeLabel.textColor = [UIColor blackColor];
    self.serviceTypeLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.serviceTypeLabel.text = @"Тип ремонт*:";
    [self.newServiceView addSubview:self.serviceTypeLabel];
    
    
    self.serviceTypePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceTypeLabel.frame) + 10, applicationFrame.size.width/2, 25)];
    [self.serviceTypePickerButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.serviceTypePickerButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.serviceTypePickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.serviceTypePickerButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.serviceTypePickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.serviceTypePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [self.serviceTypePickerButton addTarget:self action: @selector(chooseServiceType:) forControlEvents:UIControlEventTouchUpInside];
    [self.newServiceView addSubview:self.serviceTypePickerButton];
    
    self.serviceTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.serviceTypePickerButton.frame), applicationFrame.size.width, 0)];
    [self.serviceTypePickerView setDelegate:self];
    [self.serviceTypePickerView setDataSource:self];
    
    
    //----------TotalCost----------//
    
    self.totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceTypePickerButton.frame) + 5, applicationFrame.size.width / 3, 25)];
    self.totalCostLabel.textColor = [UIColor blackColor];
    self.totalCostLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.totalCostLabel.text = @"Крайна цена:";
    [self.newServiceView addSubview:self.totalCostLabel];
    
    
    self.totalCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.totalCostLabel.frame) + 10, (applicationFrame.size.width) / 3, 25)];
    [self.totalCostTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.totalCostTextField setDelegate:self];
    self.totalCostTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.totalCostTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.newServiceView addSubview: self.totalCostTextField];
    
    
    //----------Odometer----------//
    
    self.odometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalCostLabel.frame) + 5, CGRectGetMaxY(self.serviceTypePickerButton.frame) + 5, applicationFrame.size.width / 3, 25)];
    self.odometerLabel.textColor = [UIColor blackColor];
    self.odometerLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.odometerLabel.text = @"Километраж*:";
    [self.newServiceView addSubview:self.odometerLabel];
    
    
    self.odometerTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalCostLabel.frame) + 5, CGRectGetMaxY(self.odometerLabel.frame) + 10, (applicationFrame.size.width) / 3, 25)];
    [self.odometerTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.odometerTextField setDelegate:self];
    self.odometerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.odometerTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.newServiceView addSubview: self.odometerTextField];
    
    
    //----------ServiceLocation----------//
    
    self.serviceLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.totalCostTextField.frame) + 15, applicationFrame.size.width / 3, 25)];
    self.serviceLocationLabel.textColor = [UIColor blackColor];
    self.serviceLocationLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.serviceLocationLabel.text = @"Място на ремонта:";
    [self.newServiceView addSubview:self.serviceLocationLabel];
    
    
    self.serviceLocationTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceLocationLabel.frame) + 10, (applicationFrame.size.width) / 2, 25)];
    [self.serviceLocationTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.serviceLocationTextField setDelegate:self];
    self.serviceLocationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if ([self.selectedAddress length] != 0) self.serviceLocationTextField.text = [NSString stringWithFormat:@"%@",self.selectedAddress];
    [self.newServiceView addSubview: self.serviceLocationTextField];
    
    
    //----------ServiceDetails----------//
    
    self.serviceDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceLocationTextField.frame) + 5, applicationFrame.size.width / 3, 25)];
    self.serviceDetailsLabel.textColor = [UIColor blackColor];
    self.serviceDetailsLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.serviceDetailsLabel.text = @"Детайли*:";
    [self.newServiceView addSubview:self.serviceDetailsLabel];
    
    
    self.serviceDetailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceDetailsLabel.frame) + 10, (applicationFrame.size.width) - 10, 50)];
    [self.serviceDetailsTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.serviceDetailsTextField setDelegate:self];
    self.serviceDetailsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if ([self.selectedTitle length] != 0) self.serviceDetailsTextField.text = [NSString stringWithFormat:@"В сервиз: %@",self.selectedTitle];
    [self.newServiceView addSubview: self.serviceDetailsTextField];
    
    
    //----------ServiceDetails----------//
    
    self.wantReminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.serviceDetailsTextField.frame) + 10, 120, 25)];
    self.wantReminderLabel.textColor = [UIColor blackColor];
    self.wantReminderLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.wantReminderLabel.text = @"Добави напомняне:";
    [self.newServiceView addSubview:self.wantReminderLabel];
    
    self.wantReminderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.wantReminderLabel.frame) + 10, 60, 20)];
    [self.wantReminderSwitch addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.wantReminderSwitch setBackgroundColor:[UIColor clearColor]];
    [self.newServiceView addSubview:self.wantReminderSwitch];
    
    //VERY IMPORTANT FOR THE PROPER FUNCTIONALITY OF RDVKeyboardAvoidingScrollView
     [self.newServiceView setContentSize:CGSizeMake(applicationFrame.size.width, CGRectGetMaxY(self.wantReminderSwitch.frame) + 65)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleBordered target:self action:@selector(saveServiceButtonAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    self.view = newServiceView;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void) actionSwitch:(id)sender{
    NSLog(@"This is full tank switch.");
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)saveServiceButtonAction:(id)sender{
    NSLog(@"nov remont");
    if (self.serviceTypePickerButton.titleLabel.text.length == 0 || self.totalCostTextField.text.length == 0 || self.odometerTextField.text.length == 0 || self.serviceDetailsTextField.text.length == 0) {
        UIAlertView *notEnoughServiceDetails = [[UIAlertView alloc] initWithTitle:@"Недостатъчна информация!" message:@" Полетата със ЗВЕЗДЪ са задължителни!"delegate:sender cancelButtonTitle:@"Опитайте отново" otherButtonTitles:nil];
        [notEnoughServiceDetails show];
    }
    else{
        MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];

        Service* service = [NSEntityDescription insertNewObjectForEntityForName:@"Service" inManagedObjectContext:appDelegate.managedObjectContext];
        service.serviceDate = self.datePicker.date;
        service.serviceType = self.serviceTypePickerButton.titleLabel.text;
        service.serviceTotalCost = @([self.totalCostTextField.text integerValue]);
        service.odometer = @([self.odometerTextField.text integerValue]);
        if (self.serviceLocationTextField.text.length != 0) service.serviceLocation = self.serviceLocationTextField.text;
        service.serviceDetail = self.serviceDetailsTextField.text;
        
        service.car = carToEdit;
    
        // Save the object to managedObjectContext
        NSError* newServiceError = nil;
        if (![appDelegate.managedObjectContext save:&newServiceError]) {
            NSLog(@"New Refueling ERROR: %@ %@", newServiceError, [newServiceError localizedDescription]);
        }
        else{
            NSLog(@"dobavihte nova smqna maslo");
        }
        
        NSError *error01 = nil;
        // Save the object to persistent store
        if (![appDelegate.managedObjectContext save:&error01]) {
            NSLog(@"Can't Save! %@ %@", error01, [error01 localizedDescription]);
        }

        
        
        //newRefueling.fullTank = [NSNumber numberWithBool: self.fullTankSwitch.on];
        //if wantReminder
        if (self.wantReminderSwitch.on) {
            MMNewReminderViewController* newReminderVC = [[MMNewReminderViewController alloc] initWithNibName: @"MMNewReminderViewController" details:  [NSString stringWithFormat:@"%@: %@", self.serviceTypePickerButton.titleLabel.text, self.serviceDetailsTextField.text] andType: 2];
            newReminderVC.carToEdit = carToEdit;

            [self.navigationController pushViewController:newReminderVC animated:YES];
            
        }
        else{
            MMServicesViewController* serviceVC = [[MMServicesViewController alloc] initWithCar:carToEdit];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Picker, Dismiss and Hiding CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)chooseDate:(id)sender{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    if (!isDatePickerViewDrop) {
        //[self.datePicker reloadData];
        [UIView animateWithDuration:0.01 animations:^{
            self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame) + 50, applicationFrame.size.width, 162.0);
            self.datePicker.hidden = NO;
            [self.newServiceView addSubview: self.datePicker];
            
            self.serviceTypeLabel.hidden = YES;
            self.serviceTypePickerButton.hidden = YES;
            self.serviceTypePickerView.hidden = YES;
            
            self.totalCostLabel.hidden = YES;
            self.totalCostTextField.hidden = YES;
            
            self.odometerLabel.hidden = YES;
            self.odometerTextField.hidden = YES;

            [self.view endEditing:YES];
            
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"DatePicker Shown");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            self.datePicker.frame = CGRectMake(0, 0, 0, 0);
            self.datePicker.hidden = YES;
    
            self.serviceTypeLabel.hidden = NO;
            self.serviceTypePickerButton.hidden = NO;
            //self.serviceTypePickerView.hidden = NO;
            isServiceTypePickerViewDrop = NO;
            
            self.serviceLocationLabel.hidden = NO;
            self.serviceLocationTextField.hidden = NO;
            
            self.totalCostLabel.hidden = NO;
            self.totalCostTextField.hidden = NO;
            
            self.odometerLabel.hidden = NO;
            self.odometerTextField.hidden = NO;
        }];
    }
    isDatePickerViewDrop = !isDatePickerViewDrop;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void) dismissAll{
    
    [self.view endEditing:YES];
    
    self.serviceTypePickerView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceTypePickerButton.frame), 0, 0);
    self.serviceTypePickerView.hidden = YES;
    isServiceTypePickerViewDrop = NO;
    
    self.serviceTypeLabel.hidden = NO;
    self.serviceTypePickerButton.hidden = NO;
    
    self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.datePickerButton.frame) + 10, 0, 0);
    self.datePicker.hidden = YES;
    
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    
    self.odometerLabel.hidden = NO;
    self.odometerTextField.hidden = NO;
    
    self.serviceLocationLabel.hidden = NO;
    self.serviceLocationTextField.hidden = NO;
    
    self.serviceDetailsLabel.hidden = NO;
    self.serviceDetailsTextField.hidden = NO;
    
    self.wantReminderLabel.hidden = NO;
    self.wantReminderSwitch.hidden = NO;
    
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;

    isDatePickerViewDrop = NO;
    NSLog(@"pribra se ");
    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)keyboardWasShown:(NSNotification *)aNotification {
  
    self.serviceTypePickerView.frame = CGRectMake(150, CGRectGetMaxY(self.serviceTypePickerButton.frame), 0, 0);
    self.serviceTypePickerView.hidden = YES;
    
    self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(self.datePickerButton.frame), 0, 0);
    self.datePicker.hidden = YES;
    
    self.serviceTypeLabel.hidden = NO;
    self.serviceTypePickerButton.hidden = NO;
    
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    
    self.odometerLabel.hidden = NO;
    self.odometerTextField.hidden = NO;
    
    self.serviceLocationLabel.hidden = NO;
    self.serviceLocationTextField.hidden = NO;
    
    self.serviceDetailsLabel.hidden = NO;
    self.serviceDetailsTextField.hidden = NO;
    
    self.wantReminderLabel.hidden = NO;
    self.wantReminderSwitch.hidden = NO;
    
    isServiceTypePickerViewDrop = NO;
    isDatePickerViewDrop = NO;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)chooseServiceType:(id)sender{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    if (!isServiceTypePickerViewDrop) {
        [UIView animateWithDuration:0.01 animations:^{
            self.serviceTypePickerView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceTypePickerButton.frame), applicationFrame.size.width, 162.0);
            self.serviceTypePickerView.hidden = NO;
            [self.newServiceView addSubview:self.serviceTypePickerView];
            
            self.totalCostLabel.hidden = YES;
            self.totalCostTextField.hidden = YES;
            
            self.odometerLabel.hidden = YES;
            self.odometerTextField.hidden = YES;
            
            self.serviceLocationLabel.hidden = YES;
            self.serviceLocationTextField.hidden = YES;
            
            [self.view endEditing:YES];
            
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"serviceTypePickerView Shown");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            self.serviceTypePickerView.frame = CGRectMake(0, CGRectGetMaxY(self.serviceTypePickerButton.frame), 0, 0);
            self.serviceTypePickerView.hidden = YES;
            
            self.totalCostLabel.hidden = NO;
            self.totalCostTextField.hidden = NO;
            
            self.odometerLabel.hidden = NO;
            self.odometerTextField.hidden = NO;
            
            self.serviceLocationLabel.hidden = NO;
            self.serviceLocationTextField.hidden = NO;
            
            NSLog(@"serviceTypePickerView Hidden");
            
        }];
    }
    isServiceTypePickerViewDrop = !isServiceTypePickerViewDrop;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)showDatePicker:(id)sender
{
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    
    [picker addTarget:self action:@selector(serivceDateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    picker.frame = CGRectMake(0.0, 35, pickerSize.width, 150);
    picker.backgroundColor = [UIColor blackColor];
    [self.view addSubview:picker];
    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void) serivceDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    [self.datePickerButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePicker.date]] forState:UIControlStateNormal ];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - PickerViewDelegate CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.serviceTypePickerButton setTitle: [NSString stringWithFormat:@"%@", [self.serviceTypeArray objectAtIndex:row]] forState: UIControlStateNormal];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.serviceTypeArray count];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        return [self.serviceTypeArray objectAtIndex:row];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - DATA CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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