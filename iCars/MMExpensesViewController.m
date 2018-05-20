//
//  MMExpensesViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMExpensesViewController.h"

@interface MMExpensesViewController ()

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property (nonatomic, strong) NSArray* expenses;

@property (nonatomic, strong)NSMutableArray* expensesArray;

@property(nonatomic) CGPoint currentOffset;

@property (nonatomic) int page;

@property (nonatomic, strong) UILabel* noExpensesLabel;


@end

@implementation MMExpensesViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer, expensesArray, noExpensesLabel;
@synthesize carToEdit;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Разходи";
        carToEdit = car;
        
    }
    return self;
}
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
    
    if ([self.expenses count] == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noExpensesLabel = [[UILabel alloc] init];
        self.noExpensesLabel.textColor = [UIColor blackColor];
        self.noExpensesLabel.backgroundColor = [UIColor whiteColor];
        
        self.noExpensesLabel.text = @"Нямате въведени разходи.";
        self.noExpensesLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noExpensesLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noExpensesLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noExpensesLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noExpensesLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noExpensesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noExpensesLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noExpensesLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noExpensesLabel)]];
        
        self.view = noView;
    }
    else{
        expensesArray = [[NSMutableArray alloc] init];
        UIView *expenseView;
        for(Expense *expense in self.expenses) {
            expenseView = [[UIView alloc] init];
            
            UILabel* expenseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
            expenseDateLabel.text = @"Дата на разход";
            expenseDateLabel.textColor = [UIColor lightGrayColor];
            expenseDateLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [expenseView addSubview:expenseDateLabel];
            
            UILabel* expenseDateMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            expenseDateMainLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:expense.expenseDate]];
            [expenseView addSubview: expenseDateMainLabel];
            
            UILabel* expenseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, applicationFrame.size.width - 10, 20)];
            expenseTypeLabel.text = @"Тип разход";
            expenseTypeLabel.textColor = [UIColor lightGrayColor];
            expenseTypeLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [expenseView addSubview:expenseTypeLabel];
            
            UILabel* expenseTypeMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 90, 40)];
            expenseTypeMainLabel.text = [NSString stringWithFormat:@"%@",expense.expenseType];
            [expenseView addSubview: expenseTypeMainLabel];
            
            UILabel* totalCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, applicationFrame.size.width - 10, 20)];
            totalCostLabel.text = @"Сума на разход";
            totalCostLabel.textColor = [UIColor lightGrayColor];
            totalCostLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [expenseView addSubview:totalCostLabel];
            
            UILabel* totalCostMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, applicationFrame.size.width - 10, 40)];
            totalCostMainLabel.text = [NSString stringWithFormat:@"%@",expense.expenseTotalCost];
            [expenseView addSubview:totalCostMainLabel];
            
            
            UILabel* expenseLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, applicationFrame.size.width - 10, 20)];
            expenseLocationLabel.text = @"Местоположение";
            expenseLocationLabel.textColor = [UIColor lightGrayColor];
            expenseLocationLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [expenseView addSubview:expenseLocationLabel];
            
            UILabel* expenseLocationMainlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 90, 40)];
            expenseLocationMainlabel.text = [NSString stringWithFormat:@"%@", expense.expenseTotalCost];
            [expenseView addSubview: expenseLocationMainlabel];
            
            UILabel* expenseDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, applicationFrame.size.width - 10, 20)];
            expenseDetailsLabel.text = @"Детайли";
            expenseDetailsLabel.textColor = [UIColor lightGrayColor];
            expenseDetailsLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [expenseView addSubview:expenseDetailsLabel];
            
            UILabel* expenseDetailsMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 90, 40)];
            expenseDetailsMainLabel.text = expense.expenseDetails;
            [expenseView addSubview: expenseDetailsMainLabel];
            
            
            
            [expensesArray addObject:expenseView];
            
        }
        
        //paging
        
        NSUInteger page = 0;
        for(UIView *view in expensesArray) {
            
            [newCarView addSubview:view];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
        }
        newCarView.contentSize = CGSizeMake(applicationFrame.size.width * [expensesArray count], applicationFrame.size.height - 44);
        
        
        
        [newCarView setContentOffset:self.currentOffset];
        
        
        self.view = newCarView;
    }

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
-(NSArray*)expenses {
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestRefuelings = [[NSFetchRequest alloc] initWithEntityName:@"Expense"];
    requestRefuelings.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"expenseDate" ascending:NO];
    requestRefuelings.sortDescriptors = @[sortByDate];
    NSError *errorRefuelings;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestRefuelings error:&errorRefuelings] mutableCopy];

}
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
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
    
    if (self.expenses.count != 0){
        [scrollView scrollRectToVisible:bounds animated:animated];
    }
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
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self loadView];
    [self gotoPage:NO];
}

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
