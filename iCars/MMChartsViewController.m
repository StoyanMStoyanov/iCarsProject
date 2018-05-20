//
//  MMChartsViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMChartsViewController.h"


@interface MMChartsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    int numFuels;
    
    float a95qty;
    float a95PLUSqty;
    float a98qty;
    float a98PLUSqty;
    float dieselQty;
    float lpgQty;
    float cngQty;
    
    float allRefuelings;
    
    float a95percent;
    float a95plusPercent;
    float a98percent;
    float a98plusPercent;
    float dieselPerc;
    float lpgPerc;
    float cngPerc;
}

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@property(nonatomic, strong)PieView *pieView;
@property(nonatomic, strong)UITableView *colorStatsTableView;

@property (nonatomic, strong)UILabel* noRefuelingsLabel;

@property (nonatomic, strong)NSMutableArray* qties4check;
@property (nonatomic, strong)NSMutableArray* colorContainer;

@end

@implementation MMChartsViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
@synthesize colorStatsTableView, pieView;
@synthesize  noRefuelingsLabel;
@synthesize qties4check, colorContainer;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Диаграми";
        carToEdit = car;
        
        numFuels = 0;
        
        a95qty= 0;
        a95PLUSqty= 0;
        a98qty= 0;
        a98PLUSqty= 0;
        dieselQty= 0;
        lpgQty= 0;
        cngQty= 0;
        a95percent= 0;
        a95plusPercent= 0;
        a98percent= 0;
        a98plusPercent= 0;
        dieselPerc= 0;
        lpgPerc= 0;
        cngPerc= 0;
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
#pragma mark - ConfigureTableView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numFuels;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row selected");
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"color";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"color" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
//    self.colorContainer = [[NSMutableArray alloc] init];
//    
//    [self.colorContainer addObject:[UIColor lightGrayColor]];
//    [self.colorContainer addObject:[UIColor redColor]];
//    [self.colorContainer addObject:[UIColor greenColor]];
//    [self.colorContainer addObject:[UIColor blueColor]];
//    [self.colorContainer addObject:[UIColor yellowColor]];
//    [self.colorContainer addObject:[UIColor purpleColor]];
//    [self.colorContainer addObject:[UIColor brownColor]];
//
//    
    
   // if (![[qties4check objectAtIndex:indexPath.row] isEqualToString:@"0.000000"]) {
        //cell.backgroundColor = [self.pieView.colorContainer objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.qties4check objectAtIndex:indexPath.row];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
  //  NSLog(@"size q4c %lu", (unsigned long)[qties4check count]);
}

