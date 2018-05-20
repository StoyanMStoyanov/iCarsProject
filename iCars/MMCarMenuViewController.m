//
//  MMCarMenuViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMCarMenuViewController.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface MMCarMenuViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)Car* carToShow;

@property (nonatomic, strong) UICollectionView* carMenuCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* carMenuFlowLayout;

@property (nonatomic, strong) NSArray* icons;
@property (nonatomic, strong) NSArray* iconLabels;
@property (nonatomic, strong) NSArray* viewControllersContainer;

@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMCarMenuViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize carToShow;
@synthesize carMenuFlowLayout, carMenuCollectionView;
@synthesize iconLabels, icons, viewControllersContainer;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"%@", car.licenseTag];
        carToShow = car;
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureCollectionView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.iconLabels.count;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(152, 173);
    //return CGSizeMake(152/2, 173/2);
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"menu item selected/activated+-");
    
    //ebasi dobroto ;] ;] ;] ;]
    Class vcClass = NSClassFromString([self.viewControllersContainer objectAtIndex:indexPath.row]);
    id someVC = [[vcClass alloc] initWithCar: carToShow];
    [self.navigationController pushViewController:someVC animated:YES];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CarMenuIcon";
    MMCarMenuIcon *cell = (MMCarMenuIcon *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarMenuIcon" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.carMenuIconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.icons objectAtIndex:indexPath.row]]];
    cell.carMenuIconLabel.text = [self.iconLabels objectAtIndex:indexPath.row];
    NSRange rangeValue = [cell.carMenuIconLabel.text rangeOfString:@"?" options:NSCaseInsensitiveSearch];
    if(rangeValue.length > 0){
        cell.carMenuIconLabel.textColor = [UIColor redColor];
    }
    else{
        cell.carMenuIconLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureMainView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *mainView = [[UIView alloc] initWithFrame:applicationFrame];
    [mainView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat carViewWidth = roundf(applicationFrame.size.width);
    CGFloat carViewHeight = roundf(applicationFrame.size.height);
    CGRect carViewFrame = CGRectMake(0, 0, carViewWidth, carViewHeight);
    
     self.carMenuFlowLayout = [[UICollectionViewFlowLayout alloc] init];
     [self.carMenuFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
     self.carMenuFlowLayout.headerReferenceSize = CGSizeMake(0, 10);
     self.carMenuFlowLayout.minimumInteritemSpacing = 5.0f;
    
     self.carMenuCollectionView = [[UICollectionView alloc] initWithFrame: carViewFrame collectionViewLayout: self.carMenuFlowLayout];
     [self.carMenuCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
     [self.carMenuCollectionView setBackgroundColor:[UIColor clearColor]];
     self.carMenuCollectionView.bounces = YES;
     [self.carMenuCollectionView setDataSource: self];
     [self.carMenuCollectionView setDelegate: self];
     [self.carMenuCollectionView setShowsHorizontalScrollIndicator:NO];
     [self.carMenuCollectionView setShowsVerticalScrollIndicator:NO];
     [self.carMenuCollectionView registerClass:[MMCarMenuIcon class] forCellWithReuseIdentifier:@"CarMenuIcon"];
        
     [mainView addSubview: self.carMenuCollectionView];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *otherCars = [[UIBarButtonItem alloc] initWithTitle:@"Cars" style: UIBarButtonItemStyleBordered target:self action:@selector(otherCars:)];
    [self.navigationItem setLeftBarButtonItem:otherCars];

    //set the mainView
    self.view = mainView;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)otherCars:(id)sender{
    MMCarListViewController* carList = [[MMCarListViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:carList animated:YES];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view..
    
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    self.icons = [NSArray arrayWithObjects: @"refueling_logo.png",
                  @"refueling-pin_logo.png",//+gps
                                            @"oilChange_logo.jpg",
                                             @"services_logo.jpg",
                  @"services-pin_logo.jpg",//+gps
                                            @"reminders_logo.jpg",
                                             @"expenses_logo.png",
                                            @"insurance_logo.png",
                  @"insurance-pin_logo.png",//+gps
                                              @"summary_logo.png",
                                               @"charts_logo.png",nil];
    
    self.iconLabels = [NSArray arrayWithObjects: @"Зареждания",
                  @"Къде да заредим?",
                  @"Масло",
                  @"Поддръжка и ремонти",
                  @"Къде да поправим?",
                  @"Напомняния",
                  @"Разходи",
                  @"Застраховки",
                  @"Къде да застраховаме?",
                  @"Summary",
                  @"Диаграми",nil];
    
    self.viewControllersContainer = [NSArray arrayWithObjects: @"MMGasolineViewController",
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