//
//  CoolingInputTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/22/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolingInputTableViewController : UITableViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *inSite;

@property (retain, nonatomic) IBOutlet UITextField *inCirculation;
@property (retain, nonatomic) IBOutlet UITextField *inDeltaT;
@property (retain, nonatomic) IBOutlet UITextField *inSumpVolume;
@property (retain, nonatomic) IBOutlet UITextField *inSysVolume;
@property (retain, nonatomic) IBOutlet UITextField *inConcFactor;

@property (retain, nonatomic) IBOutlet UITextField *inTDS;
@property (retain, nonatomic) IBOutlet UITextField *inTotalHardness;
@property (retain, nonatomic) IBOutlet UITextField *inMAlk;
@property (retain, nonatomic) IBOutlet UITextField *inPH;
@property (retain, nonatomic) IBOutlet UITextField *inChlorides;

@property (retain, nonatomic) IBOutlet UITextField *inHours;
@property (retain, nonatomic) IBOutlet UITextField *inDays;
@property (retain, nonatomic) IBOutlet UITextField *inWeeks;


// Button handler
- (IBAction)calculateProducts:(id)sender;

// Stuff for the input accessory view:

@property (nonatomic, strong) UIToolbar*       keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem* btnDone;
@property (nonatomic, strong) UIBarButtonItem* btnNext;
@property (nonatomic, strong) UIBarButtonItem* btnPrev;

@end
