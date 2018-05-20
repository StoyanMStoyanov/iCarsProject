//
//  MMAddNewCarViewController.m
//  iCars
//
//  Created by Emilian Parvanov on 2/12/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#import "MMAddNewCarViewController.h"
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@interface MMAddNewCarViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isDropBrands;
    BOOL isDropModels;
}
@property (nonatomic, strong) UILabel* licenseTagLabel;
@property (nonatomic, strong) UITextField* licenseTagTextField;

@property(nonatomic, strong)UILabel* brandLabel;
@property(nonatomic, strong)UIButton* chooseBrandButton;
@property(nonatomic, strong)UITableView *carBrandsTableView;
@property(nonatomic, strong)NSMutableArray *carBrandsArray;
@property(nonatomic, strong)NSString *chosenBrandString;

@property(nonatomic, strong)UILabel* modelLabel;
@property(nonatomic, strong)UIButton* chooseModelButton;
@property(nonatomic, strong)UITableView *carModelTableView;
@property(nonatomic, strong)NSMutableArray *carModelsArray;
@property(nonatomic, strong)NSString *chosenModelString;

@property (nonatomic, strong) UILabel* currentOdometerLabel;
@property (nonatomic, strong) UITextField* currentOdometerTextField;

@property (nonatomic, strong) UILabel* fuelTankMainLabel;
@property (nonatomic, strong) UITextField* fuelTankMainTextField;

@property (nonatomic, strong) UILabel* fuelTankLPGLabel;
@property (nonatomic, strong) UITextField* fuelTankLPGTextField;

@property (nonatomic, strong) UILabel* fuelTankCNGLabel;
@property (nonatomic, strong) UITextField* fuelTankCNGTextField;

