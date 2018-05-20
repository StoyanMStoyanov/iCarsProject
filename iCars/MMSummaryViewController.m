//
//  MMSummaryViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMSummaryViewController.h"
#import "MMAppDelegate.h"

@interface MMSummaryViewController ()

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;
@property (nonatomic, strong) NSArray* allRefuelings;

@property (nonatomic, strong) UILabel *markaLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *regNumberLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *distanceOutLabel;
@property (nonatomic, strong) UILabel *totalCostLabel;
@property (nonatomic, strong) UILabel *totalCostOutLabel;
@property (nonatomic, strong) UILabel *regIDLabel;
@property (nonatomic, strong) UILabel *outCostPerKm;

@end

@implementation MMSummaryViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Summary";
        carToEdit = car;
        self.allRefuelings = [self fetchRefuelings];
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ApplicationFrame CONFIG
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
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIScrollView *newCarView = [[RDVKeyboardAvoidingScrollView alloc] initWithFrame:applicationFrame];
    [newCarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [newCarView setBackgroundColor:[UIColor whiteColor]];
    [newCarView setAlwaysBounceVertical:YES];
    [newCarView setAlwaysBounceHorizontal:NO];
    [newCarView setScrollEnabled:YES];
    
    self.markaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (applicationFrame.size.width - 40) / 3, 20)];
    self.markaLabel.textColor = [UIColor blackColor];
    self.markaLabel.font = [UIFont fontWithName:@"Arial" size:16];
    self.markaLabel.text = self.carToEdit.make;
    self.markaLabel.textAlignment = NSTextAlignmentCenter;
    [newCarView addSubview:self.markaLabel];
    
    self.modelLabel= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.markaLabel.frame) + 10, 10,(applicationFrame.size.width - 40) / 3, 20)];
    self.modelLabel.textColor = [UIColor blackColor];
    self.modelLabel.font = [UIFont fontWithName:@"Arial" size:16];
    self.modelLabel.text = self.carToEdit.model;
    self.modelLabel.textAlignment = NSTextAlignmentCenter;
    [newCarView addSubview:self.modelLabel];
    
    self.regNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.modelLabel.frame) + 10, 10, (applicationFrame.size.width - 40) / 3, 20)];
    self.regNumberLabel.textColor = [UIColor blackColor];
    self.regNumberLabel.font = [UIFont fontWithName:@"Arial" size:16];
    self.regNumberLabel.text = self.carToEdit.licenseTag;
    self.regNumberLabel.textAlignment = NSTextAlignmentCenter;
    [newCarView addSubview:self.regNumberLabel];
    
    
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.markaLabel.frame), CGRectGetMaxY(self.markaLabel.frame) + 10, CGRectGetWidth(self.markaLabel.frame), 20)];
    self.distanceLabel.textColor = [UIColor blackColor];
    self.distanceLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.distanceLabel.text = @"Разстояние:";
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    [newCarView addSubview:self.distanceLabel];
    
    self.distanceOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.distanceLabel.frame), CGRectGetMaxY(self.distanceLabel.frame) + 5, CGRectGetWidth(self.distanceLabel.frame), 20)];
    //self.distanceOutLabel.textColor = [UIColor greenColor];
    self.distanceOutLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.distanceOutLabel.textAlignment = NSTextAlignmentCenter;
    int sum = 0;
    for (Refueling* refueling in self.allRefuelings) {
        sum += [refueling.refuelingTotalCost integerValue];
    }
    [newCarView addSubview: self.distanceOutLabel];
    
    self.totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.modelLabel.frame), CGRectGetMaxY(self.modelLabel.frame) + 10, CGRectGetWidth(self.modelLabel.frame), 20)];
    self.totalCostLabel.textColor = [UIColor blackColor];
    self.totalCostLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.totalCostLabel.text = @"Обща сума:";
    self.totalCostLabel.textAlignment = NSTextAlignmentCenter;
    [newCarView addSubview:self.totalCostLabel];
    
    self.totalCostOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.totalCostLabel.frame), CGRectGetMaxY(self.totalCostLabel.frame) + 5, CGRectGetWidth(self.totalCostLabel.frame), 20)];
    //self.totalCostOutLabel.textColor = [UIColor greenColor];
    self.totalCostOutLabel.font = [UIFont fontWithName:@"Arial" size:12];
    self.totalCostOutLabel.textAlignment = NSTextAlignmentCenter;
    Refueling* lastRefueling = [self.allRefuelings lastObject];
    Refueling* firstRefueling = [self.allRefuelings firstObject];
    self.distanceOutLabel.text = [NSString stringWithFormat:@"%d лв", [firstRefueling.odometer integerValue] - [lastRefueling.odometer integerValue]];
    
    self.totalCostOutLabel.text = [NSString stringWithFormat:@"%d км", sum];
    [newCarView addSubview: self.totalCostOutLabel];
    
    self.regIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.regNumberLabel.frame) + 10, CGRectGetMaxY(self.regNumberLabel.frame) + 10, CGRectGetWidth(self.regNumberLabel.frame) + 10, 20)];
    self.regIDLabel.textColor = [UIColor blackColor];
    self.regIDLabel.font = [UIFont fontWithName:@"Arial" size:14];
    self.totalCostOutLabel.textAlignment = NSTextAlignmentCenter;
    self.regIDLabel.text = @"Цена/км:";
    [newCarView addSubview:self.regIDLabel];
    
    self.outCostPerKm = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.regIDLabel.frame)-20, CGRectGetMaxY(self.regIDLabel.frame) + 5, CGRectGetWidth(self.regIDLabel.frame), 20)];
    //self.outCostPerKm.textColor = [UIColor greenColor];
    self.outCostPerKm.font = [UIFont fontWithName:@"Arial" size:12];
    self.outCostPerKm.textAlignment = NSTextAlignmentCenter;
    self.outCostPerKm.text = [NSString stringWithFormat:@"%.4f лв/км", (float)sum/((float)[firstRefueling.odometer integerValue] - [lastRefueling.odometer integerValue])];
    [newCarView addSubview: self.self.outCostPerKm];

    
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    
    self.view = newCarView;
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
   // callout.showFromRight = YES;
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
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-(NSArray*)fetchRefuelings
{
    MMAppDelegate *appDelegate =[[UIApplication sharedApplication]delegate];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Refueling"];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"odometer" ascending:NO];
    request.sortDescriptors = @[sortByDate];
    NSError *err;
    return [[appDelegate.managedObjectContext executeFetchRequest:request error:&err] mutableCopy];
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