//
//  BoilerSolidsTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "BoilerSolidsTableViewController.h"
#import "BoilerWaterModel.h"

@implementation BoilerSolidsTableViewController


// Object to hold boiler data
BoilerWaterModel *mBoilerModel;



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
    NSLog(@"BoilerSolidsTableViewController: loading data...");
    mBoilerModel = [BoilerWaterModel sharedInstance];
    
    // update display
    [self updateDisplay];
    
    // register a gesture recogniser to detect if user touches the background
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // handle row selection, if anything
}


// control rotation handling. In this case, only allow landscape orientation
- (BOOL) shouldAutorotate {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        return YES;
    } else {
        return NO;
    }
}


// routine to hide the keyboard
- (void) hideKeyboard {
    [self.view endEditing:YES];
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




// update display variables/labels based on model calculated values

- (void) updateDisplay {
    self.outSS1295Dosage.text = [self round1:mBoilerModel.ss1295Dosage.doubleValue];
    self.outSS1295Usage.text  = [self round1:mBoilerModel.ss1295Usage.doubleValue];
    self.outSS1350Dosage.text = [self round1:mBoilerModel.ss1350Dosage.doubleValue];
    self.outSS1350Usage.text  = [self round1:mBoilerModel.ss1350Usage.doubleValue];
    self.outSS1095Dosage.text = [self round1:mBoilerModel.ss1095Dosage.doubleValue];
    self.outSS1095Usage.text  = [self round1:mBoilerModel.ss1095Usage.doubleValue];
    self.outSS1995Dosage.text = [self round1:mBoilerModel.ss1995Dosage.doubleValue];
    self.outSS1995Usage.text  = [self round1:mBoilerModel.ss1995Usage.doubleValue];
    self.outSS2295Dosage.text = [self round1:mBoilerModel.ss2295Dosage.doubleValue];
    self.outSS2295Usage.text  = [self round1:mBoilerModel.ss2295Usage.doubleValue];
    self.outSS8985Dosage.text = [self round1:mBoilerModel.ss8985Dosage.doubleValue];
    self.outSS8985Usage.text  = [self round1:mBoilerModel.ss8985Usage.doubleValue];
    
}


// routine to build HTML Summary of data
- (NSString *)buildHTMLsummary{
    NSString *htmlString; // string to hold the HTML Data
    NSString *row;        // String to hold data for a row
    NSString *rowFormat;  // String to hold format template for row data
    NSString *disclaimer = @"<p><i>Disclaimer</i>: the values shown are estimates only.<p>";
    
    htmlString = @"<p>Below are the input parameters used for the calculations, and the resulting product estimates:</p>";
    
    // Input Parameters
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    htmlString = [htmlString stringByAppendingString:@"<b>Boiler Water Input Parameters</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    
    // Site Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Site</TR>"];
    row = [NSString stringWithFormat:@"<TD colspan=\"3\">%@</TD>", mBoilerModel.site];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Boiler Duty Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Boiler Duty"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH> <TH>Summer<TH>Winter</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"Steam (lb/hr)", mBoilerModel.inSumSteam, mBoilerModel.inWinSteam];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Hours/Day", mBoilerModel.inSumHours, mBoilerModel.inWinHours];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Days/Week", mBoilerModel.inSumDays, mBoilerModel.inWinDays];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Weeks/Year", mBoilerModel.inSumWeeks, mBoilerModel.inWinWeeks];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Feed Water Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Feed Water"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"TDS", mBoilerModel.inTDS, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"M Alk", mBoilerModel.inMAlk, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"pH", mBoilerModel.inPH, @""];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Ca Hardness", mBoilerModel.inCaHardness, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Temperature", mBoilerModel.inTemp, @"°C"];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Boiler Duty Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Boiler Details"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"Max TDS", mBoilerModel.inMaxTDS, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Min Sulphite Reserve", mBoilerModel.inMinSulphite, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Min Caustic Alkalinity", mBoilerModel.inMinCausticAlk, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Estimated Product amounts
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    htmlString = [htmlString stringByAppendingString:@"<b>Estimated Products Needed</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#F0F8FF\"><TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Description</TR>"];
    
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS1295",
           [self round1:mBoilerModel.ss1295Dosage.doubleValue],
           [self round1:mBoilerModel.ss1295Usage.doubleValue],
           @"All in One - Sulphite"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS1350",
           [self round1:mBoilerModel.ss1350Dosage.doubleValue],
           [self round1:mBoilerModel.ss1350Usage.doubleValue],
           @"All in One - Sulphite - no caustic"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS1095",
           [self round1:mBoilerModel.ss1095Dosage.doubleValue],
           [self round1:mBoilerModel.ss1095Usage.doubleValue],
           @"Sodium Sulphite"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS1995",
           [self round1:mBoilerModel.ss1995Dosage.doubleValue],
           [self round1:mBoilerModel.ss1995Usage.doubleValue],
           @"Alkalinity Builder"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS2295",
           [self round1:mBoilerModel.ss2295Dosage.doubleValue],
           [self round1:mBoilerModel.ss2295Usage.doubleValue],
           @"Phosphate Polymer" ];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SS8985",
           [self round1:mBoilerModel.ss8985Dosage.doubleValue],
           [self round1:mBoilerModel.ss8985Usage.doubleValue],
           @"Amines" ];
    htmlString = [htmlString stringByAppendingString:row];
    
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Disclaimer
    htmlString = [htmlString stringByAppendingString:disclaimer];
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    return htmlString;
}

// Action to launch email app
- (IBAction) sendEmail:(id)sender {
    
    NSLog(@"BoilerSolidsTableViewController:sendEmail:");
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        
        
        // Set email parameters
        
        //NSArray *toRecipients = [NSArray arrayWithObject:email];
        
        [mcvc setSubject:@"Boiler Water Product Estimates (WTP)"];
        
        NSString *msgBody = [self buildHTMLsummary];
        [mcvc setMessageBody:msgBody isHTML:YES];
        //[mcvc setToRecipients:toRecipients];
        
        
        // Present mail view controller on screen
        [self presentViewController:mcvc animated:YES completion:NULL];
    }
    
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}



// function to handle return from email app
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"Mail composisition result:%u", result);
    switch(result){
        case MFMailComposeResultCancelled:
            NSLog(@"The user cancelled the operation. No email message was queued.");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"The email message was saved in the user’s Drafts folder.");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"The email message was queued in the user’s outbox. It is ready to send the next time the user connects to email.");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"The email message was not saved or queued, possibly due to an error.");
            break;
            
        default:
            NSLog(@"Unkown result code: %u", result);
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
