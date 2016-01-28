//
//  BoilerInputTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
// ViewController to display input variables for Boiler Water Calculations.
// Implemented as a (static sectioned) TableViewController because management of the many fields is easier that way
// Note that most of thetable handling is set up statically in the interface builder, so no need to handle in code

#import "BoilerInputTableViewController.h"
#import "BoilerWaterModel.h"
#include "FieldNavigationLink.h"


@implementation BoilerInputTableViewController

// Object to hold boiler data
BoilerWaterModel *mBoilerModel;

// dictionary to hold fields navigation data, key is field name
NSMutableDictionary *mFieldDict ;

// curent navigation field
FieldNavigationLink *mCurrNavLink;


UIViewController * mSourceController;

//////////////////////////////////////////////////
// Template stuff (from superclass)
//////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"BoilerInputTableViewController.m viewDidLoad()");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    // create the model object
    mBoilerModel = [BoilerWaterModel sharedInstance];
    
    // load previous values
    [mBoilerModel restore];
    
    // update display
    [self loadFromModel:mBoilerModel];
    
    // register a gesture recogniser to detect if user touches the background
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    // create the keyboard accessory
    [self createInputAccessoryView];
    
    // setup the navigation 'chain'
    [self setupNavigation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidAppear:(BOOL)animated{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}


// control rotation handling. In this case, only allow landscape orientation
- (BOOL) shouldAutorotate {
    //if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    //{
    //    return YES;
    //} else {
    return NO;
    //}
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */






#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // logic for when a row is selected (nothing for now)
}



// handler for Done key on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    // release focus
    [theTextField resignFirstResponder];
    
    return YES;
}


// utility to position screen to the supplied input field
- (void) setFocus:(UITextField *)field {
    [field becomeFirstResponder];
}


// force view to scroll active field to the top of the screen
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"BoilerInputTableViewController: textFieldDidBeginEditing %@", textField.placeholder);
    
    // Now add input accessory view to the selected textfield.
    //[textField setInputAccessoryView:mKeyboardAccessory];
    [textField setInputAccessoryView:self.keyboardToolbar];
    
    // save the navigation link for this field
    [self setCurrLink:textField];
    
    // set input focus to this field
    [self setFocus:textField];
    
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"BoilerInputTableViewController: textFieldDidEndEditing %@", textField.placeholder);
    [textField resignFirstResponder];
}


// function(s) to clear keyboard if user taps the background

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"BoilerInputTableViewController: touchesBegan");
    [self.view endEditing:YES];
}


// function to clear keyboard if user taps the background
- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"BoilerInputTableViewController: backgroundTapped");
    [self.view endEditing:YES];
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    NSLog(@"BoilerInputTableViewController: touchesEnded");
    /*
     for (UIView* view in self.view.subviews) {
     if ([view isKindOfClass:[UITextField class]])
     [view resignFirstResponder];
     }
     */
    [self.view endEditing:YES];
}

////////////////////////////////////////////////
// create input accessory for augmenting keyboard navigation wirh prev/done/next buttons

-(void)createInputAccessoryView
{
    NSLog(@"BoilerInputTableViewController.createInputAccessoryView()");
    // create the toolbar
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.keyboardToolbar.barStyle = UIBarStyleDefault ;
    //self.keyboardToolbar.tintColor = [UIColor darkGrayColor];
    // set background to half intensity version of buttons
    self.keyboardToolbar.tintColor = [UIColor colorWithRed:1.0/255.0 green:27.0/255.0 blue:70.0/255.0 alpha:1];
    
    // create the buttons
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(gotoPrevTextfield)];
    
    UIBarButtonItem *nextButton     = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(gotoNextTextfield)];
    
    UIBarButtonItem *doneButton     = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(doneTyping)];
    
    UIBarButtonItem *flexibleSpace  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
    
    // WTP blue = R:1 G:55 B:141
    
    [previousButton setTintColor:[UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:141.0/255.0 alpha:1]];
    [nextButton     setTintColor:[UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:141.0/255.0 alpha:1]];
    [doneButton     setTintColor:[UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:141.0/255.0 alpha:1]];
    
    // add the buttons to the toolbar (the flexible space items move the other buttons to the left, centre and right
    [self.keyboardToolbar setItems:[NSArray arrayWithObjects: previousButton, flexibleSpace, doneButton, flexibleSpace, nextButton, nil] animated:NO];
    
}



