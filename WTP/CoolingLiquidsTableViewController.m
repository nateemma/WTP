//
//  CoolingLiquidsTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/18/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "CoolingLiquidsTableViewController.h"
#import "CoolingWaterModel.h"

@implementation CoolingLiquidsTableViewController


// Object to hold Cooling data
CoolingWaterModel *mCoolingModel;



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
        NSLog(@"CoolingLiquidsTVC: loading data...");
        mCoolingModel = [CoolingWaterModel sharedInstance];
        
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
    
    self.outH207Dosage.text   = [self round1:mCoolingModel.h207Dosage.doubleValue];
    self.outH207Usage.text    = [self round1:mCoolingModel.h207Usage.doubleValue];
    self.outH2073Dosage.text  = [self round1:mCoolingModel.h2073Dosage.doubleValue];
    self.outH2073Usage.text   = [self round1:mCoolingModel.h2073Usage.doubleValue];
    self.outH280Dosage.text   = [self round1:mCoolingModel.h280Dosage.doubleValue];
    self.outH280Usage.text    = [self round1:mCoolingModel.h280Usage.doubleValue];
    self.outH2805Dosage.text  = [self round1:mCoolingModel.h2805Dosage.doubleValue];
    self.outH2805Usage.text   = [self round1:mCoolingModel.h2805Usage.doubleValue];
    self.outH390Dosage.text   = [self round1:mCoolingModel.h390Dosage.doubleValue];
    self.outH390Usage.text    = [self round1:mCoolingModel.h390Usage.doubleValue];
    self.outH3905Dosage.text  = [self round1:mCoolingModel.h3905Dosage.doubleValue];
    self.outH3905Usage.text   = [self round1:mCoolingModel.h3905Usage.doubleValue];
    self.outH391Dosage.text   = [self round1:mCoolingModel.h391Dosage.doubleValue];
    self.outH391Usage.text    = [self round1:mCoolingModel.h391Usage.doubleValue];
    self.outH423Dosage.text   = [self round1:mCoolingModel.h423Dosage.doubleValue];
    self.outH423Usage.text    = [self round1:mCoolingModel.h423Usage.doubleValue];
    self.outH425Dosage.text   = [self round1:mCoolingModel.h425Dosage.doubleValue];
    self.outH425Usage.text    = [self round1:mCoolingModel.h425Usage.doubleValue];
    self.outH4255Dosage.text  = [self round1:mCoolingModel.h4255Dosage.doubleValue];
    self.outH4255Usage.text   = [self round1:mCoolingModel.h4255Usage.doubleValue];
    self.outH535Dosage.text   = [self round1:mCoolingModel.h535Dosage.doubleValue];
    self.outH535Usage.text    = [self round1:mCoolingModel.h535Usage.doubleValue];
    self.outH874Dosage.text   = [self round1:mCoolingModel.h874Dosage.doubleValue];
    self.outH874Usage.text    = [self round1:mCoolingModel.h874Usage.doubleValue];
    
    // Biocide values
    
    self.outC31Dosage.text   = [self round1:mCoolingModel.c31Dosage.doubleValue];
    self.outC31Usage.text    = [self round1:mCoolingModel.c31Usage.doubleValue];
    self.outC32Dosage.text   = [self round1:mCoolingModel.c32Dosage.doubleValue];
    self.outC32Usage.text    = [self round1:mCoolingModel.c32Usage.doubleValue];
    self.outC44Dosage.text   = [self round1:mCoolingModel.c44Dosage.doubleValue];
    self.outC44Usage.text    = [self round1:mCoolingModel.c44Usage.doubleValue];
    self.outC45Dosage.text   = [self round1:mCoolingModel.c45Dosage.doubleValue];
    self.outC45Usage.text    = [self round1:mCoolingModel.c45Usage.doubleValue];
    self.outC48Dosage.text   = [self round1:mCoolingModel.c48Dosage.doubleValue];
    self.outC48Usage.text    = [self round1:mCoolingModel.c48Usage.doubleValue];
    self.outC51Dosage.text   = [self round1:mCoolingModel.c51Dosage.doubleValue];
    self.outC51Usage.text    = [self round1:mCoolingModel.c51Usage.doubleValue];
    self.outC52Dosage.text   = [self round1:mCoolingModel.c52Dosage.doubleValue];
    self.outC52Usage.text    = [self round1:mCoolingModel.c52Usage.doubleValue];
    self.outC54Dosage.text   = [self round1:mCoolingModel.c54Dosage.doubleValue];
    self.outC54Usage.text    = [self round1:mCoolingModel.c54Usage.doubleValue];
    self.outC58Dosage.text   = [self round1:mCoolingModel.c58Dosage.doubleValue];
    self.outC58Usage.text    = [self round1:mCoolingModel.c58Usage.doubleValue];
}


