//
//  MainView.h
//  WTP
//
//  Created by Phil Price on 01/26/16.
//  Copyright (c) 2016 Nateemma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GradientButton.h"

@interface MainView : UIViewController


@property (retain, nonatomic) IBOutlet GradientButton *boilerSolidsBtn;
@property (retain, nonatomic) IBOutlet GradientButton *boilerLiquidsBtn;
@property (retain, nonatomic) IBOutlet GradientButton *coolingSolidsBtn;
@property (retain, nonatomic) IBOutlet GradientButton *coolingLiquidsBtn;

- (IBAction)startBoilerSolids:(id)sender;
- (IBAction)startBoilerLiquids:(id)sender;
- (IBAction)startCoolingSolids:(id)sender;
- (IBAction)startCoolingLiquids:(id)sender;

@end
