//
//  InfoTableViewController.h
//  WTP
//
//  Created by Phil Price on 9/16/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InfoTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *website;
@property (retain, nonatomic) IBOutlet UILabel *phone;
@property (retain, nonatomic) IBOutlet UILabel *salesEmail;
@property (retain, nonatomic) IBOutlet UILabel *helpEmail;
@property (retain, nonatomic) IBOutlet UILabel *infoEmail;
@property (retain, nonatomic) IBOutlet UILabel *distributorEmail;
@property (retain, nonatomic) IBOutlet UILabel *leisureEmail;
@property (retain, nonatomic) IBOutlet UILabel *mediaEmail;
@property (retain, nonatomic) IBOutlet UILabel *officeAddress;

- (IBAction)showURL:(id)sender;
- (IBAction)callNumber:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)showMap:(id)sender;

@end
