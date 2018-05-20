//
//  MMNewInsuranceViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/19/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMNewInsuranceViewController.h"

@interface MMNewInsuranceViewController ()<UITextFieldDelegate, UIPickerViewDelegate,  UIActionSheetDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>{
    BOOL isDatePickerViewDrop;
    BOOL isDueDatePickerViewDrop;
    NSInteger originx;
    NSString *insuranceType;
}


@property(nonatomic, strong)Car* carToEdit;
//-------------------------------------------------------
@property (nonatomic, strong) UILabel *formLabel;
@property (nonatomic, strong) UILabel *paymontDateLabel;
@property (nonatomic, strong) UIButton *datePickerButton;
@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UITextField *companyTextField;
@property (nonatomic, strong) UILabel *insuranceIDLabel;
@property (nonatomic, strong) UITextField *insuranceIDTextField;
@property (nonatomic, strong) UILabel *totalCostLabel;
@property (nonatomic, strong) UITextField *totalCostTextField;
@property (nonatomic, strong) UILabel *dueDateLabel;
@property (nonatomic, strong) UIButton *dueDatePickerButton;
@property (nonatomic, strong) UIDatePicker *dueDatePickerView;
@property (nonatomic, strong) UILabel *expenseDetailLabel;
@property (nonatomic, strong) UITextField *expenseDetailTextView;
@property (nonatomic, strong) UILabel *expenseLocationLabel;
@property (nonatomic, strong) UITextField *expenseLocationTextField;
@property (nonatomic, strong) UISwitch *diferentInsuranceSwitch;
@property (nonatomic, strong) UILabel *leftSwitchLabel;
@property (nonatomic, strong) UILabel *rightSwitchLabel;


@property (nonatomic, strong, getter = theNewInsView) UIScrollView *newInsView;

//-------------------------------------------------------


@end

@implementation MMNewInsuranceViewController

@synthesize carToEdit;

@synthesize formLabel, paymontDateLabel, insuranceIDLabel, totalCostLabel, dueDateLabel, expenseDetailLabel, companyLabel, expenseLocationLabel;
@synthesize datePickerButton, totalCostTextField, insuranceIDTextField, companyTextField, expenseLocationTextField, leftSwitchLabel, rightSwitchLabel;
@synthesize newInsView, datePickerView, dueDatePickerButton, dueDatePickerView;
@synthesize expenseDetailTextView;


- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"new ins %@", car.licenseTag];
        carToEdit = car;
        
        isDatePickerViewDrop = NO;
        isDueDatePickerViewDrop = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
            originx = 100;
        }
        else
            originx = 0;
        insuranceType = [NSString stringWithFormat:@"Kasko"];
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect newInsFrame = [[UIScreen mainScreen] applicationFrame];
    newInsView = [[RDVKeyboardAvoidingScrollView alloc]initWithFrame:newInsFrame];
    [newInsView setBackgroundColor:[UIColor whiteColor]];
    [newInsView setAlwaysBounceVertical:YES];
    [newInsView setAlwaysBounceHorizontal:NO];
    [newInsView setScrollEnabled:YES];
        
    self.paymontDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, newInsFrame.size.width /3, 20)];
    self.paymontDateLabel.textColor = [UIColor blackColor];
    self.paymontDateLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.paymontDateLabel.text = @"Дата на плащане:";
    [newInsView addSubview:self.paymontDateLabel];
    
    self.datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.formLabel.frame) + 10, 400, 25)];
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
    [self.datePickerButton addTarget:self action: @selector(choosePayDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.newInsView addSubview:self.datePickerButton];
 
    
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.paymontDateLabel.frame) + 10, newInsFrame.size.width / 3, 0)];
    [self.datePickerView setDate:[NSDate date]];
    [self.datePickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePickerView.datePickerMode = UIDatePickerModeDate;
    
    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.paymontDateLabel.frame) + 10, newInsFrame.size.width - 20 , 20)];
    self.companyLabel.textColor = [UIColor blackColor];
    self.companyLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.companyLabel.text = @"Застрахователна компания:";
    [newInsView addSubview:self.companyLabel];
    
    self.companyTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.companyLabel.frame) + 10, newInsFrame.size.width - 20 , 20)];
    [self.companyTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.companyTextField setDelegate:self];
    self.companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [newInsView addSubview: self.companyTextField];
    
    self.insuranceIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.companyTextField.frame) +10, newInsFrame.size.width - 20, 20)];
    self.insuranceIDLabel.textColor = [UIColor blackColor];
    self.insuranceIDLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.insuranceIDLabel.text = @"Номер на застраховка:";
    [newInsView addSubview:self.insuranceIDLabel];
    
    self.insuranceIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insuranceIDLabel.frame) + 10, newInsFrame.size.width - 20, 20)];
    [self.insuranceIDTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.insuranceIDTextField setDelegate:self];
    self.insuranceIDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [newInsView addSubview: self.insuranceIDTextField];

    
    self.totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.insuranceIDTextField.frame) + 10, (newInsFrame.size.width - 30) / 2, 20)];
    self.totalCostLabel.textColor = [UIColor blackColor];
    self.totalCostLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.totalCostLabel.text = @"Крайна цена:";
    [newInsView addSubview:self.totalCostLabel];
        
    self.totalCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.totalCostLabel.frame) + 10, (newInsFrame.size.width - 30) / 2, 20)];
    [self.totalCostTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.totalCostTextField setDelegate:self];
    [self.totalCostTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.totalCostTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [newInsView addSubview: self.totalCostTextField];
    
    self.dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalCostTextField.frame) + 30, CGRectGetMaxY(self.insuranceIDTextField.frame) + 10, (newInsFrame.size.width - 30) /2, 20)];
    self.dueDateLabel.textColor = [UIColor blackColor];
    self.dueDateLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.dueDateLabel.text = @"Срок на полицата:";
    [newInsView addSubview:self.dueDateLabel];
    
    self.dueDatePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.dueDateLabel.frame), CGRectGetMaxY(self.dueDateLabel.frame) + 10, (newInsFrame.size.width - 50) / 2, 20)];
    [self.dueDatePickerButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.dueDatePickerButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.dueDatePickerButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.dueDatePickerButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.dueDatePickerButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.dueDatePickerButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
    self.dueDatePickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.dueDatePickerButton addTarget:self action: @selector(chooseDueDate:) forControlEvents:UIControlEventTouchUpInside];
    [newInsView addSubview:self.dueDatePickerButton];
    
    
    self.dueDatePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dueDatePickerButton.frame), 162, 0)];
    [self.dueDatePickerView setDate:[NSDate date]];
    [self.dueDatePickerView addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    self.dueDatePickerView.datePickerMode = UIDatePickerModeDate;

    
    
    self.expenseLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.totalCostTextField.frame) + 10, (newInsFrame.size.width - 30) /2, 20)];
    self.expenseLocationLabel.textColor = [UIColor blackColor];
    self.expenseLocationLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.expenseLocationLabel.text = @"Тип на зстраховката:";
    [newInsView addSubview:self.expenseLocationLabel];
    
    self.diferentInsuranceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((newInsFrame.size.width / 2 ) - 50, CGRectGetMaxY(self.expenseLocationLabel.frame) + 5, newInsFrame.size.width - 20, 20)];
    [self.diferentInsuranceSwitch addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.diferentInsuranceSwitch setBackgroundColor:[UIColor clearColor]];
    [newInsView addSubview:self.diferentInsuranceSwitch];

    
    
    self.leftSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.expenseLocationLabel.frame) + 10, 60, 20)];
    self.leftSwitchLabel.textColor = [UIColor blackColor];
    self.leftSwitchLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.leftSwitchLabel.text = @"Каско";
    self.leftSwitchLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftSwitchLabel.backgroundColor = [UIColor greenColor];
    
    [newInsView addSubview:self.leftSwitchLabel];
    
    self.rightSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.diferentInsuranceSwitch.frame) + 10, CGRectGetMaxY(self.expenseLocationLabel.frame) + 10, 140, 20)];
    self.rightSwitchLabel.textColor = [UIColor blackColor];
    self.rightSwitchLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.rightSwitchLabel.text = @"Гражданска отговорност";
    [newInsView addSubview:self.rightSwitchLabel];
    
    self.expenseDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.diferentInsuranceSwitch.frame) + 10,newInsFrame.size.width / 2, 20)];
    self.expenseDetailLabel.textColor = [UIColor blackColor];
    self.expenseDetailLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.expenseDetailLabel.text = @"Бележки:";
    [newInsView addSubview:self.expenseDetailLabel];
    
    self.expenseDetailTextView = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.expenseDetailLabel.frame) + 10, newInsFrame.size.width - 20, 40)];
    [[self.expenseDetailTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.expenseDetailTextView layer] setBorderWidth:0.5];
    [[self.expenseDetailTextView layer] setCornerRadius:3];
    [self.expenseDetailTextView setDelegate:self];
    self.expenseDetailTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    

    [newInsView addSubview: self.expenseDetailTextView];

    
    //VERY IMPORTANT FOR THE PROPER FUNCTIONALITY OF RDVKeyboardAvoidingScrollView
   [newInsView setContentSize:CGSizeMake(newInsFrame.size.width, CGRectGetMaxY(self.expenseDetailTextView.frame) + 85)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleBordered target:self action:@selector(saveInsurance:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    self.view = newInsView;
}
-(void)saveInsurance:(id)sender{
    NSLog(@"zastrahovka");
    if (self.companyTextField.text.length == 0 || self.insuranceIDTextField.text.length == 0 || self.totalCostTextField.text.length == 0) {
        UIAlertView *notEnoughCarInfo = [[UIAlertView alloc] initWithTitle:@"Недостатъчна информация!" message:@"Застрахователна  компания, номер на застраховка и крайна цена са задължинелни полета!!!"delegate:sender cancelButtonTitle:@"Опитайте отново" otherButtonTitles:nil];
        [notEnoughCarInfo show];
    }
     else{
        
        MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
        Insurance* newInsurance = [NSEntityDescription insertNewObjectForEntityForName:@"Insurance" inManagedObjectContext:appDelegate.managedObjectContext];
        
        newInsurance.insurancePaymentDate = self.datePickerView.date;
        newInsurance.insuranceDueDate = self.dueDatePickerView.date;
        newInsurance.insuranceID = @([self.insuranceIDTextField.text integerValue]);
        newInsurance.insuranceTotalCost = @([self.totalCostTextField.text integerValue]);
        newInsurance.insuranceNotes = self.expenseDetailTextView.text;
        newInsurance.insuraneType = insuranceType;
        newInsurance.insuranceCompany = self.companyTextField.text;
         
        newInsurance.car = carToEdit;
         
         
        Reminder* newInsurenceReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminder" inManagedObjectContext:appDelegate.managedObjectContext];
        newInsurenceReminder.reminderDate = self.dueDatePickerView.date;
        newInsurenceReminder.reminderType = @"Insurance";
        //newInsurenceReminder.reminderOdometer = @([self.nextChangeTextField.text integerValue]);
        newInsurenceReminder.reminderDetails = self.expenseDetailTextView.text;
         
        newInsurenceReminder.car = carToEdit;
         
        
        
        
        
        // Save the object to managedObjectContext
        NSError* newInsuranceError = nil;
        if (![appDelegate.managedObjectContext save:&newInsuranceError]) {
            NSLog(@"New Insurance ERROR: %@ %@", newInsuranceError, [newInsuranceError localizedDescription]);
        }
        else{
            NSLog(@"dobavihte nova zastrahovka");
        }
        
        NSError *error01 = nil;
        // Save the object to persistent store
        if (![appDelegate.managedObjectContext save:&error01]) {
            NSLog(@"Can't Save! %@ %@", error01, [error01 localizedDescription]);
        }

        MMInsurancesViewController* insuranceVC = [[MMInsurancesViewController alloc] initWithCar:carToEdit];
        [self.navigationController pushViewController:insuranceVC animated:YES];
    
    }
}

-(void) actionSwitch:(id)sender{
    if (self.diferentInsuranceSwitch .on) {
        self.leftSwitchLabel.backgroundColor = [UIColor whiteColor];
        self.rightSwitchLabel.backgroundColor = [UIColor greenColor];
        insuranceType = [NSString stringWithFormat:@"Гражданска отговорност:"];
    }
    else{
        self.leftSwitchLabel.backgroundColor = [UIColor greenColor];
        self.rightSwitchLabel.backgroundColor = [UIColor whiteColor];
        insuranceType = [NSString stringWithFormat:@"Kasko"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    if ([self.selectedTitle length] != 0)
        self.expenseDetailTextView.text = [NSString stringWithFormat: @"Офис: %@",self.selectedTitle];
        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissAll)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self.view addGestureRecognizer:tap];

}
//-------------------------------------------------------------------------------------
- (void)keyboardWasShown:(NSNotification *)aNotification {
    
    self.datePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.datePickerButton.frame) + 10, 320 + originx, 0);
    self.datePickerView.hidden = YES;
    isDatePickerViewDrop = NO;
    
    self.dueDatePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.dueDatePickerButton.frame) + 10, 320 + originx, 0);
    self.dueDatePickerView.hidden = YES;
    isDueDatePickerViewDrop = NO;
    
    self.companyLabel.hidden = NO;
    self.companyTextField.hidden = NO;
    self.insuranceIDLabel.hidden = NO;
    self.insuranceIDTextField.hidden = NO;
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    self.dueDateLabel.hidden = NO;
    self.dueDatePickerButton.hidden = NO;
    self.expenseLocationLabel.hidden = NO;
    self.expenseLocationTextField.hidden = NO;
    self.expenseDetailLabel.hidden = NO;
    self.expenseDetailTextView.hidden = NO;
    self.diferentInsuranceSwitch.hidden = NO;
    self.leftSwitchLabel.hidden = NO;
    self.rightSwitchLabel.hidden = NO;
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) dismissAll{
    
    [self.view endEditing:YES];
    
    self.datePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.datePickerButton.frame) + 10, 320 + originx, 0);
    self.datePickerView.hidden = YES;
    isDatePickerViewDrop = NO;
    
    self.dueDatePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.dueDatePickerButton.frame) + 10, 320 + originx, 0);
    self.dueDatePickerView.hidden = YES;
    isDueDatePickerViewDrop = NO;
    
    self.companyLabel.hidden = NO;
    self.companyTextField.hidden = NO;
    self.insuranceIDLabel.hidden = NO;
    self.insuranceIDTextField.hidden = NO;
    self.totalCostLabel.hidden = NO;
    self.totalCostTextField.hidden = NO;
    self.dueDateLabel.hidden = NO;
    self.dueDatePickerButton.hidden = NO;
    self.expenseLocationLabel.hidden = NO;
    self.expenseLocationTextField.hidden = NO;
    self.expenseDetailLabel.hidden = NO;
    self.expenseDetailTextView.hidden = NO;
    self.diferentInsuranceSwitch.hidden = NO;
    self.leftSwitchLabel.hidden = NO;
    self.rightSwitchLabel.hidden = NO;
    
    NSLog(@"pribra se DISMISS");
    
}

