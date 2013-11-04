//
//  CoolingProductsTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/22/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//  11/6/13 - removed cost parameters by customer request (commented out for now)
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CoolingProductsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>


// Product-based values
@property (retain, nonatomic) IBOutlet UILabel *outHS2097Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outHS2097Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outHS2097CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outHS2097CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outHS4390Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outHS4390Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outHS4390CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outHS4390CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outHS3990Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outHS3990Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outHS3990CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outHS3990CostAnnum;

// Biocide values

@property (retain, nonatomic) IBOutlet UILabel *outCS4400Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outCS4400Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4400CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4400CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outCS4802Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outCS4802Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4802CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4802CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outCS4490Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outCS4490Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4490CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outCS4490CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outSCG1Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSCG1Usage;
//@property (retain, nonatomic) IBOutlet UILabel *outSCG1CostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outSCG1CostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outCSchlorDosage;
@property (retain, nonatomic) IBOutlet UILabel *outCSchlorUsage;
//@property (retain, nonatomic) IBOutlet UILabel *outCSchlorCostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outCSchlorCostAnnum;

@property (retain, nonatomic) IBOutlet UILabel *outC42TDosage;
@property (retain, nonatomic) IBOutlet UILabel *outC42TUsage;
//@property (retain, nonatomic) IBOutlet UILabel *outC42TCostKg;
//@property (retain, nonatomic) IBOutlet UILabel *outC42TCostAnnum;


// Button handler
- (IBAction)sendEmail:(id)sender;

@end
