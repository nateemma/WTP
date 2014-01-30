//
//  BoilerLiquidsTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "BoilerLiquidsTableViewController.h"
#import "BoilerWaterModel.h"

@implementation BoilerLiquidsTableViewController


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
    
    
    @try{
        // create the model object
        NSLog(@"BoilerLiquidsTableViewController: loading data...");
        mBoilerModel = [BoilerWaterModel sharedInstance];
        
        // update display
        [self updateDisplay];
        
        // register a gesture recogniser to detect if user touches the background
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self.tableView addGestureRecognizer:gestureRecognizer];
    }
    @catch (NSException *e) {
        NSLog(@"viewDidLoad - exception: %@", e.reason);
    }
    
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
    
    self.outS5Dosage.text   = [self round1:mBoilerModel.s5Dosage.doubleValue];
    self.outS5Usage.text    = [self round1:mBoilerModel.s5Usage.doubleValue];
    self.outS10Dosage.text  = [self round1:mBoilerModel.s10Dosage.doubleValue];
    self.outS10Usage.text   = [self round1:mBoilerModel.s10Usage.doubleValue];
    self.outS123Dosage.text = [self round1:mBoilerModel.s123Dosage.doubleValue];
    self.outS123Usage.text  = [self round1:mBoilerModel.s123Usage.doubleValue];
    self.outS125Dosage.text = [self round1:mBoilerModel.s125Dosage.doubleValue];
    self.outS125Usage.text  = [self round1:mBoilerModel.s125Usage.doubleValue];
    self.outS26Dosage.text  = [self round1:mBoilerModel.s26Dosage.doubleValue];
    self.outS26Usage.text   = [self round1:mBoilerModel.s26Usage.doubleValue];
    self.outS28Dosage.text  = [self round1:mBoilerModel.s28Dosage.doubleValue];
    self.outS28Usage.text   = [self round1:mBoilerModel.s28Usage.doubleValue];
    self.outS19Dosage.text  = [self round1:mBoilerModel.s19Dosage.doubleValue];
    self.outS19Usage.text   = [self round1:mBoilerModel.s19Usage.doubleValue];
    self.outS456Dosage.text = [self round1:mBoilerModel.s456Dosage.doubleValue];
    self.outS456Usage.text  = [self round1:mBoilerModel.s456Usage.doubleValue];
    self.outS124Dosage.text = [self round1:mBoilerModel.s124Dosage.doubleValue];
    self.outS124Usage.text  = [self round1:mBoilerModel.s124Usage.doubleValue];
    self.outS22Dosage.text  = [self round1:mBoilerModel.s22Dosage.doubleValue];
    self.outS22Usage.text   = [self round1:mBoilerModel.s22Usage.doubleValue];
    self.outS23Dosage.text  = [self round1:mBoilerModel.s23Dosage.doubleValue];
    self.outS23Usage.text   = [self round1:mBoilerModel.s23Usage.doubleValue];
    self.outS88Dosage.text  = [self round1:mBoilerModel.s88Dosage.doubleValue];
    self.outS88Usage.text   = [self round1:mBoilerModel.s88Usage.doubleValue];
    self.outS95Dosage.text  = [self round1:mBoilerModel.s95Dosage.doubleValue];
    self.outS95Usage.text   = [self round1:mBoilerModel.s95Usage.doubleValue];
}


