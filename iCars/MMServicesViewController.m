//
//  MMServicesViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMServicesViewController.h"

@interface MMServicesViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)Car* carToEdit;

@property(nonatomic) CGPoint currentOffset;
@property (nonatomic) int page;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property (nonatomic, strong)NSMutableArray* servicesArray;

@property (nonatomic, strong)UILabel* noServicesLabel;




@end

@implementation MMServicesViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
@synthesize servicesArray;
@synthesize noServicesLabel;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Ремонти";
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
-(NSArray*)serviceEntities{
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestOilChanges = [[NSFetchRequest alloc] initWithEntityName:@"Service"];
    requestOilChanges.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"serviceDate" ascending:NO];
    requestOilChanges.sortDescriptors = @[sortByDate];
    NSError *errorOilChanges;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestOilChanges error:&errorOilChanges] mutableCopy];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - MainView CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    //commit comment
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *servicesScrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [servicesScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [servicesScrollView setBackgroundColor:[UIColor whiteColor]];
    //[newCarView setAlwaysBounceVertical:NO];
    //[newCarView setAlwaysBounceHorizontal:NO];
    //[newCarView setScrollEnabled:YES];
    servicesScrollView.pagingEnabled = YES;
    servicesScrollView.showsHorizontalScrollIndicator = YES;//no
    servicesScrollView.showsVerticalScrollIndicator = YES;//no
    servicesScrollView.scrollsToTop = NO;
    servicesScrollView.delegate = self;
    
    
    
    if (self.serviceEntities.count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noServicesLabel = [[UILabel alloc] init];
        self.noServicesLabel.textColor = [UIColor blackColor];
        self.noServicesLabel.backgroundColor = [UIColor whiteColor];
        
        self.noServicesLabel.text = @"Нямате въведени ремонти.";
        self.noServicesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noServicesLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noServicesLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noServicesLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noServicesLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noServicesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noServicesLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noServicesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noServicesLabel)]];
        
        self.view = noView;
    }
    
    else{
        self.servicesArray = [[NSMutableArray alloc] init];
        UIView *serviceView;
        for(Service *service in self.serviceEntities) {
            serviceView = [[UIView alloc] init];
            
            UILabel* serviceDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
            serviceDate.text = @"Дата на смяна";
            serviceDate.textColor = [UIColor lightGrayColor];
            serviceDate.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:serviceDate];
            
            UILabel* serviceDateMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            serviceDateMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:service.serviceDate]];
            [serviceView addSubview: serviceDateMainLabel];
            
            
            
            UILabel* totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, applicationFrame.size.width / 2, 20)];
            totalCostLabel.text = @"Крайна цена";
            totalCostLabel.textColor = [UIColor lightGrayColor];
            totalCostLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:totalCostLabel];
            
            UILabel* totalCostMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, applicationFrame.size.width, 40)];
            totalCostMainLabel.text = [NSString stringWithFormat:@"%@",service.serviceTotalCost];
            [serviceView addSubview: totalCostMainLabel];
            
            
            
            UILabel* odometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, applicationFrame.size.width / 2, 20)];
            odometerLabel.text = @"Километраж";
            odometerLabel.textColor = [UIColor lightGrayColor];
            odometerLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:odometerLabel];
            
            UILabel* odometerMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 90, 40)];
            odometerMainLabel.text = [NSString stringWithFormat:@"%@", service.odometer];//kofti imenuvana promenliva!!! ATTENZIONE!!!
            [serviceView addSubview: odometerMainLabel];
            
            
            UILabel* serviceType = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, applicationFrame.size.width - 10, 20)];
            serviceType.text = @"Вид на ремонтa";
            serviceType.textColor = [UIColor lightGrayColor];
            serviceType.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:serviceType];
            
            UILabel* serviceTypeMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, applicationFrame.size.width, 40)];
            serviceTypeMainLabel.text = [NSString stringWithFormat:@"%@", service.serviceType];
            [serviceView addSubview: serviceTypeMainLabel];
            
            
            
            UILabel* serviceDetails = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, applicationFrame.size.width - 10, 20)];
            serviceDetails.text = @"Детайли";
            serviceDetails.textColor = [UIColor lightGrayColor];
            serviceDetails.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:serviceDetails];
            
            UILabel* serviceDetailsMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, applicationFrame.size.width, 40)];
            serviceDetailsMainLabel.text = service.serviceDetail;
            [serviceView addSubview: serviceDetailsMainLabel];
            
            
            UILabel* serviceLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, applicationFrame.size.width - 10, 20)];
            serviceLocation.text = @"Къде ремонтирахте?";
            serviceLocation.textColor = [UIColor lightGrayColor];
            serviceLocation.font = [UIFont fontWithName:@"Arial" size:11];
            [serviceView addSubview:serviceLocation];
            
            UILabel* serviceLocationMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, applicationFrame.size.width, 40)];
            serviceLocationMainLabel.text = service.serviceLocation;
            [serviceView addSubview: serviceLocationMainLabel];
            
            
            [servicesArray addObject:serviceView];
            
        }
        //paging
        
        NSUInteger page = 0;
        for(UIView *view in servicesArray) {
            
            [servicesScrollView addSubview:view];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
        }
        servicesScrollView.contentSize = CGSizeMake(applicationFrame.size.width * [servicesArray count], applicationFrame.size.height - 44);
        
        self.view = servicesScrollView;
        
        
    }
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    UIBarButtonItem *addNewOilChange = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewService:)];
    [self.navigationItem setRightBarButtonItem:addNewOilChange];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
-(void)addNewService:(id)sender{
    MMNewServiceViewController* newService = [[MMNewServiceViewController alloc] initWithCar:carToEdit];
    [self.navigationController pushViewController:newService animated:YES];
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
    
    if (self.serviceEntities.count != 0){
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