//-----------------------------------------------------------------------
-(void)choosePayDate:(id)sender{
    
    if (!isDatePickerViewDrop) {
        [UIView animateWithDuration:0.01 animations:^{
            self.datePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.paymontDateLabel.frame) + 10, 320 + originx, 162);
            self.datePickerView.hidden = NO;
            
            self.companyLabel.hidden = YES;
            self.companyTextField.hidden = YES;
            self.insuranceIDLabel.hidden = YES;
            self.insuranceIDTextField.hidden = YES;
            self.totalCostLabel.hidden = YES;
            self.totalCostTextField.hidden = YES;
            self.dueDateLabel.hidden = YES;
            self.dueDatePickerButton.hidden = YES;
            
            self.dueDatePickerView.hidden = YES;
            isDueDatePickerViewDrop = NO;
            self.expenseLocationLabel.hidden = NO;
            self.expenseLocationTextField.hidden = NO;
            self.expenseDetailLabel.hidden = NO;
            self.expenseDetailTextView.hidden = NO;
            self.diferentInsuranceSwitch.hidden = NO;
            self.leftSwitchLabel.hidden = NO;
            self.rightSwitchLabel.hidden = NO;
            
            [self.view endEditing:YES];
            [newInsView addSubview:datePickerView];
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"poqvi se 456");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            self.datePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.datePickerButton.frame) + 10, 320 + originx, 0);
            self.datePickerView.hidden = YES;
            self.companyLabel.hidden = NO;
            self.companyTextField.hidden = NO;
            self.insuranceIDLabel.hidden = NO;
            self.insuranceIDTextField.hidden = NO;
            self.totalCostLabel.hidden = NO;
            self.totalCostTextField.hidden = NO;
            self.dueDateLabel.hidden = NO;
            self.dueDatePickerButton.hidden = NO;
            NSLog(@"pribra se 456");
            
        }];
    }
    isDatePickerViewDrop = !isDatePickerViewDrop;
    
}