@end
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@implementation MMAddNewCarViewController
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@synthesize licenseTagLabel, licenseTagTextField;
@synthesize brandLabel, chooseBrandButton, carBrandsTableView, carBrandsArray, chosenBrandString;
@synthesize modelLabel, chooseModelButton, carModelTableView, carModelsArray, chosenModelString;
@synthesize currentOdometerLabel, currentOdometerTextField;
@synthesize fuelTankMainLabel, fuelTankMainTextField;
@synthesize fuelTankLPGLabel, fuelTankLPGTextField;
@synthesize fuelTankCNGLabel, fuelTankCNGTextField;
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - View CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Нова Кола";
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
    
    //licenseTag label + textField
    
    self.licenseTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, applicationFrame.size.width, 30)];
    self.licenseTagLabel.text = @"Регистрационен номер";
    self.licenseTagLabel.textColor = [UIColor grayColor];
    self.licenseTagLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.licenseTagLabel];
    
    self.licenseTagTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.licenseTagLabel.frame) + 5, applicationFrame.size.width - 10, 30)];
    [self.licenseTagTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.licenseTagTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.licenseTagTextField setDelegate:self];
    self.licenseTagTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [newCarView addSubview:self.licenseTagTextField];
    
    //carMake label + button + tableView
    
    self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.licenseTagTextField.frame) + 5, applicationFrame.size.width, 30)];
    self.brandLabel.text = @"Марка";
    self.brandLabel.textColor = [UIColor grayColor];
    self.brandLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.brandLabel];
    
    self.chooseBrandButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.brandLabel.frame), 150, 30)];
    [self.chooseBrandButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.chooseBrandButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.chooseBrandButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.chooseBrandButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.chooseBrandButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.chooseBrandButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
    [self.chooseBrandButton addTarget:self action: @selector(chooseCarBrand:) forControlEvents:UIControlEventTouchUpInside];
    [newCarView addSubview:self.chooseBrandButton];
    
    self.carBrandsTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.brandLabel.frame) + 25, 70, 0) style:UITableViewStylePlain];
    self.carBrandsTableView.backgroundColor = [UIColor grayColor];
    self.carBrandsTableView.dataSource = self;
    self.carBrandsTableView.delegate = self;
    [newCarView addSubview:self.carBrandsTableView];
    self.carBrandsTableView.layer.zPosition = MAXFLOAT;
    
    
    //carModel label + button + tableView
 
    self.modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.chooseBrandButton.frame) + 5, applicationFrame.size.width, 30)];
    self.modelLabel.text = @"Модел";
    self.modelLabel.textColor = [UIColor grayColor];
    self.modelLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.modelLabel];
    
    self.chooseModelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.modelLabel.frame), 150, 30)];
    [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateNormal];
    [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateApplication];
    [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
    [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateSelected];
    [self.chooseModelButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
    self.chooseModelButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
    [self.chooseModelButton addTarget:self action: @selector(chooseCarModel:) forControlEvents:UIControlEventTouchUpInside];
    [newCarView addSubview:self.chooseModelButton];
    
    self.carModelTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.modelLabel.frame) + 25, 70, 0) style:UITableViewStylePlain];
    self.carModelTableView.backgroundColor = [UIColor grayColor];
    self.carModelTableView.dataSource = self;
    self.carModelTableView.delegate = self;
    [newCarView addSubview:self.carModelTableView];
    self.carModelTableView.layer.zPosition = MAXFLOAT - 1;
    
    //currentOdometer label + textField
    
    self.currentOdometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.chooseModelButton.frame) + 5, applicationFrame.size.width, 30)];
    self.currentOdometerLabel.text = @"Текущ пробег";
    self.currentOdometerLabel.textColor = [UIColor grayColor];
    self.currentOdometerLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.currentOdometerLabel];
    
    self.currentOdometerTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.currentOdometerLabel.frame) + 5, applicationFrame.size.width - 10, 30)];
    [self.currentOdometerTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.currentOdometerTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.currentOdometerTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.currentOdometerTextField setDelegate:self];
    [self.currentOdometerTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [newCarView addSubview:self.currentOdometerTextField];
    
    //fuelTankMain label + textField
    
    self.fuelTankMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.currentOdometerTextField.frame) + 5, applicationFrame.size.width, 30)];
    self.fuelTankMainLabel.text = @"Обем на резервоара(л.)";
    self.fuelTankMainLabel.textColor = [UIColor grayColor];
    self.fuelTankMainLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.fuelTankMainLabel];
    
    self.fuelTankMainTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTankMainLabel.frame) + 5, applicationFrame.size.width / 4, 30)];
    [self.fuelTankMainTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.fuelTankMainTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.fuelTankMainTextField setDelegate:self];
    [self.fuelTankMainTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [newCarView addSubview:self.fuelTankMainTextField];
    
    //fuelTankLPG label + textField
    
    self.fuelTankLPGLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTankMainTextField.frame) + 5, applicationFrame.size.width, 30)];
    self.fuelTankLPGLabel.text = @"Обем на газова бутилка(л.)";
    self.fuelTankLPGLabel.textColor = [UIColor grayColor];
    self.fuelTankLPGLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.fuelTankLPGLabel];
    
    self.fuelTankLPGTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTankLPGLabel.frame) + 5, applicationFrame.size.width / 4, 30)];
    [self.fuelTankLPGTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.fuelTankLPGTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.fuelTankLPGTextField setDelegate:self];
    [self.fuelTankLPGTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [newCarView addSubview:self.fuelTankLPGTextField];
    
    //fuelTankCNG label + textField
 
    self.fuelTankCNGLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTankLPGTextField.frame) + 5, applicationFrame.size.width, 30)];
    self.fuelTankCNGLabel.text = @"Обем на метанова бутилка(кг.)";
    self.fuelTankCNGLabel.textColor = [UIColor grayColor];
    self.fuelTankCNGLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    [newCarView addSubview:self.fuelTankCNGLabel];
    
    self.fuelTankCNGTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.fuelTankCNGLabel.frame) + 5, applicationFrame.size.width / 4, 30)];
    [self.fuelTankCNGTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.fuelTankCNGTextField setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.fuelTankCNGTextField setDelegate:self];
    [self.fuelTankCNGTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [newCarView addSubview:self.fuelTankCNGTextField];
    
    //VERY IMPORTANT FOR THE PROPER FUNCTIONALITY OF RDVKeyboardAvoidingScrollView
    [newCarView setContentSize:CGSizeMake(applicationFrame.size.width, CGRectGetMaxY(self.fuelTankCNGTextField.frame) + 55)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStyleBordered target:self action:@selector(saveCarButtonAction:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    self.view = newCarView;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - SaveButton CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)saveCarButtonAction:(id)sender{
    NSLog(@"nova kola");
    if (self.chosenBrandString.length == 0 || self.chosenModelString.length == 0 || self.licenseTagTextField.text.length == 0 || self.currentOdometerTextField.text.length == 0  ) {
        UIAlertView *notEnoughCarInfo = [[UIAlertView alloc] initWithTitle:@"Недостатъчна информация!" message:@"Рег.номер, пробег, марка и модел са задължинелни полета!!!"delegate:sender cancelButtonTitle:@"Опитайте отново" otherButtonTitles:nil];
        [notEnoughCarInfo show];
    }
    else{
        MMAppDelegate* appDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
        Car* newCar = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:appDelegate.managedObjectContext];
        newCar.make = self.chosenBrandString;
        newCar.model = self.chosenModelString;
        newCar.licenseTag = self.licenseTagTextField.text;
        newCar.odometer = @([self.currentOdometerTextField.text integerValue]);
        newCar.fuelTankMain = @([self.fuelTankMainTextField.text integerValue]);
        if (self.fuelTankLPGTextField.text.length != 0) {
            newCar.fuelTankLPG = @([self.fuelTankLPGTextField.text integerValue]);
        }
        if (self.fuelTankCNGTextField.text.length != 0) {
            newCar.fuelTankCNG = @([self.fuelTankCNGTextField.text integerValue]);
        }
        
        // Save the object to MOC
        NSError* newCarError = nil;
        if (![appDelegate.managedObjectContext save:&newCarError]) {
            NSLog(@"Error creating new car%@ %@", newCarError, [newCarError localizedDescription]);
        }
        else{
            NSLog(@"dobavihte nova kolaaaa");
        }
        
        NSError *error01 = nil;
        // Save the object to persistent store
        if (![appDelegate.managedObjectContext save:&error01]) {
            NSLog(@"Can't Save! %@ %@", error01, [error01 localizedDescription]);
        }
        
        //push to carList
        MMCarListViewController* carList = [[MMCarListViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:carList animated:YES];
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - DropDownMenus CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)chooseCarBrand:(id)sender{
   
    if (!isDropBrands) {
        [self.carBrandsTableView reloadData];
        [UIView animateWithDuration:0.1 animations:^{
            
            self.carBrandsTableView.frame = CGRectMake(40, CGRectGetMaxY(self.brandLabel.frame) + 25, 200, 150);
            
            //ПРЕЧАТ ПРИ СЕЛЕКТИРАНЕ, ЗАЩОТО АКТИВИРАТ VIEW-ТО ПОД ИЗБРАНАТА КЛЕТКА!!!!!!!!!
            self.chooseModelButton.hidden = YES;
            self.currentOdometerTextField.hidden = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                self.carModelTableView.frame = CGRectMake(40, CGRectGetMaxY(self.modelLabel.frame) + 25, 200, 0);
                NSLog(@"pribra se ");
                
            }];
        } completion:^(BOOL finished) {
            NSLog(@"poqvi se");
        }];
    }
    else{
        [UIView animateWithDuration:0.1 animations:^{
            self.carBrandsTableView.frame = CGRectMake(40, CGRectGetMaxY(self.brandLabel.frame) + 25, 200, 0);
            NSLog(@"pribra se ");
        }];
        
        //ВРЪЩАМЕ СКРИТИТЕ ЕЛЕМЕНТИ!!!
        self.chooseModelButton.hidden = NO;
        self.currentOdometerTextField.hidden = NO;
    }
   isDropBrands = !isDropBrands;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)chooseCarModel:(id)sender{
    if (self.chosenBrandString) {

        if (!isDropModels) {
            [self.carModelTableView reloadData];
            [UIView animateWithDuration:0.01 animations:^{
                self.carModelTableView.frame = CGRectMake(40, CGRectGetMaxY(self.modelLabel.frame) + 25, 200, 150);
    
                self.currentOdometerTextField.hidden = YES;
                self.fuelTankMainTextField.hidden = YES;

            } completion:^(BOOL finished) {
                NSLog(@"poqvi se");
            }];
        }
        else{
            [UIView animateWithDuration:0.01 animations:^{
                self.carModelTableView.frame = CGRectMake(40, CGRectGetMaxY(self.modelLabel.frame) + 25, 200, 0);
                NSLog(@"pribra se ");
            
            }];
            self.currentOdometerLabel.hidden = NO;
            self.fuelTankMainLabel.hidden = NO;
        }
        isDropModels = !isDropModels;
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - BrandsAndModelsTableViews CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.carBrandsTableView) {
        return self.carBrandsArray.count;
    }
    else return self.carModelsArray.count;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.carBrandsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carMakeCell"];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carMakeCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0f];
        }
        cell.textLabel.text = self.carBrandsArray[indexPath.row];
        return cell;
    }
    
    else if(tableView == self.carModelTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carModelCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carModelCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0f];
        }
        cell.textLabel.text = self.carModelsArray[indexPath.row];
        return cell;
        
    }
    else return nil;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //BrandsT@bleView
    
    if (tableView == self.carBrandsTableView) {

        [UIView animateWithDuration:0.3 animations:^{
            self.carBrandsTableView.frame = CGRectMake(40, CGRectGetMaxY(self.brandLabel.frame) + 25, 200, 0);
            [self.chooseBrandButton setTitle: self.carBrandsArray[indexPath.row] forState: UIControlStateNormal];
            [self.chooseBrandButton setTitle: self.carBrandsArray[indexPath.row] forState: UIControlStateApplication];
            [self.chooseBrandButton setTitle: self.carBrandsArray[indexPath.row] forState: UIControlStateHighlighted];
            [self.chooseBrandButton setTitle: self.carBrandsArray[indexPath.row] forState: UIControlStateSelected];
        }];
        
        self.chosenBrandString = [NSString stringWithFormat:@"%@", self.carBrandsArray[indexPath.row]];
        
        if ([self.chosenBrandString isEqualToString:@"Opel"]) {
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"Adam", @"Admiral", @"Agila", @"Ampera", @"Antara", @"Arena", @"Ascona", @"Astra", @"Calibra", @"Cascada", @"Corsa", @"Kadett", @"Monza", @"Omega", @"Record", @"Tigra", @"Vectra", nil];
        }
        if ([self.chosenBrandString isEqualToString:@"VW"]){
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"Polo", @"Passat", @"Lupo", @"Jetta", @"Golf", @"Corrado", @"Vento", @"Santana", @"Amarok", nil];
        }
        if ([self.chosenBrandString isEqualToString:@"Porsche"]){
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"Cayenne", @"911", @"Boxster", @"912", @"Panamera", @"Carrera", @"Cayman", nil];
        }
        if ([self.chosenBrandString isEqualToString:@"Mercedes-Benz"]){
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"Actros", @"C-klasse", @"E-klasse", @"S-klasse", @"R-klasse", @"SL-klasse", @"G-klasse", nil];
        }
        if ([self.chosenBrandString isEqualToString:@"Audi"]){
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"A1", @"A2", @"A3", @"A4", @"A5", @"A6", @"A7", @"A8", @"S1", @"S/RS3", @"S/RS5", @"S/RS6", @"S7", @"S8", @"Q3", @"Q5", @"Q7", @"R8", @"80", @"100", @"200", @"90", @"TT", nil];
        }
        if ([self.chosenBrandString isEqualToString:@"BMW"]){
            self.carModelsArray = [NSMutableArray arrayWithObjects: @"1er", @"2er", @"3er", @"4er", @"5er", @"6er", @"7er", @"8er", @"Z3", @"Z4", @"1er ///M-coupe", @"///M3", @"///M5", @"///M6",  @"X1", @"X2", @"X5", @"X6", nil];
        }
        
        isDropBrands = !isDropBrands;
        NSLog(@"chosen brand: %@", self.chosenBrandString);
        
        //ВРЪЩАМЕ СКРИТИТЕ ЕЛЕМЕНТИ!!!
        self.chooseModelButton.hidden = NO;
        self.currentOdometerTextField.hidden = NO;

        //ПРИ ПРОМЯНА НА МАРКАТА, ДА НЕ ОСТАВА ИЗБРАН МОДЕЛ ОТ ДРУГА МАРКА
        [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateNormal];
        [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateApplication];
        [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateHighlighted];
        [self.chooseModelButton setTitle: @"Изберете" forState: UIControlStateSelected];
    }
    
    //ModelsTableView
    
    else if(tableView == self.carModelTableView){
        [UIView animateWithDuration:0.3 animations:^{
            self.carModelTableView.frame = CGRectMake(40, CGRectGetMaxY(self.brandLabel.frame) + 25, 200, 0);
            [self.chooseModelButton setTitle: self.carModelsArray[indexPath.row] forState: UIControlStateNormal];
            [self.chooseModelButton setTitle: self.carModelsArray[indexPath.row] forState: UIControlStateApplication];
            [self.chooseModelButton setTitle: self.carModelsArray[indexPath.row] forState: UIControlStateHighlighted];
            [self.chooseModelButton setTitle: self.carModelsArray[indexPath.row] forState: UIControlStateSelected];
        }];
        
        self.chosenModelString = [NSString stringWithFormat:@"%@", self.carModelsArray[indexPath.row]];
        isDropModels = !isDropModels;
        NSLog(@"chosen model: %@", self.chosenModelString);
        
        self.chooseModelButton.hidden = NO;
        self.currentOdometerTextField.hidden = NO;
        self.fuelTankMainTextField.hidden = NO;
    }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data CONFIG
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[[self navigationController] navigationBar] setTranslucent:NO];
    isDropBrands = NO;
    isDropModels = NO;
    self.chosenBrandString = nil;
    
    self.carBrandsArray = [[NSMutableArray alloc] init];
    [self.carBrandsArray addObject:@"Opel"];
    [self.carBrandsArray addObject:@"VW"];
    [self.carBrandsArray addObject:@"Mercedes-Benz"];
    [self.carBrandsArray addObject:@"BMW"];
    [self.carBrandsArray addObject:@"Porsche"];
    [self.carBrandsArray addObject:@"Audi"];
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