-(void)doneTyping
{
    if (mCurrNavLink){
        NSLog(@"Done pressed");
        [mCurrNavLink.currField resignFirstResponder];
    } else {
        NSLog(@"doneTyping: current link is NULL");
    }
}



-(void)gotoPrevTextfield
{
    if (mCurrNavLink){
        NSLog(@"Prev pressed, moving to %@", mCurrNavLink.prevField.placeholder);
        [mCurrNavLink.currField resignFirstResponder];
        [self scrollToField:mCurrNavLink.prevField];
        [mCurrNavLink.prevField becomeFirstResponder];         // do this last because it could change mCurrNavLink
    } else {
        NSLog(@"gotoPrevTextfield: current link is NULL");
    }
}


-(void)gotoNextTextfield
{
    @try{
        if (mCurrNavLink){
            NSLog(@"Next pressed, moving to %@", mCurrNavLink.nextField.placeholder);
            [mCurrNavLink.currField resignFirstResponder];
            [self scrollToField:mCurrNavLink.nextField];
            [mCurrNavLink.nextField becomeFirstResponder];         // do this last because it could change mCurrNavLink
        } else {
            NSLog(@"gotoNextTextfield: current link is NULL");
        }
    }
    @catch (NSException *e){
        NSLog(@"gotoNextTextfield Exception: %@", e.reason);
        // TEMP DEBUG
        //[self dumpDictionary];
    }
    
}


// method to find the index of a row within a table
- (NSIndexPath *) findTableIndex:(UITextField *)textFld {
    // Get the cell in which the textfield is embedded
    id textFieldSuper = textFld;
    UITableViewCell *cell;
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        textFieldSuper = [textFieldSuper superview];
    }
    
    // Get that cell's index path
    NSIndexPath *indexPath;
    cell = (UITableViewCell *)textFieldSuper;
    
    //indexPath = [self.tableView indexPathForCell:cell];
    indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    //NSLog(@"findTableIndex.indexPath2:%@", indexPath);
    return indexPath;
}


// method to scroll the table to the row that contains the supplied text field
- (void) scrollToField:(UITextField *)textFld {
    
    // Get the cell's index path
    NSIndexPath *indexPath = [self findTableIndex:textFld];
    
    if (indexPath){
        // scroll the table to that index
        NSLog(@"Scrolling to section:%li row:%li", (long)indexPath.section, (long)indexPath.row);
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        NSLog(@"no index returned, not scrolling");
    }
}


//////////////////////////////////////////////////
// Functions for handling this View
//////////////////////////////////////////////////

// function to load dictionary that defines order of fields for prev/next navigation
// NOTE: this scheme assumes a placeholder is defined for each field, and is unique within the View

- (void) addToDictionary:(UITextField *)currFld next:(UITextField *)nextFld prev:(UITextField *)prevFld {
    
    FieldNavigationLink *flink;
    
    @try{
        flink = [[FieldNavigationLink alloc] initWithFields:currFld next:nextFld prev:prevFld];
        [mFieldDict setObject:flink forKey:currFld.placeholder];
        NSLog(@"Added: %@, next:%@, prev:%@", currFld.placeholder, nextFld.placeholder, prevFld.placeholder);
    }
    @catch (NSException *e){
        NSLog(@"addToDictionary Exception: %@", e.reason);
    }
}


- (void) dumpDictionary {
    @try{
        NSArray *keys = [mFieldDict allKeys];
        
        NSLog(@"Dictionary contents:");
        // values in foreach loop
        FieldNavigationLink *flink;
        for (NSString *key in keys) {
            flink = [mFieldDict objectForKey:key];
            NSLog(@"%@ is curr:%@ next:%@ prev:%@",key, flink.currField.placeholder, flink.nextField.placeholder, flink.prevField.placeholder);
        }
        
    }
    @catch (NSException *e){
        NSLog(@"dumpDictionary Exception: %@", e.reason);
    }
}


- (void) setCurrLink:(UITextField *)textField {
    @try{
        mCurrNavLink = [mFieldDict objectForKey:textField.placeholder];
        if (mCurrNavLink){
            NSLog(@"setCurrLink: %@ next:%@ prev:%@", textField.placeholder, mCurrNavLink.nextField.placeholder, mCurrNavLink.prevField.placeholder);
        } else {
            NSLog(@"setCurrLink: current link is NULL");
        }
    }
    @catch (NSException *e ) {
        NSLog(@"setCurrLink Exception: %@", e.reason);
        NSLog(@"setCurrLink textField:%@", textField);
    }
}



