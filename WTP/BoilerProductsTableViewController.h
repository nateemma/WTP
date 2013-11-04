//
//  BoilerProductsTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BoilerProductsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *outSS1295Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS1295Usage;

@property (retain, nonatomic) IBOutlet UILabel *outSS1350Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS1350Usage;

@property (retain, nonatomic) IBOutlet UILabel *outSS1095Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS1095Usage;

@property (retain, nonatomic) IBOutlet UILabel *outSS1995Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS1995Usage;

@property (retain, nonatomic) IBOutlet UILabel *outSS2295Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS2295Usage;

@property (retain, nonatomic) IBOutlet UILabel *outSS8985Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outSS8985Usage;


// Button handler
- (IBAction)sendEmail:(id)sender;

@end
