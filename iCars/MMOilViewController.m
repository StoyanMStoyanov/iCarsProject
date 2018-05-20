//
//  MMOilViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMOilViewController.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface MMOilViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)Car* carToEdit;

@property(nonatomic) CGPoint currentOffset;
@property (nonatomic) int page;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property (nonatomic, strong)NSMutableArray* oilChangesArray;

@property (nonatomic, strong)UILabel* noOilChangesLabel;




@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMOilViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
@synthesize oilChangesArray;
@synthesize noOilChangesLabel;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Масло";
        carToEdit = car;
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
#pragma mark - FetchAllOilChangesForThatCar DRY DRY DRY
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSArray*)oilChangeEntities{
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestOilChanges = [[NSFetchRequest alloc] initWithEntityName:@"OilChange"];
    requestOilChanges.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"oilChangeDate" ascending:NO];
    requestOilChanges.sortDescriptors = @[sortByDate];
    NSError *errorOilChanges;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestOilChanges error:&errorOilChanges] mutableCopy];
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
#pragma mark - MainView CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    //commit comment
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *oilChangesScrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [oilChangesScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [oilChangesScrollView setBackgroundColor:[UIColor whiteColor]];
    //[newCarView setAlwaysBounceVertical:NO];
    //[newCarView setAlwaysBounceHorizontal:NO];
    //[newCarView setScrollEnabled:YES];
    oilChangesScrollView.pagingEnabled = YES;
    oilChangesScrollView.showsHorizontalScrollIndicator = YES;//no
    oilChangesScrollView.showsVerticalScrollIndicator = YES;//no
    oilChangesScrollView.scrollsToTop = NO;
    oilChangesScrollView.delegate = self;
    
    

    if (self.oilChangeEntities.count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noOilChangesLabel = [[UILabel alloc] init];
        self.noOilChangesLabel.textColor = [UIColor blackColor];
        self.noOilChangesLabel.backgroundColor = [UIColor whiteColor];
        
        self.noOilChangesLabel.text = @"Сменете си маслото.";
        self.noOilChangesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noOilChangesLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noOilChangesLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noOilChangesLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noOilChangesLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noOilChangesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noOilChangesLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noOilChangesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noOilChangesLabel)]];
        
        self.view = noView;
    }
    
    else{
        self.oilChangesArray = [[NSMutableArray alloc] init];
        UIView *oilChangeView;
        for(OilChange *oilChange in self.oilChangeEntities) {
            oilChangeView = [[UIView alloc] init];
            
            UILabel* oilChangeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
            oilChangeDateLabel.text = @"Дата на смяна";
            oilChangeDateLabel.textColor = [UIColor lightGrayColor];
            oilChangeDateLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [oilChangeView addSubview:oilChangeDateLabel];
            
            UILabel* oilChangeDateMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            oilChangeDateMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:oilChange.oilChangeDate]];
            [oilChangeView addSubview: oilChangeDateMainLabel];
            
            
            
            UILabel* totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, applicationFrame.size.width - 10, 20)];
            totalCostLabel.text = @"Крайна цена";
            totalCostLabel.textColor = [UIColor lightGrayColor];
            totalCostLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [oilChangeView addSubview:totalCostLabel];
            
            UILabel* totalCostMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 90, 40)];
            totalCostMainLabel.text = [NSString stringWithFormat:@"%@",oilChange.oilChangeTotalCost];
            [oilChangeView addSubview: totalCostMainLabel];
            
            
            
            UILabel* odometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, applicationFrame.size.width - 10, 20)];
            odometerLabel.text = @"Километраж";
            odometerLabel.textColor = [UIColor lightGrayColor];
            odometerLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [oilChangeView addSubview:odometerLabel];
            
            UILabel* odometerMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 90, 40)];
            odometerMainLabel.text = [NSString stringWithFormat:@"%@", oilChange.odometer];//kofti imenuvana promenliva!!! ATTENZIONE!!!
            [oilChangeView addSubview: odometerMainLabel];
            
            
            UILabel* oilNextChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 110, applicationFrame.size.width - 10, 20)];
            oilNextChangeLabel.text = @"Следваща смяна";
            oilNextChangeLabel.textColor = [UIColor lightGrayColor];
            oilNextChangeLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [oilChangeView addSubview:oilNextChangeLabel];
            
            UILabel* oilNextChangeMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 90, 40)];
            oilNextChangeMainLabel.text = [NSString stringWithFormat:@"%@", oilChange.oilNextChangeOdometer];
            [oilChangeView addSubview: oilNextChangeMainLabel];
            
            
            
            UILabel* detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, applicationFrame.size.width - 10, 20)];
            detailsLabel.text = @"Детайли";
            detailsLabel.textColor = [UIColor lightGrayColor];
            detailsLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [oilChangeView addSubview:detailsLabel];
            
            UILabel* detailsMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 90, 40)];
            detailsMainLabel.text = oilChange.oilChangeDetails;
            [oilChangeView addSubview: detailsMainLabel];
            
            
            
            [oilChangesArray addObject:oilChangeView];
            
        }
        //paging
        
        NSUInteger page = 0;
        for(UIView *view in oilChangesArray) {
            
            [oilChangesScrollView addSubview:view];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
        }
        oilChangesScrollView.contentSize = CGSizeMake(applicationFrame.size.width * [oilChangesArray count], applicationFrame.size.height - 44);
        
        self.view = oilChangesScrollView;

        
    }
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    UIBarButtonItem *addNewOilChange = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewOilChange:)];
    [self.navigationItem setRightBarButtonItem:addNewOilChange];
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
-(void)addNewOilChange:(id)sender{
    MMNewOilChangeViewController* newOilChange = [[MMNewOilChangeViewController alloc] initWithCar:carToEdit];
    [self.navigationController pushViewController:newOilChange animated:YES];
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
    
    for (Reminder* reminder in [self reminders]) {
        if ([self.lastOilChange.odometer integerValue] >= [reminder.reminderOdometer integerValue] - 500) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reminder.reminderType message: [NSString stringWithFormat: @"You have a reminder for %d and you are now at %d. Details: %@", [reminder.reminderOdometer integerValue], [self.lastOilChange.odometer integerValue], reminder.reminderDetails] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Paging CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    scrollView = (UIScrollView*)self.view;
    
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.page = page;
    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)gotoPage:(BOOL)animated
{
    
    NSInteger page = self.page;
    UIScrollView* scrollView = (UIScrollView*)self.view;
    
	// update the scroll view to the appropriate page
    CGRect bounds = scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    
    if (self.oilChangeEntities.count != 0){
        [scrollView scrollRectToVisible:bounds animated:animated];
    }
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
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self loadView];
    [self gotoPage:NO];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
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