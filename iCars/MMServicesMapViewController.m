//
//  MMServicesMapViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/15/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import "MMServicesMapViewController.h"
#import <MapKit/MapKit.h>

@interface MMServicesMapViewController ()

@property(nonatomic, strong)Car* carToEdit;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray* viewControllersContainer;
@property (nonatomic, strong) NSMutableData* response;
@property (nonatomic, strong) NSString* selectedTitle;
@property (nonatomic, strong) NSString* selectedAddress;

@end

@implementation MMServicesMapViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize optionIndices, viewControllersContainer;
@synthesize carToEdit;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithCar:(Car*)car
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Сервизи";
        carToEdit = car;
    }
    return self;
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
    
    MKMapView *services = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height)];
    services.delegate = self;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(42.696552, 23.32601), 10000, 10000);
    [services setRegion:[services regionThatFits:region] animated:YES];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *hamburger = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burger_logo"] style: UIBarButtonItemStyleBordered target:self action:@selector(showHamburger:)];
    [self.navigationItem setLeftBarButtonItem:hamburger];
    
    self.view = services;
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"failed request");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *err = nil;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: self.response options: NSJSONReadingMutableContainers error: &err];
    NSArray *results = [jsonDict objectForKey:@"results"];
    for(NSDictionary *item in results) {
        NSString* name = [item objectForKey:@"name"];
        CGFloat x = [[[[item objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        CGFloat y = [[[[item objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        NSString* address = [item objectForKey:@"formatted_address"];
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
        annotation.subtitle = address;
        annotation.coordinate = CLLocationCoordinate2DMake(x, y);
        annotation.title = name;
        MKMapView* mapView = (MKMapView*) self.view;
        [mapView addAnnotation:annotation];
    }
}
// return selected pin
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.selectedTitle =  [[mapView.selectedAnnotations lastObject] title];
    self.selectedAddress = [[mapView.selectedAnnotations lastObject] subtitle];
}
// pin animation
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mainPin"];
    [pinView setPinColor:MKPinAnnotationColorGreen];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton* annotationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [annotationButton setTitle:@"Поправи" forState:UIControlStateNormal];
    annotationButton.frame = CGRectMake(0, 0, 70, 40);
    [annotationButton addTarget:self action:@selector(newService) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = annotationButton;
    
    return pinView;
}
-(void)newService {
    MMNewServiceViewController* newService = [[MMNewServiceViewController alloc] init];
    newService.selectedTitle = self.selectedTitle;
    newService.selectedAddress = self.selectedAddress;
    [self.navigationController pushViewController:newService animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    NSString *url=@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=car%20repair%20shops%20in%20Sofia&sensor=true&key=AIzaSyBVYq2PvGlNrSIewHboBOdDJqULO3Ff4XM";
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    
    
    
    
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