- (void) setupNavigation {
    mFieldDict = [[NSMutableDictionary alloc]  init];
    
    [self addToDictionary:self.inSite          next:self.inSumSteam      prev:self.inMinCausticAlk];
    [self addToDictionary:self.inSumSteam      next:self.inWinSteam      prev:self.inSite];
    [self addToDictionary:self.inWinSteam      next:self.inSumHours      prev:self.inSumSteam];
    [self addToDictionary:self.inSumHours      next:self.inWinHours      prev:self.inWinSteam];
    [self addToDictionary:self.inWinHours      next:self.inSumDays       prev:self.inSumHours];
    [self addToDictionary:self.inSumDays       next:self.inWinDays       prev:self.inWinHours];
    [self addToDictionary:self.inWinDays       next:self.inSumWeeks      prev:self.inSumDays];
    [self addToDictionary:self.inSumWeeks      next:self.inWinWeeks      prev:self.inWinDays];
    [self addToDictionary:self.inWinWeeks      next:self.inTDS           prev:self.inSumWeeks];
    [self addToDictionary:self.inTDS           next:self.inMAlk          prev:self.inWinWeeks];
    [self addToDictionary:self.inMAlk          next:self.inPH            prev:self.inTDS];
    [self addToDictionary:self.inPH            next:self.inCaHardness    prev:self.inMAlk];
    [self addToDictionary:self.inCaHardness    next:self.inTemp          prev:self.inPH];
    [self addToDictionary:self.inTemp          next:self.inMaxTDS        prev:self.inCaHardness];
    [self addToDictionary:self.inMaxTDS        next:self.inMinSulphite   prev:self.inTemp];
    [self addToDictionary:self.inMinSulphite   next:self.inMinCausticAlk prev:self.inMaxTDS];
    [self addToDictionary:self.inMinCausticAlk next:self.inSite          prev:self.inMinSulphite];
    
    //[self dumpDictionary];
}



// function to initialise display from model object

- (void) loadFromModel:(BoilerWaterModel *)model {
    
    self.inSite.text = mBoilerModel.site;
    
    if (self.inSite.text.length > 0) {
        // Boiler Duty parameters
        self.inSumSteam.text = mBoilerModel.inSumSteam;
        self.inSumHours.text = mBoilerModel.inSumHours;
        self.inSumDays.text = mBoilerModel.inSumDays;
        self.inSumWeeks.text = mBoilerModel.inSumWeeks;
        self.inWinSteam.text = mBoilerModel.inWinSteam;
        self.inWinHours.text = mBoilerModel.inWinHours;
        self.inWinDays.text = mBoilerModel.inWinDays;
        self.inWinWeeks.text = mBoilerModel.inWinWeeks;
        
        // Feedwater params
        self.inTDS.text = mBoilerModel.inTDS;
        self.inMAlk.text = mBoilerModel.inMAlk;
        self.inPH.text = mBoilerModel.inPH;
        self.inCaHardness.text = mBoilerModel.inCaHardness;
        self.inTemp.text = mBoilerModel.inTemp;
        
        
        // Boiler Details params
        self.inMaxTDS.text = mBoilerModel.inMaxTDS;
        self.inMinSulphite.text = mBoilerModel.inMinSulphite;
        self.inMinCausticAlk.text = mBoilerModel.inMinCausticAlk;
    } else {
        NSLog(@"BoilerInputTableViewController: No saved data to load");
    }
    
}



// function to check that required input fields have been specified
// Also copies data from text fields into corresponding model variables

