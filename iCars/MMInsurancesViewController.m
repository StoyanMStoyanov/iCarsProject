//
//  MMInsurancesViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMInsurancesViewController.h"

@interface MMInsurancesViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)Car* carToEdit;
@property(nonatomic) CGPoint currentOffset;
@property (nonatomic) int page;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property (nonatomic, strong)NSMutableArray* insurancesArray;

@property (nonatomic, strong)UILabel* noInsurancesLabel;

@end

@implementation MMInsurancesViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
@synthesize insurancesArray;
@synthesize noInsurancesLabel;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Застраховки";
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
-(NSArray*)insuranceEntities{
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestInsurances = [[NSFetchRequest alloc] initWithEntityName:@"Insurance"];
    requestInsurances.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"insurancePaymentDate" ascending:NO];
    requestInsurances.sortDescriptors = @[sortByDate];
    NSError *errorRefuelings;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestInsurances error:&errorRefuelings] mutableCopy];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    
    
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *insuranceDetailsView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [insuranceDetailsView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [insuranceDetailsView setBackgroundColor:[UIColor whiteColor]];
    insuranceDetailsView.pagingEnabled = YES;
    insuranceDetailsView.showsHorizontalScrollIndicator = YES;//no
    insuranceDetailsView.showsVerticalScrollIndicator = YES;//no
    insuranceDetailsView.scrollsToTop = NO;
    insuranceDetailsView.delegate = self;
    
    if (self.insuranceEntities.count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noInsurancesLabel = [[UILabel alloc] init];
        self.noInsurancesLabel.textColor = [UIColor blackColor];
        self.noInsurancesLabel.backgroundColor = [UIColor whiteColor];
        
        self.noInsurancesLabel.text = @"Нямате въведени застраховки .";
        self.noInsurancesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noInsurancesLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noInsurancesLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noInsurancesLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noInsurancesLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noInsurancesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noInsurancesLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noInsurancesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noInsurancesLabel)]];
        
        self.view = noView;
    }
    else{
        self.insurancesArray = [[NSMutableArray alloc] init];
        UIView *insuranceView;
        for(Insurance *insurance in self.insuranceEntities) {
            insuranceView = [[UIView alloc] init];
            
            UILabel* fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
            fromLabel.text = @"ОТ:";
            fromLabel.textColor = [UIColor lightGrayColor];
            fromLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:fromLabel];
            
            UILabel* fromMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            fromMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:insurance.insurancePaymentDate]];
            [insuranceView addSubview: fromMainLabel];
            
            UILabel* toLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, applicationFrame.size.width - 10, 20)];
            toLabel.text = @"ДО:";
            toLabel.textColor = [UIColor lightGrayColor];
            toLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:toLabel];
            
            UILabel* toMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, applicationFrame.size.width - 10, 40)];
            //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            toMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:insurance.insuranceDueDate]];
            [insuranceView addSubview: toMainLabel];
            
            UILabel* insCompanyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, applicationFrame.size.width - 10, 20)];
            insCompanyLabel.text = @"Застрахователна компания";
            insCompanyLabel.textColor = [UIColor lightGrayColor];
            insCompanyLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:insCompanyLabel];
            
            UILabel* insCompanyMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 90, 40)];
            insCompanyMainLabel.text = [NSString stringWithFormat:@"%@",insurance.insuranceCompany];
            [insuranceView addSubview: insCompanyMainLabel];
            
            UILabel* insIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, applicationFrame.size.width - 10, 20)];
            insIdLabel.text = @"Номер на полица";
            insIdLabel.textColor = [UIColor lightGrayColor];
            insIdLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:insIdLabel];
            
            UILabel* insIdMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 90, 40)];
            insIdMainLabel.text = [NSString stringWithFormat:@"%@", insurance.insuranceID];
            [insuranceView addSubview: insIdMainLabel];
            
            UILabel* totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 110, applicationFrame.size.width - 10, 20)];
            totalCostLabel.text = @"Крайна цена";
            totalCostLabel.textColor = [UIColor lightGrayColor];
            totalCostLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:totalCostLabel];
            
            UILabel* totalCostMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 120, 90, 40)];
            totalCostMainLabel.text = [NSString stringWithFormat:@"%@", insurance.insuranceTotalCost];
            [insuranceView addSubview: totalCostMainLabel];
            
            
            UILabel* insTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, applicationFrame.size.width - 10, 20)];
            insTypeLabel.text = @"Тип застраховка";
            insTypeLabel.textColor = [UIColor lightGrayColor];
            insTypeLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:insTypeLabel];
            
            UILabel* insTypeMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, applicationFrame.size.width , 40)];
            insTypeMainLabel.text = [NSString stringWithFormat:@"%@", insurance.insuraneType];
            [insuranceView addSubview: insTypeMainLabel];
            
            UILabel* insDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, applicationFrame.size.width - 10, 20)];
            insDetailsLabel.text = @"Бележки";
            insDetailsLabel.textColor = [UIColor lightGrayColor];
            insDetailsLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [insuranceView addSubview:insDetailsLabel];
            
            UILabel* insDetailsMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, applicationFrame.size.width, 40)];
            insDetailsMainLabel.text = [NSString stringWithFormat:@"%@", insurance.insuranceNotes];
            [insuranceView addSubview: insDetailsMainLabel];
        
            [insurancesArray addObject:insuranceView];
        }
        
        //paging
        
        NSUInteger page = 0;
        for(UIView *view in insurancesArray) {
            
            [insuranceDetailsView addSubview:view];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
        }
        insuranceDetailsView.contentSize = CGSizeMake(applicationFrame.size.width * [insurancesArray count], applicationFrame.size.height - 44);
        
        
        
        [insuranceDetailsView setContentOffset:self.currentOffset];
        
        
        self.view = insuranceDetailsView;
    }
    
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    UIBarButtonItem *addNewInsurance = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewInsurance:)];
    [self.navigationItem setRightBarButtonItem:addNewInsurance];

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

-(void)addNewInsurance:(id)sender{
    MMNewInsuranceViewController* newInsurance = [[MMNewInsuranceViewController alloc] initWithCar:carToEdit];
    [self.navigationController pushViewController:newInsurance animated:YES];
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
    
    if (self.insuranceEntities.count != 0){
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