//
//  CoolingInputTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/22/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "CoolingInputTableViewController.h"
#import "CoolingWaterModel.h"
#include "FieldNavigationLink.h"



@implementation CoolingInputTableViewController




// Object to hold Cooling data
CoolingWaterModel *mCoolingModel;


// dictionary to hold fields navigation data, key is field name
NSMutableDictionary *mFieldDict ;

// curent navigation field
FieldNavigationLink *mCurrNavLink;



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
    
    
    // create the model object
    mCoolingModel = [CoolingWaterModel sharedInstance];
    
    // load previous values
    [mCoolingModel restore];
    
    // update display
    [self loadFromModel:mCoolingModel];
    
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
    NSLog(@"CoolingInputTableViewController: textFieldDidBeginEditing %@", textField.placeholder);
    
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
    NSLog(@"CoolingInputTableViewController: textFieldDidEndEditing %@", textField.placeholder);
    [textField resignFirstResponder];
}


// function(s) to clear keyboard if user taps the background

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"CoolingInputTableViewController: touchesBegan");
    [self.view endEditing:YES];
}


// function to clear keyboard if user taps the background
- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"CoolingInputTableViewController: backgroundTapped");
    [self.view endEditing:YES];
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    NSLog(@"CoolingInputTableViewController: touchesEnded");
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
    NSLog(@"CoolingInputTableViewController.createInputAccessoryView()");
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
        NSLog(@"Scrolling to section:%i row:%i", indexPath.section, indexPath.row);
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else {
        NSLog(@"no index returned, not scrolling");
    }
}



//////////////////////////////////////////////////
// Functions for handling the navigation chain
//////////////////////////////////////////////////

// function to load dictionary that defines order of fields for prev/next navigation
// NOTE: this scheme assumes a placeholder is defined for each field, and is unique within the View

