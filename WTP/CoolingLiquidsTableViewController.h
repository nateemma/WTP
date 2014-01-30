//
//  CoolingLiquidsTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CoolingLiquidsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>


// Output fields for product values

@property (retain, nonatomic) IBOutlet UILabel *outH207Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH207Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH2073Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH2073Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH280Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH280Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH2805Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH2805Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH390Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH390Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH3905Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH3905Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH391Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH391Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH423Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH423Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH425Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH425Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH4255Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH4255Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH535Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH535Usage;
@property (retain, nonatomic) IBOutlet UILabel *outH874Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outH874Usage;

// Biocide values

@property (retain, nonatomic) IBOutlet UILabel *outC31Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC31Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC32Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC32Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC44Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC44Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC45Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC45Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC48Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC48Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC51Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC51Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC52Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC52Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC54Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC54Usage;
@property (retain, nonatomic) IBOutlet UILabel *outC58Dosage;
@property (retain, nonatomic) IBOutlet UILabel *outC58Usage;




// Button handler
- (IBAction)sendEmail:(id)sender;

@end
