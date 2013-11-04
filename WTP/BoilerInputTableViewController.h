//
//  BoilerInputTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoilerInputTableViewController : UITableViewController <UITextFieldDelegate>


// Site Name
@property (retain, nonatomic) IBOutlet UITextField *inSite;

// Boiler Duty parameters
@property (retain, nonatomic) IBOutlet UITextField *inSumSteam;
@property (retain, nonatomic) IBOutlet UITextField *inSumHours;
@property (retain, nonatomic) IBOutlet UITextField *inSumDays;
@property (retain, nonatomic) IBOutlet UITextField *inSumWeeks;
@property (retain, nonatomic) IBOutlet UITextField *inWinSteam;
@property (retain, nonatomic) IBOutlet UITextField *inWinHours;
@property (retain, nonatomic) IBOutlet UITextField *inWinDays;
@property (retain, nonatomic) IBOutlet UITextField *inWinWeeks;

// Feedwater params
@property (retain, nonatomic) IBOutlet UITextField *inTDS;
@property (retain, nonatomic) IBOutlet UITextField *inMAlk;
@property (retain, nonatomic) IBOutlet UITextField *inPH;
@property (retain, nonatomic) IBOutlet UITextField *inCaHardness;
@property (retain, nonatomic) IBOutlet UITextField *inTemp;


// Boiler Details params
@property (retain, nonatomic) IBOutlet UITextField *inMaxTDS;
@property (retain, nonatomic) IBOutlet UITextField *inMinSulphite;
@property (retain, nonatomic) IBOutlet UITextField *inMinCausticAlk;


// Button handler
- (IBAction)calculateProducts:(id)sender;


// Stuff for the input accessory view:

@property (nonatomic, strong) UIToolbar*       keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem* btnDone;
@property (nonatomic, strong) UIBarButtonItem* btnNext;
@property (nonatomic, strong) UIBarButtonItem* btnPrev;


@end