// routine to build HTML Summary of data
- (NSString *)buildHTMLsummary{
    NSString *htmlString; // string to hold the HTML Data
    NSString *row;        // String to hold data for a row
    NSString *rowFormat;  // String to hold format template for row data
    NSString *disclaimer = @"<p><i>Disclaimer</i>: the values shown are estimates only.<p>";
    
    htmlString = @"<p>Below are the input parameters used for the calculations, and the resulting (liquid) product estimates:</p>";
    
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
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Steam (lb/hr)", mBoilerModel.inSumSteam, mBoilerModel.inWinSteam]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Hours/Day", mBoilerModel.inSumHours, mBoilerModel.inWinHours]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Days/Week", mBoilerModel.inSumDays, mBoilerModel.inWinDays]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Weeks/Year", mBoilerModel.inSumWeeks, mBoilerModel.inWinWeeks]];
    
    // Feed Water Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Feed Water"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"TDS", mBoilerModel.inTDS, @"ppm"]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"M Alk", mBoilerModel.inMAlk, @"ppm"]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"pH", mBoilerModel.inPH, @""]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Ca Hardness", mBoilerModel.inCaHardness, @"ppm"]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Temperature", mBoilerModel.inTemp, @"°C"]];
    
    // Boiler Duty Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Boiler Details"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Max TDS", mBoilerModel.inMaxTDS, @"ppm"]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Min Sulphite Reserve", mBoilerModel.inMinSulphite, @"ppm"]];
    htmlString = [htmlString stringByAppendingString: [NSString stringWithFormat:rowFormat, @"Min Caustic Alkalinity", mBoilerModel.inMinCausticAlk, @"ppm"]];
    
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Estimated Product amounts
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    htmlString = [htmlString stringByAppendingString:@"<b>Estimated Products Needed</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#F0F8FF\"><TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Description</TR>"];
    
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S5", [self round1:mBoilerModel.s5Dosage.doubleValue], [self round1:mBoilerModel.s5Usage.doubleValue],
           @"17% as Sodium bisulphite/catalysed"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S10", [self round1:mBoilerModel.s10Dosage.doubleValue], [self round1:mBoilerModel.s10Usage.doubleValue],
           @"35% as Sodium bisulphite/catalysed"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S123", [self round1:mBoilerModel.s123Dosage.doubleValue], [self round1:mBoilerModel.s123Usage.doubleValue],
           @"All in One Low Sulphite"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S125", [self round1:mBoilerModel.s125Dosage.doubleValue], [self round1:mBoilerModel.s125Usage.doubleValue],
           @"All in One High Sulphite"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S26", [self round1:mBoilerModel.s26Dosage.doubleValue], [self round1:mBoilerModel.s26Usage.doubleValue],
           @"25% tannin/caustic"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S28", [self round1:mBoilerModel.s28Dosage.doubleValue], [self round1:mBoilerModel.s28Usage.doubleValue],
           @"25% tannin"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S19", [self round1:mBoilerModel.s19Dosage.doubleValue], [self round1:mBoilerModel.s19Usage.doubleValue],
           @"Alkalinity Builder"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S456", [self round1:mBoilerModel.s456Dosage.doubleValue], [self round1:mBoilerModel.s456Usage.doubleValue],
           @"Polymer blend"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S124", [self round1:mBoilerModel.s124Dosage.doubleValue], [self round1:mBoilerModel.s124Usage.doubleValue],
           @"All in one Tannin Product"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S22", [self round1:mBoilerModel.s22Dosage.doubleValue], [self round1:mBoilerModel.s22Usage.doubleValue],
           @"Phosphate/Polymer"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S23", [self round1:mBoilerModel.s23Dosage.doubleValue], [self round1:mBoilerModel.s23Usage.doubleValue],
           @"Phosphate/Polymer/Caustic"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S88", [self round1:mBoilerModel.s88Dosage.doubleValue], [self round1:mBoilerModel.s88Usage.doubleValue],
           @"Morpholine/Cyclohex"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP S95", [self round1:mBoilerModel.s95Dosage.doubleValue], [self round1:mBoilerModel.s95Usage.doubleValue],
           @"Filming and neutralising amines"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Disclaimer
    htmlString = [htmlString stringByAppendingString:disclaimer];
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    return htmlString;
}

// Action to launch email app
- (IBAction) sendEmail:(id)sender {
    
    NSLog(@"BoilerLiquidsTableViewController:sendEmail:");
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        
        
        // Set email parameters
        
        //NSArray *toRecipients = [NSArray arrayWithObject:email];
        
        [mcvc setSubject:@"Boiler Water Liquid Product Estimates (WTP)"];
        
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