-(NSArray*)refuelingEntities{
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestRefuelings = [[NSFetchRequest alloc] initWithEntityName:@"Refueling"];
    requestRefuelings.predicate = [NSPredicate predicateWithFormat: @"car = %@", carToEdit];
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"refuelingDate" ascending:NO];
    requestRefuelings.sortDescriptors = @[sortByDate];
    NSError *errorRefuelings;
    return [[appDelegate.managedObjectContext executeFetchRequest:requestRefuelings error:&errorRefuelings] mutableCopy];
}
-(void)calculateEth{
    
    for (Refueling* refueling in self.refuelingEntities) {
        
        if ([refueling.fuelType isEqualToString:@"A95"]) {
           // [a95 addObject: refueling];
            a95qty += [refueling.refuelingQantity integerValue];
            
        }
        else if ([refueling.fuelType isEqualToString:@"A95+"]){
            //[a95plus addObject: refueling];
            a95PLUSqty += [refueling.refuelingQantity integerValue];
        }
        else if ([refueling.fuelType isEqualToString:@"A98"]){
            //[a98 addObject: refueling];
            a98qty += [refueling.refuelingQantity integerValue];
        }
        else if ([refueling.fuelType isEqualToString:@"A98+"]){
            //[a98plus addObject: refueling];
            a98PLUSqty += [refueling.refuelingQantity integerValue];
        }
        else if ([refueling.fuelType isEqualToString:@"Diesel"]){
            //[diesel addObject: refueling];
            dieselQty += [refueling.refuelingQantity integerValue];
        }
        else if ([refueling.fuelType isEqualToString:@"LPG"]){
            //[lpg addObject: refueling];
            lpgQty += [refueling.refuelingQantity integerValue];
        }
        else if ([refueling.fuelType isEqualToString:@"CNG"]){
            //[cng addObject: refueling];
            cngQty += [refueling.refuelingQantity integerValue];
        }
    }
    if(a95qty != 0) numFuels++;
    if(a95PLUSqty != 0) numFuels++;
    if(a98qty != 0) numFuels++;
    if(a98PLUSqty != 0) numFuels++;
    if(dieselQty != 0) numFuels++;
    if(lpgQty != 0) numFuels++;
    if(cngQty != 0) numFuels++;
    
//    NSLog(@"A95: %lu", (unsigned long)[a95 count]);
//    NSLog(@"A95+: %lu", (unsigned long)[a95plus count]);
//    NSLog(@"A98: %lu", (unsigned long)[a98 count]);
//    NSLog(@"A98+: %lu", (unsigned long)[a98plus count]);
//    NSLog(@"diesel: %lu", (unsigned long)[diesel count]);
//    NSLog(@"lpg: %lu", (unsigned long)[lpg count]);
//    NSLog(@"cng: %lu", (unsigned long)[cng count]);
    
    NSLog(@"broi na vidovete izpolzvani goriva %d", numFuels);
    
    
    
    
    
    
    allRefuelings = a95qty + a95PLUSqty + a98qty + a98PLUSqty + dieselQty + lpgQty + cngQty;
    
    a95percent = a95qty / allRefuelings * 100;
    a95plusPercent = a95PLUSqty / allRefuelings * 100;
    a98percent = a98qty / allRefuelings * 100;
    a98plusPercent = a98PLUSqty / allRefuelings * 100;
    dieselPerc = dieselQty / allRefuelings * 100;
    lpgPerc = lpgQty / allRefuelings * 100;
    cngPerc = cngQty / allRefuelings * 100;
    
   // [self.colorContainer addObject:[UIColor lightGrayColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor brownColor], nil];

    
    self.qties4check = [[NSMutableArray alloc] init];
    
    if(a95qty != 0)     [self.qties4check addObject:[NSString stringWithFormat:@"A95: %.2f %% (%.2f л.)", a95percent, a95qty]];
    if(a95PLUSqty != 0) [self.qties4check addObject:[NSString stringWithFormat:@"A95: %.2f %% (%.2f л.)", a95plusPercent, a95PLUSqty]];
    if(a98qty != 0)     [self.qties4check addObject:[NSString stringWithFormat:@"A98: %.2f %% (%.2f л.)", a98percent, a98qty]];
    if(a98PLUSqty != 0) [self.qties4check addObject:[NSString stringWithFormat:@"A98+: %.2f %% (%.2f л.)", a98plusPercent, a98PLUSqty]];
    if(dieselQty != 0)  [self.qties4check addObject:[NSString stringWithFormat:@"Дизел: %.2f %% (%.2f л.)", dieselPerc, dieselQty]];
    if(lpgQty != 0)     [self.qties4check addObject:[NSString stringWithFormat:@"Газ: %.2f %% (%.2f л.)", lpgPerc, lpgQty]];
    if(cngQty != 0)     [self.qties4check addObject:[NSString stringWithFormat:@"Метан: %.2f %% (%.2f л.)", cngPerc, cngQty]];
                                   
                                 
                                 
//    NSLog(@"QTY %@", [qties4check objectAtIndex: indexPath.row]);
//    //NSLog(@"size q4c %@", [qties4check count]);
//    
//    NSArray* qties = [[NSArray alloc] initWithObjects:,
//                      ,
//                      [NSString stringWithFormat:@"A98: %.2f %% (%.2f л.)", a98percent, a98qty],
//                      [NSString stringWithFormat:@"A98+: %.2f %% (%.2f л.)", a98plusPercent, a98PLUSqty],
//                      [NSString stringWithFormat:@"Дизел: %.2f %% (%.2f л.)", dieselPerc, dieselQty],
//                      [NSString stringWithFormat:@"Газ: %.2f %% (%.2f л.)", lpgPerc, lpgQty],
//                      [NSString stringWithFormat:@"Метан: %.2f %% (%.2f л.)", cngPerc, cngQty], nil];
//    

    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *newCarView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [newCarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [newCarView setBackgroundColor:[UIColor whiteColor]];
    [newCarView setAlwaysBounceVertical:YES];
    [newCarView setAlwaysBounceHorizontal:NO];
    [newCarView setScrollEnabled:YES];
    
    if (self.refuelingEntities.count == 0){
        
        UIView* noView= [[UIView alloc] initWithFrame:applicationFrame];
        [noView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [noView setBackgroundColor:[UIColor whiteColor]];
        
        
        self.noRefuelingsLabel = [[UILabel alloc] init];
        self.noRefuelingsLabel.textColor = [UIColor blackColor];
        self.noRefuelingsLabel.backgroundColor = [UIColor whiteColor];
        
        self.noRefuelingsLabel.text = @"Нямате въведени зареждания.";
        self.noRefuelingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noRefuelingsLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noRefuelingsLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noRefuelingsLabel.textAlignment = NSTextAlignmentCenter;
        [noView addSubview: self.noRefuelingsLabel];
        
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noRefuelingsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noRefuelingsLabel)]];
        [noView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noRefuelingsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noRefuelingsLabel)]];
        
        self.view = noView;
    }
    else{
        [self calculateEth];
        
        self.pieView = [[PieView alloc] initWithFrame:CGRectMake(0, 5, applicationFrame.size.width, applicationFrame.size.height/2)];
        self.pieView.sliceValues = [NSArray arrayWithObjects:@(a95percent), @(a95plusPercent), @(a98percent), @(a98plusPercent), @(dieselPerc),  @(lpgPerc), @(cngPerc), nil];
        
        [newCarView addSubview:self.pieView];
        
        self.colorStatsTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, applicationFrame.size.height/2 + 10, applicationFrame.size.width, applicationFrame.size.height/2)];
        self.colorStatsTableView.separatorColor = [UIColor clearColor];
        [self.colorStatsTableView setBackgroundColor:[UIColor clearColor]];
        
        self.colorStatsTableView.scrollEnabled = NO;
        [self.colorStatsTableView setDataSource: self];
        [self.colorStatsTableView setDelegate: self];
        [self.colorStatsTableView registerClass:[MMCarCustomCellTableView class] forCellReuseIdentifier:@"color"];

        [newCarView addSubview: self.colorStatsTableView];
        
         self.view = newCarView;

        
    }
    //[newCarView setContentSize:CGSizeMake(applicationFrame.size.width, CGRectGetMaxY(self.colorStatsTableView.frame) + 65)];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"]style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    
   
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
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        self.pieView.frame = CGRectMake(0, 0, applicationFrame.size.width/2, applicationFrame.size.height);
        self.colorStatsTableView.frame = CGRectMake(applicationFrame.size.width/2 + 15, 0, applicationFrame.size.width/2, applicationFrame.size.height);
    }
    else{
        self.pieView.frame = CGRectMake(0, 5, applicationFrame.size.width, applicationFrame.size.height/2);
        self.colorStatsTableView.frame = CGRectMake(0, applicationFrame.size.height/2 + 10, applicationFrame.size.width, applicationFrame.size.height/2);
    }
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