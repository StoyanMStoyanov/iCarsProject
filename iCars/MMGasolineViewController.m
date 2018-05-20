//
//  MMGasolineViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMGasolineViewController.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface MMGasolineViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)Car* carToEdit;
@property(nonatomic) CGPoint currentOffset;
@property (nonatomic) int page;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property (nonatomic, strong)NSMutableArray* refuelingsArray;

@property (nonatomic, strong)UILabel* noRrefuelingsLabel;

@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMGasolineViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
@synthesize refuelingsArray;
@synthesize noRrefuelingsLabel;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"fuel %@", car.licenseTag];
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
#pragma mark - FetchAllRefuelingsForThatCar DRY DRY DRY
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSArray*)refuelingEntities{
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestRefuelings = [[NSFetchRequest alloc] initWithEntityName:@"Refueling"];
    requestRefuelings.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"refuelingDate" ascending:NO];
    requestRefuelings.sortDescriptors = @[sortByDate];
    NSError *errorRefuelings;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestRefuelings error:&errorRefuelings] mutableCopy];
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

    
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *newCarView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [newCarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [newCarView setBackgroundColor:[UIColor whiteColor]];
    newCarView.pagingEnabled = YES;
    newCarView.showsHorizontalScrollIndicator = YES;//no
    newCarView.showsVerticalScrollIndicator = YES;//no
    newCarView.scrollsToTop = NO;
    newCarView.delegate = self;
    
    if (self.refuelingEntities.count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noRrefuelingsLabel = [[UILabel alloc] init];
        self.noRrefuelingsLabel.textColor = [UIColor blackColor];
        self.noRrefuelingsLabel.backgroundColor = [UIColor whiteColor];
        
        self.noRrefuelingsLabel.text = @"Нямате въведени зареждания.";
        self.noRrefuelingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noRrefuelingsLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noRrefuelingsLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noRrefuelingsLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noRrefuelingsLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noRrefuelingsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noRrefuelingsLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noRrefuelingsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noRrefuelingsLabel)]];
        
        self.view = noView;
    }
    else{
        self.refuelingsArray = [[NSMutableArray alloc] init];
        UIView *refuelingView;
        for(Refueling *refueling in self.refuelingEntities) {
            refuelingView = [[UIView alloc] init];
            
            UILabel* refuelingDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
            refuelingDateLabel.text = @"Дата на презареждане";
            refuelingDateLabel.textColor = [UIColor lightGrayColor];
            refuelingDateLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:refuelingDateLabel];
            
            UILabel* refuelingDateMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            refuelingDateMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:refueling.refuelingDate]];
            [refuelingView addSubview: refuelingDateMainLabel];
            
            UILabel* totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, applicationFrame.size.width - 10, 20)];
            totalCostLabel.text = @"Крайна цена";
            totalCostLabel.textColor = [UIColor lightGrayColor];
            totalCostLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:totalCostLabel];
            
            UILabel* totalCostMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 90, 40)];
            totalCostMainLabel.text = [NSString stringWithFormat:@"%@",refueling.refuelingTotalCost];
            [refuelingView addSubview: totalCostMainLabel];
            
            UILabel* fuelPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, applicationFrame.size.width - 10, 20)];
            fuelPriceLabel.text = @"Цена гориво";
            fuelPriceLabel.textColor = [UIColor lightGrayColor];
            fuelPriceLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:fuelPriceLabel];
            
            UILabel* fuelPriceMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 90, 40)];
            fuelPriceMainLabel.text = [NSString stringWithFormat:@"%@", refueling.fuelPrice];
            [refuelingView addSubview: fuelPriceMainLabel];
            
            UILabel* litresLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 60, applicationFrame.size.width - 10, 20)];
            litresLabel.text = @"Количество(л.)";
            litresLabel.textColor = [UIColor lightGrayColor];
            litresLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:litresLabel];
            
            UILabel* litresMainlabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 70, 90, 40)];
            litresMainlabel.text = [NSString stringWithFormat:@"%.2f", round(2.0f*[refueling.refuelingQantity floatValue])/2.0f];
            [refuelingView addSubview: litresMainlabel];
            
            UILabel* odometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, applicationFrame.size.width - 10, 20)];
            odometerLabel.text = @"Километраж";
            odometerLabel.textColor = [UIColor lightGrayColor];
            odometerLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:odometerLabel];
            
            UILabel* odometerMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 90, 40)];
            odometerMainLabel.text = [NSString stringWithFormat:@"%@", refueling.odometer];
            [refuelingView addSubview: odometerMainLabel];
            
            UILabel* fullTankLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 110, applicationFrame.size.width - 10, 20)];
            fullTankLabel.text = @"Full Tank";
            fullTankLabel.textColor = [UIColor lightGrayColor];
            fullTankLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:fullTankLabel];
            
            UILabel* fullTankMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 90, 40)];
            fullTankMainLabel.text = [refueling.fullTank  isEqual: @1] ? @"Yes" : @"No";
            [refuelingView addSubview: fullTankMainLabel];
            
            UILabel* consumptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 110, applicationFrame.size.width - 10, 20)];
            consumptionLabel.text = @"л/100км";
            consumptionLabel.textColor = [UIColor lightGrayColor];
            consumptionLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:consumptionLabel];
            
            UILabel* consumptionMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 120, 90, 40)];
            int currentIndex = [self.refuelingEntities indexOfObject:refueling];
            if (currentIndex == [self.refuelingEntities count] - 1)
                consumptionMainLabel.text = @"N/A";
            else {
                CGFloat consumption = [self calculateConsumptionFrom:self.refuelingEntities[currentIndex+1] To:refueling];
                if (consumption == 0)
                    consumptionMainLabel.text = @"N/A";
                else
                    consumptionMainLabel.text = [NSString stringWithFormat:@"%.2f", consumption];
            }
            
            [refuelingView addSubview: consumptionMainLabel];
            
            UILabel* fuelTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, applicationFrame.size.width - 10, 20)];
            fuelTypeLabel.text = @"Тип гориво";
            fuelTypeLabel.textColor = [UIColor lightGrayColor];
            fuelTypeLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:fuelTypeLabel];
            
            UILabel* fuelTypeMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 90, 40)];
            fuelTypeMainLabel.text = refueling.fuelType;
            [refuelingView addSubview: fuelTypeMainLabel];
            
            UILabel* gasStationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 160, applicationFrame.size.width - 10, 20)];
            gasStationLabel.text = @"Бюензиностанция";
            gasStationLabel.textColor = [UIColor lightGrayColor];
            gasStationLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [refuelingView addSubview:gasStationLabel];
            
            UILabel* gasStationMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 170, 90, 40)];
            gasStationMainLabel.text = refueling.refuelingGasStation;
            [refuelingView addSubview: gasStationMainLabel];
            
            
            
            [refuelingsArray addObject:refuelingView];
            
        }
        
        //paging
        
        NSUInteger page = 0;
        for(UIView *view in refuelingsArray) {
            
            [newCarView addSubview:view];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
        }
        newCarView.contentSize = CGSizeMake(applicationFrame.size.width * [refuelingsArray count], applicationFrame.size.height - 44);
        

        
        [newCarView setContentOffset:self.currentOffset];
        
        
        self.view = newCarView;
    }

    //tabBar buttonsv
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    UIBarButtonItem *addNewRefueling = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewRefueling:)];
    [self.navigationItem setRightBarButtonItem:addNewRefueling];
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
-(void)addNewRefueling:(id)sender{
    MMNewRefuelingViewController* newRefueling = [[MMNewRefuelingViewController alloc] initWithCar:carToEdit];
    [self.navigationController pushViewController:newRefueling animated:YES];
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
-(CGFloat) calculateConsumptionFrom: (Refueling*)last To: (Refueling*)current {
    if (last == nil) return 0;
    if (![last.fullTank  isEqual: @1] || ![current.fullTank  isEqual: @1]) return 0;
    return ([current.refuelingQantity floatValue]/([current.odometer floatValue] - [last.odometer floatValue])*100);
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 0;
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
        if ([self.lastRefueling.odometer integerValue] >= [reminder.reminderOdometer integerValue] - 500) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:reminder.reminderType message: [NSString stringWithFormat: @"You have a reminder for %d and you are now at %d. Details: %@", [reminder.reminderOdometer integerValue], [self.lastRefueling.odometer integerValue], reminder.reminderDetails] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
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
   
    if (self.refuelingEntities.count != 0){
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