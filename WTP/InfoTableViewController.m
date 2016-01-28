//
//  InfoTableViewController.m
//  WTP
//
//  Created by Phil Price on 9/16/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "InfoTableViewController.h"


////////////////////////////////////////
// Data for the table displays
////////////////////////////////////////

NSArray *sectionTitles ;

@implementation InfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // perform initialisation
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"InfoTableViewController.m");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// NOTE: table is statically defined, so no need to define the following methods
/*
 #pragma mark - Table view data source
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 // Return the number of sections.
 return 0;
 }
 
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 0;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // not really anything to do. Actions are via the 'hidden' buttons
}


// Action to launch browsser and go to URL
- (IBAction)showURL:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSString *url = [[btn titleLabel]text];
    NSLog(@"showURL:%@", url);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


// Action to launch phone app with specified number
- (IBAction)callNumber:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    //NSString *number = @"telprompt://";
    NSString *number = @"tel://";
    number = [number stringByAppendingString:btn.titleLabel.text];
    NSLog(@"callNumber:%@", number);
    
    NSURL  *url= [NSURL URLWithString:number];
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    
    if ([osVersion floatValue] >= 3.1) {
        NSLog(@"Creating webview for: %@", url);
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        [webview loadRequest:[NSURLRequest requestWithURL:url]];
        webview.hidden = YES;
        // Assume we are in a view controller and have access to self.view
        [self.view addSubview:webview];
    } else {
        // On 3.0 and below, dial as usual
        NSLog(@"Launching phone app for: %@", url);
        [[UIApplication sharedApplication] openURL: url];
    }
}


// Action to launch email app
- (IBAction) sendEmail:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSString *email = btn.titleLabel.text;
    NSLog(@"sendEmail:%@", email);
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
        mcvc.mailComposeDelegate = self;
        
        
        // Set email parameters
        
        // Email Subject
        //NSString *emailTitle = @"Test Email";
        // Email Content
        //NSString *messageBody = @"iOS programming is so fun!";
        // To address
        NSArray *toRecipients = [NSArray arrayWithObject:email];
        
        [mcvc setSubject:@""];
        [mcvc setMessageBody:@"" isHTML:NO];
        [mcvc setToRecipients:toRecipients];
        
        
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



// Action to launch maps app for specified address
- (IBAction) showMap:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *address = btn.titleLabel.text;
    NSLog(@"showMap:%@", address);
    
    // URL encode the spaces
    
    address =  [address stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    NSString* urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", address];
    NSURL *url = [NSURL URLWithString:urlText];
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@"Google Maps app is not installed, try Apple instead...");
        urlText = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@", address];
        url = [NSURL URLWithString:urlText];
    }
    
    // lets throw this text on the log so we can view the url in the event we have an issue
    
    NSLog(@"Opening:%@", url);
    [[UIApplication sharedApplication] openURL:url];
    
}

@end