-(void)chooseDueDate:(id)sender{
    
    if (!isDueDatePickerViewDrop) {
        [UIView animateWithDuration:0.01 animations:^{
            self.dueDatePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.totalCostTextField.frame) + 5, 320 + originx, 162);
            self.dueDatePickerView.hidden = NO;
            
            self.expenseLocationLabel.hidden = YES;
            self.expenseLocationTextField.hidden = YES;
            self.expenseDetailLabel.hidden = YES;
            self.expenseDetailTextView.hidden = YES;
            self.diferentInsuranceSwitch.hidden = YES;
            self.leftSwitchLabel.hidden = YES;
            self.rightSwitchLabel.hidden = YES;
            
            [self.view endEditing:YES];
            [newInsView addSubview:dueDatePickerView];
        } completion:^(BOOL finished) {
            //[self.view reloadData];
            NSLog(@"poqvi se123");
        }];
    }
    else{
        [UIView animateWithDuration:0.01 animations:^{
            
            self.dueDatePickerView.frame = CGRectMake(originx, CGRectGetMaxY(self.dueDatePickerButton.frame) + 10, 320 + originx, 0);
            self.dueDatePickerView.hidden = YES;
            self.expenseLocationLabel.hidden = NO;
            self.expenseLocationTextField.hidden = NO;
            self.expenseDetailLabel.hidden = NO;
            self.expenseDetailTextView.hidden = NO;
            self.diferentInsuranceSwitch.hidden = NO;
            self.leftSwitchLabel.hidden = NO;
            self.rightSwitchLabel.hidden = NO;
            NSLog(@"pribra se123 ");
            
        }];
    }
    isDueDatePickerViewDrop = !isDueDatePickerViewDrop;
    
}


-(void)showDatePicker:(id)sender
{
    
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    picker.frame = CGRectMake(0.0, 35, pickerSize.width, 150);
    picker.backgroundColor = [UIColor blackColor];
    [self.view addSubview:picker];
    
}

-(void) dateChanged:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    [self.datePickerButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePickerView.date]] forState:UIControlStateNormal ];
}
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"dd' 'MMMM' 'yyyy"];
    [self.dueDatePickerButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:self.dueDatePickerView.date]] forState:UIControlStateNormal ];
}

//-------------------------------------------------------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
