//
//  MainSelections.m
//  WTP
//
//  Created by Phil Price on 01/26/16.
//  Copyright (c) 2016 Nateemma. All rights reserved.
//

#import "MainView.h"
#import "BoilerWaterModel.h"
#import "CoolingWaterModel.h"

@implementation MainView


BoilerWaterModel *mBoilerModel ;
CoolingWaterModel *mCoolingModel;

////////////////////////////////////////////////
// Inherited Methods
////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"MainView.m");
    
    // create the model objects
    mBoilerModel = [BoilerWaterModel sharedInstance];
    mCoolingModel = [CoolingWaterModel sharedInstance];
    
    // load previous values
    [mBoilerModel restore];
    [mCoolingModel restore];
    
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


////////////////////////////////////////////////
// Handlers for buttons
////////////////////////////////////////////////

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    // don't let the default transition happen (only allow from a buton press)
    if (([identifier isEqualToString:SEGUE_BOILER_INPUT ]) ||
        ([identifier isEqualToString:SEGUE_COOLING_INPUT ])){
        return NO;
        
    } else {
        return YES;
    }
}

- (IBAction)startBoilerSolids:(id)sender{
    NSLog(@"startBoilerSolids");
    
    // initiate transition to next display
    [mBoilerModel setProductType:SOLID];
    [self performSegueWithIdentifier:SEGUE_BOILER_INPUT sender:self];
}

- (IBAction)startBoilerLiquids:(id)sender{
    NSLog(@"startBoilerLiquids");
    
    // initiate transition to next display
    [mBoilerModel setProductType:LIQUID];
    [self performSegueWithIdentifier:SEGUE_BOILER_INPUT sender:self];
}

- (IBAction)startCoolingSolids:(id)sender{
    NSLog(@"startCoolingSolids");
    
    // initiate transition to next display
    [mCoolingModel setProductType:SOLID];
    [self performSegueWithIdentifier:SEGUE_COOLING_INPUT sender:self];
}

- (IBAction)startCoolingLiquids:(id)sender{
    NSLog(@"startCoolingLiquids");
    
    // initiate transition to next display
    [mCoolingModel setProductType:LIQUID];
    [self performSegueWithIdentifier:SEGUE_COOLING_INPUT sender:self];
}


@end