- (BOOL)checkInputFields{
    BOOL result = YES;
    
    if (self.inSite.text.length>0){
        mBoilerModel.site = self.inSite.text;
    } else {
        [self setFocus:self.inSite];
        NSLog(@"BoilerInputTableViewController: inSite not defined");
        return NO;
    }
    
    if (self.inSumSteam.text.length>0) {
        mBoilerModel.sumSteam = [NSNumber numberWithFloat:[self.inSumSteam.text floatValue]];
    }  else {
        [self setFocus:self.inSumSteam];
        NSLog(@"BoilerInputTableViewController: inSumSteam not defined");
        return NO;
    }
    
    if (self.inSumHours.text.length>0){
        mBoilerModel.sumHours = [NSNumber numberWithFloat:[self.inSumHours.text floatValue]];
    }  else {
        [self setFocus:self.inSumHours];
        NSLog(@"BoilerInputTableViewController: inSumHours not defined");
        return NO;
    }
    
    if (self.inSumDays.text.length>0){
        mBoilerModel.sumDays = [NSNumber numberWithFloat:[self.inSumDays.text floatValue]];
    }  else {
        [self setFocus:self.inSumDays];
        NSLog(@"BoilerInputTableViewController: inSumDays not defined");
        return NO;
    }
    
    if (self.inSumWeeks.text.length>0){
        mBoilerModel.sumWeeks = [NSNumber numberWithFloat:[self.inSumWeeks.text floatValue]];
    }  else {
        [self setFocus:self.inSumWeeks];
        NSLog(@"BoilerInputTableViewController: inSumWeeks not defined");
        return NO;
    }
    
    if (self.inWinSteam.text.length>0){
        mBoilerModel.winSteam = [NSNumber numberWithFloat:[self.inWinSteam.text floatValue]];
    }  else {
        [self setFocus:self.inWinSteam];
        NSLog(@"BoilerInputTableViewController: inWinSteam not defined");
        return NO;
    }
    
    if (self.inWinHours.text.length>0){
        mBoilerModel.winHours = [NSNumber numberWithFloat:[self.inWinHours.text floatValue]];
    }  else {
        [self setFocus:self.inWinHours];
        NSLog(@"BoilerInputTableViewController: inWinHours not defined");
        return NO;
    }
    
    if (self.inWinDays.text.length>0){
        mBoilerModel.winDays = [NSNumber numberWithFloat:[self.inWinDays.text floatValue]];
    }  else {
        [self setFocus:self.inWinDays];
        NSLog(@"BoilerInputTableViewController: inWinDays not defined");
        return NO;
    }
    
    if (self.inWinWeeks.text.length>0){
        mBoilerModel.winWeeks = [NSNumber numberWithFloat:[self.inWinWeeks.text floatValue]];
    }  else {
        [self setFocus:self.inWinWeeks];
        NSLog(@"BoilerInputTableViewController: inWinWeeks not defined");
        return NO;
    }
    
    if (self.inTDS.text.length>0){
        mBoilerModel.TDS = [NSNumber numberWithFloat:[self.inTDS.text floatValue]];
    }  else {
        [self setFocus:self.inTDS];
        NSLog(@"BoilerInputTableViewController: inTDS not defined");
        return NO;
    }
    
    if (self.inMAlk.text.length>0){
        mBoilerModel.MAlk = [NSNumber numberWithFloat:[self.inMAlk.text floatValue]];
    }  else {
        [self setFocus:self.inMAlk];
        NSLog(@"BoilerInputTableViewController: inMAlk not defined");
        return NO;
    }
    
    if (self.inPH.text.length>0){
        mBoilerModel.pH = [NSNumber numberWithFloat:[self.inPH.text floatValue]];
    }  else {
        [self setFocus:self.inPH];
        NSLog(@"BoilerInputTableViewController: inPH not defined");
        return NO;
    }
    
    if (self.inCaHardness.text.length>0){
        mBoilerModel.CaHardness = [NSNumber numberWithFloat:[self.inCaHardness.text floatValue]];
    }  else {
        [self setFocus:self.inCaHardness];
        NSLog(@"BoilerInputTableViewController: inCaHardness not defined");
        return NO;
    }
    
    if (self.inTemp.text.length>0){
        mBoilerModel.temp = [NSNumber numberWithFloat:[self.inTemp.text floatValue]];
    }  else {
        [self setFocus:self.inTemp];
        NSLog(@"BoilerInputTableViewController: inTemp not defined");
        return NO;
    }
    
    if (self.inMaxTDS.text.length>0){
        mBoilerModel.maxTDS = [NSNumber numberWithFloat:[self.inMaxTDS.text floatValue]];
    }  else {
        [self setFocus:self.inMaxTDS];
        NSLog(@"BoilerInputTableViewController: inMaxTDS not defined");
        return NO;
    }
    
    if (self.inMinSulphite.text.length>0){
        mBoilerModel.minSulphite = [NSNumber numberWithFloat:[self.inMinSulphite.text floatValue]];
    }  else {
        [self setFocus:self.inMinSulphite];
        NSLog(@"BoilerInputTableViewController: inMinSulphite not defined");
        return NO;
    }
    
    if (self.inMinCausticAlk.text.length>0){
        mBoilerModel.minCausticAlk = [NSNumber numberWithFloat:[self.inMinCausticAlk.text floatValue]];
    }  else {
        [self setFocus:self.inMinCausticAlk];
        NSLog(@"BoilerInputTableViewController: inMinCausticAlk not defined");
        return NO;
    }
    
    // fields are OK, so copy input values into model
    self.inSite.text = mBoilerModel.site;
    
    // Boiler Duty parameters
    mBoilerModel.inSumSteam = self.inSumSteam.text ;
    mBoilerModel.inSumHours = self.inSumHours.text ;
    mBoilerModel.inSumDays = self.inSumDays.text ;
    mBoilerModel.inSumWeeks = self.inSumWeeks.text ;
    mBoilerModel.inWinSteam = self.inWinSteam.text ;
    mBoilerModel.inWinHours = self.inWinHours.text ;
    mBoilerModel.inWinDays = self.inWinDays.text ;
    mBoilerModel.inWinWeeks = self.inWinWeeks.text ;
    
    // Feedwater params
    mBoilerModel.inTDS = self.inTDS.text ;
    mBoilerModel.inMAlk = self.inMAlk.text ;
    mBoilerModel.inPH = self.inPH.text ;
    mBoilerModel.inCaHardness = self.inCaHardness.text ;
    mBoilerModel.inTemp = self.inTemp.text ;
    
    
    // Boiler Details params
    mBoilerModel.inMaxTDS = self.inMaxTDS.text ;
    mBoilerModel.inMinSulphite = self.inMinSulphite.text ;
    mBoilerModel.inMinCausticAlk = self.inMinCausticAlk.text ;
    
    
    return result;
}



