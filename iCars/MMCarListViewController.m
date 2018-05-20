//
//  MMCarListViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/8/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMCarListViewController.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface MMCarListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView* carListTableView;

@property (nonatomic, strong) UICollectionView* carListCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* flowLayout;

@property (nonatomic, strong) UILabel* noCarsLabel;

@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMCarListViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize carListTableView, carListCollectionView, flowLayout, noCarsLabel;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Моите коли";
    }
    return self;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureCollectionView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.carsFetchResultsController.sections[section] numberOfObjects];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(320, 160);
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"car selected");
    MMCarMenuViewController* carMenuVC = [[MMCarMenuViewController alloc] initWithCar:[self.carsFetchResultsController objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:carMenuVC animated:YES];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CarCustomCellCollectionView";
    MMCarCustomCellCollectionView *cell = (MMCarCustomCellCollectionView *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarCustomCellCollectionView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Car* car = [self.carsFetchResultsController objectAtIndexPath:indexPath];
    
    cell.carMakeLabel.text = car.make;
    cell.carModelLabel.text = car.model;
    cell.licenseTag.text = car.licenseTag;
    
    if ([car.make  isEqual: @"VW"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"vw_logo.jpg"];
    }
    else if ([car.make  isEqual: @"Opel"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"opel_logo.jpg"];
    }
    
    else if ([car.make  isEqual: @"Mercedes-Benz"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"mercedes_logo.jpg"];
    }
    else if ([car.make  isEqual: @"BMW"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"bmw_logo.png"];
    }
    else if ([car.make  isEqual: @"Porsche"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"porsche_logo.jpg"];
    }
    if ([car.make  isEqual: @"Audi"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"audi_logo.png"];
    }
    return cell;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureTableView
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.carsFetchResultsController.sections[section] numberOfObjects];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row selected");
    MMCarMenuViewController* carMenuVC = [[MMCarMenuViewController alloc] initWithCar:[self.carsFetchResultsController objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:carMenuVC animated:YES];
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CarCustomCellTableView";
    MMCarCustomCellTableView *cell = (MMCarCustomCellTableView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarCustomCellTableView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Car* car = [self.carsFetchResultsController objectAtIndexPath:indexPath];
    
    cell.carMakeLabel.text = car.make;
    cell.carModelLabel.text = car.model;
    cell.licenseTag.text = car.licenseTag;
    
    if ([car.make  isEqual: @"VW"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"vw_logo.jpg"];
    }
    if ([car.make  isEqual: @"Opel"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"opel_logo.jpg"];
    }
    
    if ([car.make  isEqual: @"Mercedes-Benz"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"mercedes_logo.jpg"];
    }
    
    if ([car.make  isEqual: @"BMW"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"bmw_logo.png"];
    }
    
    if ([car.make  isEqual: @"Porsche"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"porsche_logo.jpg"];
    }
    if ([car.make  isEqual: @"Audi"]) {
        cell.carMakeLogo.image = [UIImage imageNamed:@"audi_logo.png"];
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
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* requestAp = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSError *carsError;
    NSArray *entitiesCArs = [[appDelegate.managedObjectContext executeFetchRequest:requestAp error:&carsError] mutableCopy];
    if (entitiesCArs.count == 0){
        
        self.noCarsLabel = [[UILabel alloc] init];
        self.noCarsLabel.textColor = [UIColor blackColor];
        self.noCarsLabel.backgroundColor = [UIColor whiteColor];
        
        self.noCarsLabel.text = @"Нямате въведени автомобили.";
        self.noCarsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            self.noCarsLabel.font = [UIFont fontWithName:@"Arial" size: 15.0f];
        }
        else{
            self.noCarsLabel.font = [UIFont fontWithName:@"Arial" size: 30.0f];
        }
        self.noCarsLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview: self.noCarsLabel];
        
        [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[noCarsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noCarsLabel)]];
        [mainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[noCarsLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noCarsLabel)]];
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
    
        self.carListTableView =[[UITableView alloc] initWithFrame: carViewFrame];
        [self.carListTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.carListTableView setBackgroundColor:[UIColor clearColor]];
        [self.carListTableView setDataSource: self];
        [self.carListTableView setDelegate: self];
        [self.carListTableView registerClass:[MMCarCustomCellTableView class] forCellReuseIdentifier:@"CarCustomCellTableView"];
    
        [mainView addSubview: self.carListTableView];
    }
    else{

         self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
         [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
         self.flowLayout.headerReferenceSize = CGSizeMake(0, 10);
         self.flowLayout.minimumInteritemSpacing = 0.0f;

         self.carListCollectionView = [[UICollectionView alloc] initWithFrame: carViewFrame collectionViewLayout: self.flowLayout];
         [self.carListCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
         [self.carListCollectionView setBackgroundColor:[UIColor clearColor]];
         self.carListCollectionView.bounces = YES;
         [self.carListCollectionView setDataSource: self];
         [self.carListCollectionView setDelegate: self];
         [self.carListCollectionView setShowsHorizontalScrollIndicator:NO];
         [self.carListCollectionView setShowsVerticalScrollIndicator:NO];
         [self.carListCollectionView registerClass:[MMCarCustomCellCollectionView class] forCellWithReuseIdentifier:@"CarCustomCellCollectionView"];
    
         [mainView addSubview: self.carListCollectionView];
    }
    
    //set tabbar buttons
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style: UIBarButtonItemStyleBordered target:self action:@selector(addButtonAction:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style: UIBarButtonItemStyleBordered target:self action:@selector(settingsButtonAction:)];
    [self.navigationItem setRightBarButtonItem:settingsButton];
    
    //set the mainView
    self.view = mainView;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureTAbbarBUttonActionS
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)addButtonAction:(id)sender {
    NSLog(@"nova kola");
    MMAddNewCarViewController* addNewCarVC = [[MMAddNewCarViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:addNewCarVC animated:YES];

}
-(void)settingsButtonAction:(id)sender {
    NSLog(@"settings kola");
    
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureFetchResultsContrller
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSFetchedResultsController*)carsFetchResultsController{
    if (_carsFetchResultsController) {
        return _carsFetchResultsController;
    }
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSSortDescriptor* sortByPrice = [[NSSortDescriptor alloc] initWithKey:@"make" ascending:YES];
    request.sortDescriptors = @[sortByPrice];
    
    MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
    _carsFetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _carsFetchResultsController;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureData
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSError *error;
    [self.carsFetchResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Perform fetch error: %@",error);
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - ConfigureRotation
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