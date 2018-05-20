//
//  MMRemindersViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMRemindersViewController.h"

@interface MMRemindersViewController ()

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;
@property (nonatomic, strong) UILabel* noRemindersLabel;

@end

@implementation MMRemindersViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer, noRemindersLabel;
@synthesize carToEdit;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Напомняния";
        carToEdit = car;
    }
    return self;
}
-(NSArray*)reminders{
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestRefuelings = [[NSFetchRequest alloc] initWithEntityName:@"Reminder"];
    requestRefuelings.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"reminderDate" ascending:NO];
    requestRefuelings.sortDescriptors = @[sortByDate];
    NSError *errorRefuelings;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestRefuelings error:&errorRefuelings] mutableCopy];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden){
        CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}
-(void)loadView{
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    //tabBar buttons
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
        UIBarButtonItem *addNewReminder = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewReminder:)];
    [self.navigationItem setRightBarButtonItem:addNewReminder];
    
    if ([self reminders].count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        noRemindersLabel = [[UILabel alloc] init];
        noRemindersLabel.textColor = [UIColor blackColor];
        noRemindersLabel.backgroundColor = [UIColor whiteColor];
        
        noRemindersLabel.text = @"Нямате въведени напомняния.";
        noRemindersLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            noRemindersLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            noRemindersLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        noRemindersLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: noRemindersLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noRemindersLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings( noRemindersLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noRemindersLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noRemindersLabel)]];
        
        self.view = noView;
    }
    else {
    
        UITableView* tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        UINib *cellNib = [UINib nibWithNibName:@"MMRemindersTableViewCell" bundle:nil];
        [tableView registerNib:cellNib forCellReuseIdentifier:@"mainCell"];
        self.view = tableView;
    }
    
}
-(void)addNewReminder: (id) sender {
    MMNewReminderViewController* newRefueling = [[MMNewReminderViewController alloc] initWithNibName:@"MMNewReminderViewController" bundle:nil];
    newRefueling.carToEdit = carToEdit;
    [self.navigationController pushViewController:newRefueling animated:YES];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)showHamburger:(id)sender{
    NSLog(@"menu");
    NSArray *images = @[
                        [UIImage imageNamed:@"back_logo.jpg"],
                        [UIImage imageNamed:@"refueling_logo.png"],
                        [UIImage imageNamed:@"refueling-pin_logo.png"],
                        [UIImage imageNamed:@"oilChange_logo.jpg"],
                        [UIImage imageNamed:@"services_logo.jpg"],
                        [UIImage imageNamed:@"services-pin_logo.jpg"],
                        [UIImage imageNamed:@"reminders_logo.jpg"],
                        [UIImage imageNamed:@"expenses_logo.png"],
                        [UIImage imageNamed:@"insurance_logo.png"],
                        [UIImage imageNamed:@"insurance-pin_logo.png"],
                        [UIImage imageNamed:@"summary_logo.png"],
                        [UIImage imageNamed:@"charts_logo.png"]];
    

    
    //RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //callout.showFromRight = YES;
    [callout show];
    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - RNFrostedSidebarDelegate
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    //NSLog(@"Tapped item at index %i",index);
    Class vcClass = NSClassFromString([self.viewControllersContainer objectAtIndex:index]);
    id someVC = [[vcClass alloc] initWithCar:carToEdit];
    [self.navigationController pushViewController:someVC animated:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    self.viewControllersContainer = [NSArray arrayWithObjects: @"MMCarMenuViewController",
                                     @"MMGasolineViewController",
                                     @"MMGasStationsViewController",
                                     @"MMOilViewController",
                                     @"MMServicesViewController",
                                     @"MMServicesMapViewController",
                                     @"MMRemindersViewController",
                                     @"MMExpensesViewController",
                                     @"MMInsurancesViewController",
                                     @"MMInsuranceOfficesViewController",
                                     @"MMSummaryViewController",
                                     @"MMChartsViewController",nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self reminders] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mainCell";
    MMRemindersTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"test");
    Reminder* reminder = self.reminders[indexPath.row];
    
    cell.whenLabel.text = [NSDateFormatter localizedStringFromDate:reminder.reminderDate
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    
    cell.detailsLabel.text = reminder.reminderDetails;
    if ([reminder.reminderType isEqualToString:@"OilChange"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"oilChange_logo.jpg"];
    }
    if ([reminder.reminderType isEqualToString:@"Service"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"services_logo.jpg"];
    }
    if ([reminder.reminderType isEqualToString:@"Insurance"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"insurance_logo"];
    }
    if ([reminder.reminderType isEqualToString:@"Tax"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"expenses_logo.png"];
    }
    /*
     "refueling_logo.png",
     @"refueling-pin_logo.png",//+gps
     @"oilChange_logo.jpg",
     @"services_logo.jpg",
     @"services-pin_logo.jpg",//+gps
     @"reminders_logo.jpg",
     @"expenses_logo.png",
     @"insurance_logo.png",
     @"insurance-pin_logo.png",//+gps
     @"summary_logo.png",
     @"charts_logo.png"
     */
    
    
    return cell;
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