// round to 1 decimal place
- (NSString *)round1:(double)value {
    double tmp = 0.0;
    tmp = ((int)((value+0.05) * 10)) / 10.0;
    //NSLog(@"in:%.09f out:%.09f", value, tmp);
    
    return [[NSString alloc] initWithFormat:@"%.01f", tmp];
}



// round to 2 decimal places
- (NSString *)round2:(double)value {
    double tmp = 0.0;
    tmp = ((int)((value+0.005) * 100) / 100.0);
    return [[NSString alloc] initWithFormat:@"%.02f", tmp];
}




// Button action to show products - asks user for solids/liquids, then launches next screen
- (IBAction)calculateProducts:(id)sender {
    if ([self checkInputFields]){
        NSLog(@"BoilerInputTableViewController: input fields OK");
        // make sure keyboard is dismissed
        for (UIView* view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]])
                [view resignFirstResponder];
        }
        
        [mBoilerModel calculateAmounts];
        [mBoilerModel save] ;
        // initiate transition to next display
        
        // Need to find out whether this is for solids or liquids and transition accordingly
        /* old menu-style code
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Choose Product Type" delegate:self cancelButtonTitle:@"Solids" otherButtonTitles:@"Liquids", nil];
        [alert show];
        //[alert release];
         */
        
        /* check product type and launch appropriate segue */
        ProductType ptype = [mBoilerModel getProductType];
        if (ptype == SOLID) {
            [self calculateSolidProducts];
        } else if (ptype == LIQUID) {
            [self calculateLiquidProducts];
        } else {
            NSLog(@"BoilerInputTableViewController.m: !!! Unkown Product Type: %ld", (long)ptype);
        }

    } else {
        NSLog(@"BoilerInputTableViewController: Error in input fields");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Data" message:@"Please enter data in all cells" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
    }
}

// completion handler for alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self calculateSolidProducts];
    } else {
        [self calculateLiquidProducts];
    }
}

// Button action to show solid products
- (void) calculateSolidProducts {
    
    // initiate transition to next display
    [self performSegueWithIdentifier:@"BoilerSolidProducts" sender:self];
    
}




// Button action to show liquid products
- (void) calculateLiquidProducts {
    
    // initiate transition to next display
    [self performSegueWithIdentifier:@"BoilerLiquidProducts" sender:self];
}



@end
