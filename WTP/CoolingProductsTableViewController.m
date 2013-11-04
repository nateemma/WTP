//
//  CoolingProductsTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/22/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//
//  11/6/13 - removed cost parameters by customer request (commented out for now)
//

#import "CoolingProductsTableViewController.h"
#import "CoolingWaterModel.h"




@implementation CoolingProductsTableViewController

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
    
    // make sure calculations are done
    //[mCoolingModel calculateAmounts];
    
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
    // handle row selection
    
}



//////////////////////////////////////////////////
// UI-specific functions
//////////////////////////////////////////////////


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

// Object to hold Cooling data
CoolingWaterModel *mCoolingModel;


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
    
    
    // Product-based values
    self.outHS2097Dosage.text      = [self round1:mCoolingModel.hs2097Dosage.doubleValue];
    self.outHS2097Usage.text       = [self round1:mCoolingModel.hs2097Usage.doubleValue];
    //self.outHS2097CostKg.text      = [self round2:mCoolingModel.hs2097CostKg.doubleValue];
    //self.outHS2097CostAnnum.text   = [self round1:mCoolingModel.hs2097CostAnnum.doubleValue];
    
    self.outHS4390Dosage.text      = [self round1:mCoolingModel.hs4390Dosage.doubleValue];
    self.outHS4390Usage.text       = [self round1:mCoolingModel.hs4390Usage.doubleValue];
    //self.outHS4390CostKg.text      = [self round2:mCoolingModel.hs4390CostKg.doubleValue];
    //self.outHS4390CostAnnum.text   = [self round1:mCoolingModel.hs4390CostAnnum.doubleValue];
    
    self.outHS3990Dosage.text      = [self round1:mCoolingModel.hs3990Dosage.doubleValue];
    self.outHS3990Usage.text       = [self round1:mCoolingModel.hs3990Usage.doubleValue];
    //self.outHS3990CostKg.text      = [self round2:mCoolingModel.hs3990CostKg.doubleValue];
    //self.outHS3990CostAnnum.text   = [self round1:mCoolingModel.hs3990CostAnnum.doubleValue];
    
    // Biocide values
    
    self.outCS4400Dosage.text      = [self round1:mCoolingModel.cs4400Dosage.doubleValue];
    self.outCS4400Usage.text       = [self round1:mCoolingModel.cs4400Usage.doubleValue];
    //self.outCS4400CostKg.text      = [self round2:mCoolingModel.cs4400CostKg.doubleValue];
    //self.outCS4400CostAnnum.text   = [self round1:mCoolingModel.cs4400CostAnnum.doubleValue];
    
    self.outCS4802Dosage.text      = [self round1:mCoolingModel.cs4802Dosage.doubleValue];
    self.outCS4802Usage.text       = [self round1:mCoolingModel.cs4802Usage.doubleValue];
    //self.outCS4802CostKg.text      = [self round2:mCoolingModel.cs4802CostKg.doubleValue];
    //self.outCS4802CostAnnum.text   = [self round1:mCoolingModel.cs4802CostAnnum.doubleValue];
    
    self.outCS4490Dosage.text      = [self round1:mCoolingModel.cs4490Dosage.doubleValue];
    self.outCS4490Usage.text       = [self round1:mCoolingModel.cs4490Usage.doubleValue];
    //self.outCS4490CostKg.text      = [self round2:mCoolingModel.cs4490CostKg.doubleValue];
    //self.outCS4490CostAnnum.text   = [self round1:mCoolingModel.cs4490CostAnnum.doubleValue];
    
    self.outSCG1Dosage.text        = [self round1:mCoolingModel.scg1Dosage.doubleValue];
    self.outSCG1Usage.text         = [self round1:mCoolingModel.scg1Usage.doubleValue];
    //self.outSCG1CostKg.text        = [self round2:mCoolingModel.scg1CostKg.doubleValue];
    //self.outSCG1CostAnnum.text     = [self round1:mCoolingModel.scg1CostAnnum.doubleValue];
    
    self.outCSchlorDosage.text     = [self round1:mCoolingModel.cschlorDosage.doubleValue];
    self.outCSchlorUsage.text      = [self round1:mCoolingModel.cschlorUsage.doubleValue];
    //self.outCSchlorCostKg.text     = [self round2:mCoolingModel.cschlorCostKg.doubleValue];
    //self.outCSchlorCostAnnum.text  = [self round1:mCoolingModel.cschlorCostAnnum.doubleValue];
    
    self.outC42TDosage.text        = [self round1:mCoolingModel.c42tDosage.doubleValue];
    self.outC42TUsage.text         = [self round1:mCoolingModel.c42tUsage.doubleValue];
    //self.outC42TCostKg.text        = [self round2:mCoolingModel.c42tCostKg.doubleValue];
    //self.outC42TCostAnnum.text     = [self round1:mCoolingModel.c42tCostAnnum.doubleValue];
    
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
    htmlString = [htmlString stringByAppendingString:@"<b>Cooling Water Input Parameters</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    
    // Site Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Site</TR>"];
    row = [NSString stringWithFormat:@"<TD colspan=\"3\">%@</TD>", mCoolingModel.site];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Criteria Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Criteria"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"Circulation", mCoolingModel.inCirculation, @"m<sup>3</sup>/hr"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"∆T", mCoolingModel.inDeltaT, @"°C"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Sump Volume", mCoolingModel.inSumpVolume, @"m3"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"System Volume", mCoolingModel.inSysVolume, @"m3"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Concentration Factor", mCoolingModel.inConcFactor, @""];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Make Up Water Quality Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Make Up Water Quality"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"TDS", mCoolingModel.inTDS, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Total Hardness", mCoolingModel.inTotalHardness, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"M Alk", mCoolingModel.inMAlk, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"pH", mCoolingModel.inPH, @""];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Chlorides", mCoolingModel.inChlorides, @"ppm"];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Duty/Operation Section
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"3\" style=\"background-color:#F0F8FF\">Duty/Operation"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\"><TH>Parameter<TH>Value<TH>Units</TR>"];
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"Hours/Day", mCoolingModel.inHours, @""];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Days/Week", mCoolingModel.inDays, @""];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"Weeks/Year", mCoolingModel.inWeeks, @""];
    htmlString = [htmlString stringByAppendingString:row];
    
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Estimated Product amounts
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    htmlString = [htmlString stringByAppendingString:@"<b>Estimated Cooling Water Products Needed</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    
    // Inhibitor Products
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"6\" style=\"background-color:#F0F8FF\">Inhibitors"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\">"];
    //htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Cost<BR>/kg<TH>Cost<BR>/Annum<TH>Description</TR>"];
    htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Description</TR>"];
    
    //rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP HS2097",
           [self round1:mCoolingModel.hs2097Dosage.doubleValue],
           [self round1:mCoolingModel.hs2097Usage.doubleValue],
           //[self round1:mCoolingModel.hs2097CostKg.doubleValue],
           //[self round1:mCoolingModel.hs2097CostAnnum.doubleValue],
           @"All organic"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP HS4390",
           [self round1:mCoolingModel.hs4390Dosage.doubleValue],
           [self round1:mCoolingModel.hs4390Usage.doubleValue],
           //[self round1:mCoolingModel.hs4390CostKg.doubleValue],
           //[self round1:mCoolingModel.hs4390CostAnnum.doubleValue],
           @"Molybdate/Phosphonate"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP HS3990",
           [self round1:mCoolingModel.hs3990Dosage.doubleValue],
           [self round1:mCoolingModel.hs3990Usage.doubleValue],
           //[self round1:mCoolingModel.hs3990CostKg.doubleValue],
           //[self round1:mCoolingModel.hs3990CostAnnum.doubleValue],
           @"Silicate/Phosphonate"];
    htmlString = [htmlString stringByAppendingString:row];
    
    // Biocide Products
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"6\" style=\"background-color:#F0F8FF\">Biocides"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\">"];
    //htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Cost<BR>/kg<TH>Cost<BR>/Annum<TH>Description</TR>"];
    htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Dosage<BR>(g/m<sup>3</sup>)<TH>Usage<BR>(kg/yr)<TH>Description</TR>"];
    
    //rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP CS4400",
           [self round1:mCoolingModel.cs4400Dosage.doubleValue],
           [self round1:mCoolingModel.cs4400Usage.doubleValue],
           //[self round1:mCoolingModel.cs4400CostKg.doubleValue],
           //[self round1:mCoolingModel.cs4400CostAnnum.doubleValue],
           @"Biocide + Dispersant"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP CS4802",
           [self round1:mCoolingModel.cs4802Dosage.doubleValue],
           [self round1:mCoolingModel.cs4802Usage.doubleValue],
           //[self round1:mCoolingModel.cs4802CostKg.doubleValue],
           //[self round1:mCoolingModel.cs4802CostAnnum.doubleValue],
           @"Bronopol"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP CS4490",
           [self round1:mCoolingModel.cs4490Dosage.doubleValue],
           [self round1:mCoolingModel.cs4490Usage.doubleValue],
           //[self round1:mCoolingModel.cs4490CostKg.doubleValue],
           //[self round1:mCoolingModel.cs4490CostAnnum.doubleValue],
           @"DBNPA"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP SCG1",
           [self round1:mCoolingModel.scg1Dosage.doubleValue],
           [self round1:mCoolingModel.scg1Usage.doubleValue],
           //[self round1:mCoolingModel.scg1CostKg.doubleValue],
           //[self round1:mCoolingModel.scg1CostAnnum.doubleValue],
           @"SDIC"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP CSChlor",
           [self round1:mCoolingModel.cschlorDosage.doubleValue],
           [self round1:mCoolingModel.cschlorUsage.doubleValue],
           //[self round1:mCoolingModel.cschlorCostKg.doubleValue],
           //[self round1:mCoolingModel.cschlorCostAnnum.doubleValue],
           @"Cal Hypo Tablets"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat,
           @"WTP C42T",
           [self round1:mCoolingModel.c42tDosage.doubleValue],
           [self round1:mCoolingModel.c42tUsage.doubleValue],
           //[self round1:mCoolingModel.c42tCostKg.doubleValue],
           //[self round1:mCoolingModel.c42tCostAnnum.doubleValue],
           @"Bromine tablets (brominator)"];
    htmlString = [htmlString stringByAppendingString:row];
    
    //end table
    htmlString = [htmlString stringByAppendingString:@"</TABLE>"];
    
    // Disclaimer
    htmlString = [htmlString stringByAppendingString:disclaimer];
    htmlString = [htmlString stringByAppendingString:@"<br>"];
    return htmlString;
}

// Action to launch email app
- (IBAction) sendEmail:(id)sender {
    
    NSLog(@"CoolingProductsTableViewController:sendEmail:");
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        
        
        // Set email parameters
        
        //NSArray *toRecipients = [NSArray arrayWithObject:email];
        
        [mcvc setSubject:@"Cooling Water Product Estimates (WTP)"];
        
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