- (void) addToDictionary:(UITextField *)currFld next:(UITextField *)nextFld prev:(UITextField *)prevFld {
    
    FieldNavigationLink *flink;
    
    @try{
        flink = [[FieldNavigationLink alloc] initWithFields:currFld next:nextFld prev:prevFld];
        [mFieldDict setObject:flink forKey:currFld.placeholder];
        NSLog(@"Added: %@, next:%@, prev:%@", currFld.placeholder, nextFld.placeholder, prevFld.placeholder);
        
        // TEMP DEBUG
        // Get that cell's index path
        //NSIndexPath *indexPath = [self findTableIndex:currFld];
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
   
    [self addToDictionary:self.inSite          next:self.inCirculation   prev:self.inWeeks];
    [self addToDictionary:self.inCirculation   next:self.inDeltaT        prev:self.inSite];
    [self addToDictionary:self.inDeltaT        next:self.inSumpVolume    prev:self.inCirculation];
    [self addToDictionary:self.inSumpVolume    next:self.inSysVolume     prev:self.inDeltaT];
    [self addToDictionary:self.inSysVolume     next:self.inConcFactor    prev:self.inSumpVolume];
    [self addToDictionary:self.inConcFactor    next:self.inTDS           prev:self.inSysVolume];
    [self addToDictionary:self.inTDS           next:self.inTotalHardness prev:self.inConcFactor];
    [self addToDictionary:self.inTotalHardness next:self.inMAlk          prev:self.inTDS];
    [self addToDictionary:self.inMAlk          next:self.inPH            prev:self.inTotalHardness];
    [self addToDictionary:self.inPH            next:self.inChlorides     prev:self.inMAlk];
    [self addToDictionary:self.inChlorides     next:self.inHours         prev:self.inPH];
    [self addToDictionary:self.inHours         next:self.inDays          prev:self.inChlorides];
    [self addToDictionary:self.inDays          next:self.inWeeks          prev:self.inHours];
    [self addToDictionary:self.inWeeks         next:self.inSite          prev:self.inDays];
    
    //[self dumpDictionary];
}


//////////////////////////////////////////////////
// Functions for handling this View
//////////////////////////////////////////////////


// function to initialise display from model object

- (void) loadFromModel:(CoolingWaterModel *)model {
    
    self.inSite.text = mCoolingModel.site;
    
    if (self.inSite.text.length > 0) {
        
        self.inSite.text = mCoolingModel.site;
        
        self.inCirculation.text = mCoolingModel.inCirculation;
        self.inDeltaT.text      = mCoolingModel.inDeltaT;
        self.inSumpVolume.text  = mCoolingModel.inSumpVolume;
        self.inSysVolume.text   = mCoolingModel.inSysVolume;
        self.inConcFactor.text  = mCoolingModel.inConcFactor;
        
        self.inTDS.text           = mCoolingModel.inTDS;
        self.inTotalHardness.text = mCoolingModel.inTotalHardness;
        self.inMAlk.text          = mCoolingModel.inMAlk;
        self.inPH.text            = mCoolingModel.inPH;
        self.inChlorides.text     = mCoolingModel.inChlorides;
        
        self.inHours.text = mCoolingModel.inHours;
        self.inDays.text  = mCoolingModel.inDays;
        self.inWeeks.text = mCoolingModel.inWeeks;
        
    } else {
        NSLog(@"CoolingInputViewController: No saved data to load");
    }
    
}



// function to check that required input fields have been specified
// Also copies data from text fields into corresponding model variables

- (BOOL)checkInputFields{
    BOOL result = YES;
    
    if (self.inSite.text.length>0){
        mCoolingModel.site = self.inSite.text;
    } else {
        
        [self setFocus:self.inSite];
        NSLog(@"CoolingInputViewController: inSite not defined");
        return NO;
    }
    
    if (self.inCirculation.text.length>0) {
        mCoolingModel.circulation = [NSNumber numberWithFloat:[self.inCirculation.text floatValue]];
    }  else {
        [self setFocus:self.inCirculation];
        NSLog(@"CoolingInputViewController: inCirculation not defined");
        return NO;
    }
    
    if (self.inDeltaT.text.length>0){
        mCoolingModel.deltaT = [NSNumber numberWithFloat:[self.inDeltaT.text floatValue]];
    }  else {
        [self setFocus:self.inDeltaT];
        NSLog(@"CoolingInputViewController: inDeltaT not defined");
        return NO;
    }
    
    if (self.inSumpVolume.text.length>0){
        mCoolingModel.sumpVolume = [NSNumber numberWithFloat:[self.inSumpVolume.text floatValue]];
    }  else {
        [self setFocus:self.inSumpVolume];
        NSLog(@"CoolingInputViewController: inSumpVolume not defined");
        return NO;
    }
    
    if (self.inSysVolume.text.length>0){
        mCoolingModel.sysVolume = [NSNumber numberWithFloat:[self.inSysVolume.text floatValue]];
    }  else {
        [self setFocus:self.inSysVolume];
        NSLog(@"CoolingInputViewController: inSysVolume not defined");
        return NO;
    }
    
    if (self.inConcFactor.text.length>0){
        mCoolingModel.concFactor = [NSNumber numberWithFloat:[self.inConcFactor.text floatValue]];
    }  else {
        [self setFocus:self.inConcFactor];
        NSLog(@"CoolingInputViewController: inConcFactor not defined");
        return NO;
    }
    
    if (self.inTDS.text.length>0){
        mCoolingModel.TDS = [NSNumber numberWithFloat:[self.inTDS.text floatValue]];
    }  else {
        [self setFocus:self.inTDS];
        NSLog(@"CoolingInputViewController: inTDS not defined");
        return NO;
    }
    
    if (self.inTotalHardness.text.length>0){
        mCoolingModel.totalHardness = [NSNumber numberWithFloat:[self.inTotalHardness.text floatValue]];
    }  else {
        [self setFocus:self.inTotalHardness];
        NSLog(@"CoolingInputViewController: inTotalHardness not defined");
        return NO;
    }
    
    if (self.inMAlk.text.length>0){
        mCoolingModel.MAlk = [NSNumber numberWithFloat:[self.inMAlk.text floatValue]];
    }  else {
        [self setFocus:self.inMAlk];
        NSLog(@"CoolingInputViewController: inMAlk not defined");
        return NO;
    }
    
    if (self.inPH.text.length>0){
        mCoolingModel.pH = [NSNumber numberWithFloat:[self.inPH.text floatValue]];
    }  else {
        [self setFocus:self.inPH];
        NSLog(@"CoolingInputViewController: inPH not defined");
        return NO;
    }
    
    if (self.inChlorides.text.length>0){
        mCoolingModel.chlorides = [NSNumber numberWithFloat:[self.inChlorides.text floatValue]];
    }  else {
        [self setFocus:self.inChlorides];
        NSLog(@"CoolingInputViewController: inChlorides not defined");
        return NO;
    }
    
    if (self.inHours.text.length>0){
        mCoolingModel.hours = [NSNumber numberWithFloat:[self.inHours.text floatValue]];
    }  else {
        [self setFocus:self.inHours];
        NSLog(@"CoolingInputViewController: inHours not defined");
        return NO;
    }
    
    if (self.inDays.text.length>0){
        mCoolingModel.days = [NSNumber numberWithFloat:[self.inDays.text floatValue]];
    }  else {
        [self setFocus:self.inDays];
        NSLog(@"CoolingInputViewController: inDays not defined");
        return NO;
    }
    
    if (self.inWeeks.text.length>0){
        mCoolingModel.weeks = [NSNumber numberWithFloat:[self.inWeeks.text floatValue]];
    }  else {
        [self setFocus:self.inWeeks];
        NSLog(@"CoolingInputViewController: inWeeks not defined");
        return NO;
    }
    
    // fields are OK, so copy input values into model
    self.inSite.text = mCoolingModel.site;
    
    mCoolingModel.inCirculation   = self.inCirculation.text;
    mCoolingModel.inDeltaT        = self.inDeltaT.text;
    mCoolingModel.inSumpVolume    = self.inSumpVolume.text;
    mCoolingModel.inSysVolume     = self.inSysVolume.text;
    mCoolingModel.inConcFactor    = self.inConcFactor.text;
    mCoolingModel.inTDS           = self.inTDS.text;
    mCoolingModel.inTotalHardness = self.inTotalHardness.text;
    mCoolingModel.inMAlk          = self.inMAlk.text;
    mCoolingModel.inPH            = self.inPH.text;
    mCoolingModel.inChlorides     = self.inChlorides.text;
    mCoolingModel.inHours         = self.inHours.text;
    mCoolingModel.inDays          = self.inDays.text;
    mCoolingModel.inWeeks         = self.inWeeks.text;
    
    return result;
}



// round to 1 decimal place
- (NSString *)round1:(double)value {
    double tmp = 0.0;
    tmp = ((int)((value+0.05) * 10)) / 10.0;
    NSLog(@"in:%.09f out:%.09f", value, tmp);
    
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
        NSLog(@"CoolingInputTableViewController: input fields OK");
        // make sure keyboard is dismissed
        for (UIView* view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]])
                [view resignFirstResponder];
        }
        
        [mCoolingModel calculateAmounts];
        [mCoolingModel save] ;
        // initiate transition to next display
        
        // Need to find out whether this is for solids or liquids and transition accordingly
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Choose Product Type" delegate:self cancelButtonTitle:@"Solids" otherButtonTitles:@"Liquids", nil];
        [alert show];
        //[alert release];
    } else {
        NSLog(@"CoolingInputTableViewController: Error in input fields");
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
    [self performSegueWithIdentifier:@"CoolingSolidProducts" sender:self];
    
}




// Button action to show liquid products
- (void) calculateLiquidProducts {
    
    // initiate transition to next display
    [self performSegueWithIdentifier:@"CoolingLiquidProducts" sender:self];
}


@end