// routine to build HTML Summary of data
- (NSString *)buildHTMLsummary{
    NSString *htmlString; // string to hold the HTML Data
    NSString *row;        // String to hold data for a row
    NSString *rowFormat;  // String to hold format template for row data
    NSString *disclaimer = @"<p><i>Disclaimer</i>: the values shown are estimates only.<p>";
    
    htmlString = @"<p>Below are the input parameters used for the calculations, and the resulting cooling (liquid) product estimates:</p>";
    
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
    htmlString = [htmlString stringByAppendingString:@"<b>Estimated Cooling Water (Liquid) Products Needed</b>"];
    htmlString = [htmlString stringByAppendingString:@"<TABLE border=\"1\" style=\"border-collapse:collapse; border: 1px solid black;\">"];
    
    // Inhibitor Products
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"6\" style=\"background-color:#F0F8FF\">Inhibitors"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\">"];
    htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Dosage<BR>(mg/L in system)<TH>Litres/Annum<BR>(estimated)<TH>Description</TR>"];

    
    
    // add products row data
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    row = [NSString stringWithFormat:rowFormat, @"WTP H207",
                  [self round1:mCoolingModel.h207Dosage.doubleValue],
                  [self round1:mCoolingModel.h207Usage.doubleValue],
                  @"Scale inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H2073",
                  [self round1:mCoolingModel.h2073Dosage.doubleValue],
                  [self round1:mCoolingModel.h2073Usage.doubleValue],
                  @"Scale inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H280",
                  [self round1:mCoolingModel.h280Dosage.doubleValue],
                  [self round1:mCoolingModel.h280Usage.doubleValue],
                  @"Scale/corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H2805",
                  [self round1:mCoolingModel.h2805Dosage.doubleValue],
                  [self round1:mCoolingModel.h2805Usage.doubleValue],
                  @"Scale/corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H390",
                  [self round1:mCoolingModel.h390Dosage.doubleValue],
                  [self round1:mCoolingModel.h390Usage.doubleValue],
                  @"Corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H3905",
                  [self round1:mCoolingModel.h3905Dosage.doubleValue],
                  [self round1:mCoolingModel.h3905Usage.doubleValue],
                  @"Corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H391",
                  [self round1:mCoolingModel.h391Dosage.doubleValue],
                  [self round1:mCoolingModel.h391Usage.doubleValue],
                  @"Corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H423",
                  [self round1:mCoolingModel.h423Dosage.doubleValue],
                  [self round1:mCoolingModel.h423Usage.doubleValue],
                  @"Scale/corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H425",
                  [self round1:mCoolingModel.h425Dosage.doubleValue],
                  [self round1:mCoolingModel.h425Usage.doubleValue],
                  @"Corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H4255",
                  [self round1:mCoolingModel.h4255Dosage.doubleValue],
                  [self round1:mCoolingModel.h4255Usage.doubleValue],
                  @"Corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H535",
                  [self round1:mCoolingModel.h535Dosage.doubleValue],
                  [self round1:mCoolingModel.h535Usage.doubleValue],
                  @"Scale/corrosion inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP H874",
                  [self round1:mCoolingModel.h874Dosage.doubleValue],
                  [self round1:mCoolingModel.h874Usage.doubleValue],
                  @"Scale inhibitor"];
    htmlString = [htmlString stringByAppendingString:row];
    
    
    
    // Biocide Products
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"6\" style=\"background-color:#F0F8FF\">Biocides (Non-Oxidisers)"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\">"];
    htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Minimum Dose<BR>(ppm)<TH>Litres/Annum<BR>(estimated)<TH>Description</TR>"];
    
    // add biocides row data
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";
    
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C31 IsoT",
                  [self round1:mCoolingModel.c31Dosage.doubleValue],
                  [self round1:mCoolingModel.c31Usage.doubleValue],
                  @"Isothiazalones"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C32 IsoT",
                  [self round1:mCoolingModel.c32Dosage.doubleValue],
                  [self round1:mCoolingModel.c32Usage.doubleValue],
                  @"Isothiazalones"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C44 DBNPA",
                  [self round1:mCoolingModel.c44Dosage.doubleValue],
                  [self round1:mCoolingModel.c44Usage.doubleValue],
                  @"DBNPA"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C45 Glut",
                  [self round1:mCoolingModel.c45Dosage.doubleValue],
                  [self round1:mCoolingModel.c45Usage.doubleValue],
                  @"Glutaraldehyde"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C48 BNPD",
                  [self round1:mCoolingModel.c48Dosage.doubleValue],
                  [self round1:mCoolingModel.c48Usage.doubleValue],
                  @"Bronopol BNPD"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C51 THPS",
                  [self round1:mCoolingModel.c51Dosage.doubleValue],
                  [self round1:mCoolingModel.c51Usage.doubleValue],
                  @"THPS"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C52 Quat",
                  [self round1:mCoolingModel.c52Dosage.doubleValue],
                  [self round1:mCoolingModel.c52Usage.doubleValue],
                  @"BAC Quat"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C54 Poly Quat",
                  [self round1:mCoolingModel.c54Dosage.doubleValue],
                  [self round1:mCoolingModel.c54Usage.doubleValue],
                  @"Poly Quat"];
    htmlString = [htmlString stringByAppendingString:row];
    
    row = [NSString stringWithFormat:rowFormat, @"WTP C58 DDMQ",
                  [self round1:mCoolingModel.c58Dosage.doubleValue],
                  [self round1:mCoolingModel.c58Usage.doubleValue],
                  @"DDQ Quat"];
    htmlString = [htmlString stringByAppendingString:row];
    

    
    // Biocide (oxidising)Products
    htmlString = [htmlString stringByAppendingString:@"<TR><TH colspan=\"6\" style=\"background-color:#F0F8FF\">Biocides (Oxidising)"];
    htmlString = [htmlString stringByAppendingString:@"<TR style=\"background-color:#FFE0B2\">"];
    htmlString = [htmlString stringByAppendingString:@"<TH>Product<TH>Minimum Free<BR>Halogen<TH> <TH>Description</TR>"];
    
    // add  row data
    rowFormat = @"<TR><TD>%@<TD>%@<TD>%@<TD>%@</TR>";

    row = [NSString stringWithFormat:rowFormat, @"WTP C42T BCDMH",     @"1-3 ppm", @"as required by L8", @"BCDMH 20g tablet"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"WTP UB30 Bromine",   @"1-3 ppm", @"as required by L8", @"Liquid bromine"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"WTP Chlor 10 NaOCl", @"1-3 ppm", @"as required by L8", @"Sodium hypochlorite"];
    htmlString = [htmlString stringByAppendingString:row];
    row = [NSString stringWithFormat:rowFormat, @"WTP B20 Bromide",    @"1-3 ppm", @"as required by L8", @"Sodium Bromide"];
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
    
    NSLog(@"CoolingLiquidsTVC:sendEmail:");
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        
        
        // Set email parameters
        
        //NSArray *toRecipients = [NSArray arrayWithObject:email];
        
        [mcvc setSubject:@"WTP Cooling Water Liquid Product Estimates (WTP)"];
        
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
