//
//  BoilerLiquidsTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BoilerLiquidsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>


// Output fields for product values
@property (retain, nonatomic) IBOutlet UILabel *outS5Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS5Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS10Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS10Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS123Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS123Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS125Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS125Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS26Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS26Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS28Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS28Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS19Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS19Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS456Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS456Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS124Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS124Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS22Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS22Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS23Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS23Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS88Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS88Usage;
@property (retain, nonatomic) IBOutlet UILabel *outS95Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outS95Usage;


// Button handler
- (IBAction)sendEmail:(id)sender;

@end
