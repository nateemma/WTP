//
//  BoilerWaterModel.m
//  WTP
//
//  Created by Phil Price on 9/2/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//  01/23/14 - added support for liquid products


#import "BoilerWaterModel.h"

@implementation BoilerWaterModel




////////////////////////////////////////////////
// Singleton-related methods:
////////////////////////////////////////////////

// Static data members
static ProductType currProductType;
static BoilerWaterModel *sharedInstance = nil;

// Get the shared instance and create it if necessary.
// This is the thread-safe version

+ (BoilerWaterModel *)sharedInstance {
    if (nil != sharedInstance) {
        NSLog(@"BoilerWaterModel: already initialised");
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[BoilerWaterModel alloc] init];
    });
    NSLog(@"BoilerWaterModel: Created new BoilerWaterModel");
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        
        currProductType = NONE;
    }
    
    return self;
}




////////////////////////////////////////////////
// Product Type methods (not persistent)
////////////////////////////////////////////////

- (void)setProductType:(ProductType)productType {
    currProductType = productType;
}

- (ProductType)getProductType {
    return currProductType;
}

////////////////////////////////////////////////
// Persistence methods
////////////////////////////////////////////////

// method to get the file name
- (NSString *)dataFilePath {
    NSString   *savePath = [@"~/Documents/boiler.plist" stringByExpandingTildeInPath];
    return savePath;
}

// method to check whether data has already been saved (mainly for first usage)
- (BOOL) savedDataPresent {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]];
    return fileExists;
}

// reloads previously used data (if any)
- (void) restore {
    
    @try {
        if ([self savedDataPresent]){
            NSLog(@"BoilerWaterModel: Loading previous values...");
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];
            
            sharedInstance.site            = [dict objectForKey:@"inSite"];
            sharedInstance.inSumSteam      = [dict objectForKey:@"inSumSteam"];
            sharedInstance.inSumHours      = [dict objectForKey:@"inSumHours"];
            sharedInstance.inSumDays       = [dict objectForKey:@"inSumDays"];
            sharedInstance.inSumWeeks      = [dict objectForKey:@"inSumWeeks"];
            sharedInstance.inWinSteam      = [dict objectForKey:@"inWinSteam"];
            sharedInstance.inWinHours      = [dict objectForKey:@"inWinHours"];
            sharedInstance.inWinDays       = [dict objectForKey:@"inWinDays"];
            sharedInstance.inWinWeeks      = [dict objectForKey:@"inWinWeeks"];
            sharedInstance.inTDS           = [dict objectForKey:@"inTDS"];
            sharedInstance.inMAlk          = [dict objectForKey:@"inMAlk"];
            sharedInstance.inPH            = [dict objectForKey:@"inPH"];
            sharedInstance.inCaHardness    = [dict objectForKey:@"inCaHardness"];
            sharedInstance.inTemp          = [dict objectForKey:@"inTemp"];
            sharedInstance.inMaxTDS        = [dict objectForKey:@"inMaxTDS"];
            sharedInstance.inMinSulphite   = [dict objectForKey:@"inMinSulphite"];
            sharedInstance.inMinCausticAlk = [dict objectForKey:@"inMinCausticAlk"];
            
            // Log the retrieved values
            NSLog(@"BoilerWaterModel: retrieved values from file:");
            for (id key in dict) {
                NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
            }
            
            // load binary version of data from saved strings
            
            if (sharedInstance.inSumSteam.length>0) {
                sharedInstance.sumSteam = [NSNumber numberWithFloat:[sharedInstance.inSumSteam floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inSumSteam not defined");
            }
            
            if (sharedInstance.inSumHours.length>0){
                sharedInstance.sumHours = [NSNumber numberWithFloat:[sharedInstance.inSumHours floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inSumHours not defined");
            }
            
            if (sharedInstance.inSumDays.length>0){
                sharedInstance.sumDays = [NSNumber numberWithFloat:[sharedInstance.inSumDays floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inSumDays not defined");
            }
            
            if (sharedInstance.inSumWeeks.length>0){
                sharedInstance.sumWeeks = [NSNumber numberWithFloat:[sharedInstance.inSumWeeks floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inSumWeeks not defined");
            }
            
            if (sharedInstance.inWinSteam.length>0){
                sharedInstance.winSteam = [NSNumber numberWithFloat:[sharedInstance.inWinSteam floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inWinSteam not defined");
            }
            
            if (sharedInstance.inWinHours.length>0){
                sharedInstance.winHours = [NSNumber numberWithFloat:[sharedInstance.inWinHours floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inWinHours not defined");
            }
            
            if (sharedInstance.inWinDays.length>0){
                sharedInstance.winDays = [NSNumber numberWithFloat:[sharedInstance.inWinDays floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inWinDays not defined");
            }
            
            if (sharedInstance.inWinWeeks.length>0){
                sharedInstance.winWeeks = [NSNumber numberWithFloat:[sharedInstance.inWinWeeks floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inWinWeeks not defined");
            }
            
            if (sharedInstance.inTDS.length>0){
                sharedInstance.TDS = [NSNumber numberWithFloat:[sharedInstance.inTDS floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inTDS not defined");
            }
            
            if (sharedInstance.inMAlk.length>0){
                sharedInstance.MAlk = [NSNumber numberWithFloat:[sharedInstance.inMAlk floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inMAlk not defined");
            }
            
            if (sharedInstance.inPH.length>0){
                sharedInstance.pH = [NSNumber numberWithFloat:[sharedInstance.inPH floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inPH not defined");
            }
            
            if (sharedInstance.inCaHardness.length>0){
                sharedInstance.CaHardness = [NSNumber numberWithFloat:[sharedInstance.inCaHardness floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inCaHardness not defined");
            }
            
            if (sharedInstance.inTemp.length>0){
                sharedInstance.temp = [NSNumber numberWithFloat:[sharedInstance.inTemp floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inTemp not defined");
            }
            
            if (sharedInstance.inMaxTDS.length>0){
                sharedInstance.maxTDS = [NSNumber numberWithFloat:[sharedInstance.inMaxTDS floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inMaxTDS not defined");
            }
            
            if (sharedInstance.inMinSulphite.length>0){
                sharedInstance.minSulphite = [NSNumber numberWithFloat:[sharedInstance.inMinSulphite floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inMinSulphite not defined");
            }
            
            if (sharedInstance.inMinCausticAlk.length>0){
                sharedInstance.minCausticAlk = [NSNumber numberWithFloat:[sharedInstance.inMinCausticAlk floatValue]];
            }  else {
                NSLog(@"BoilerInputViewController: inMinCausticAlk not defined");
            }
            
        } else {
            NSLog(@"BoilerWaterModel: no saved parameters found");
        }
        
    }
    @catch (NSException *e) {
        NSLog(@"BoilerWaterModel.restore - exception: %@", e.reason);
    }
    
}


// save current data for next activation
- (void) save {
    
    @try {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]  init];
        
        [dict setObject:sharedInstance.site             forKey:@"inSite"];
        [dict setObject:sharedInstance.inSumSteam       forKey:@"inSumSteam"];
        [dict setObject:sharedInstance.inSumHours       forKey:@"inSumHours"];
        [dict setObject:sharedInstance.inSumDays        forKey:@"inSumDays"];
        [dict setObject:sharedInstance.inSumWeeks       forKey:@"inSumWeeks"];
        [dict setObject:sharedInstance.inWinSteam       forKey:@"inWinSteam"];
        [dict setObject:sharedInstance.inWinHours       forKey:@"inWinHours"];
        [dict setObject:sharedInstance.inWinDays        forKey:@"inWinDays"];
        [dict setObject:sharedInstance.inWinWeeks       forKey:@"inWinWeeks"];
        [dict setObject:sharedInstance.inTDS            forKey:@"inTDS"];
        [dict setObject:sharedInstance.inMAlk           forKey:@"inMAlk"];
        [dict setObject:sharedInstance.inPH             forKey:@"inPH"];
        [dict setObject:sharedInstance.inCaHardness     forKey:@"inCaHardness"];
        [dict setObject:sharedInstance.inTemp           forKey:@"inTemp"];
        [dict setObject:sharedInstance.inMaxTDS         forKey:@"inMaxTDS"];
        [dict setObject:sharedInstance.inMinSulphite    forKey:@"inMinSulphite"];
        [dict setObject:sharedInstance.inMinCausticAlk  forKey:@"inMinCausticAlk"];
        
        [dict writeToFile:[self dataFilePath] atomically: YES];
        
        // Log the retrieved values
        NSLog(@"BoilerWaterModel: Saving values...");
        for (id key in dict) {
            NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
        }
    }
    @catch (NSException *e) {
        NSLog(@"BoilerWaterModel.save - exception: %@", e.reason);
    }
    
}

////////////////////////////////////////////////
// Functional logic
////////////////////////////////////////////////


// checks that inputs have been defined and are valid
- (BOOL) inputsValid{
    return YES; // TEMP TEMP TEMP
}


// function to calculate product amounts based on input data
// Note, assumes that all data is correctly entered (i.e. checked elsewhere before calling)

// lookup data for dissolved O2
static float lookupData [] = { 6.8, 6.2, 5.7, 5.2, 4.7, 4.25, 3.8, 3.4, 2.8, 2.2, 1.6, 0.7 };

- (void)calculateAmounts {
    NSLog(@"BoilerWaterModel: calculateAmounts()");
    
    double tmp; // temp variable for holding double values
    double tmp2;
    
    @try {
        // Annual Feed
        tmp = ((self.sumSteam.doubleValue / 2200.00) * self.sumHours.doubleValue * self.sumDays.doubleValue * self.sumWeeks.doubleValue) +
        ((self.winSteam.doubleValue / 2200.00) * self.winHours.doubleValue * self.winDays.doubleValue * self.winWeeks.doubleValue) ;
        
        self.annualFeed = [NSNumber numberWithDouble:(tmp)];
        
        // Dissolved Oxygen
        int idx = (int) (self.temp.floatValue - 40.0) / 5;
        int maxIdx = (sizeof (lookupData)/sizeof(float)) - 1;
        if ((idx<0) || (idx>maxIdx)){
            NSLog(@"BoilerWaterModel: Oops, temp index out of range!!! temp:%.02f index:%d", self.temp.floatValue, idx);
            if (idx > maxIdx){
                tmp = lookupData[maxIdx];
                self.dissolvedO2 = [NSNumber numberWithDouble:(tmp)];
            } else {
                self.dissolvedO2 = [NSNumber numberWithDouble:(0.0)];
            }
        } else {
            tmp = lookupData[idx];
            self.dissolvedO2 = [NSNumber numberWithDouble:(tmp)];
        }
        NSLog(@"BoilerWaterModel: temp:%.02f idx:%i, O2:%.01f (maxIdx:%i)", self.temp.floatValue, idx, self.dissolvedO2.doubleValue, maxIdx);
        
        // Product Amounts - SOLIDS
        
        // SS1294
        tmp = (220.0 / (self.maxTDS.doubleValue / self.TDS.doubleValue));
        self.ss1294Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss1294Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss1294Usage = [NSNumber numberWithDouble:(tmp)];
        
        // SS1295
        tmp = (self.dissolvedO2.doubleValue * 10.0) + (35.0 / (self.maxTDS.doubleValue / self.TDS.doubleValue));
        self.ss1295Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss1295Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss1295Usage = [NSNumber numberWithDouble:(tmp)];
        
        // SS1350
        tmp = (self.dissolvedO2.doubleValue * 10.0) + (35.0 / (self.maxTDS.doubleValue / self.TDS.doubleValue));
        self.ss1350Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss1350Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss1350Usage = [NSNumber numberWithDouble:(tmp)];
        
        // SS1095
        tmp = (self.dissolvedO2.doubleValue * 9.0) + (28.0 / (self.maxTDS.doubleValue / self.TDS.doubleValue));
        self.ss1095Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss1095Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss1095Usage = [NSNumber numberWithDouble:(tmp)];
        
        // SS1995
        tmp = (self.CaHardness.doubleValue - self.MAlk.doubleValue) + ((1000.0 - self.minCausticAlk.doubleValue) / (self.maxTDS.doubleValue / self.TDS.doubleValue));
        
        // -ve number means no need for product, so reset to 0.0
        if (tmp < 0.0){
            self.ss1995Dosage = [NSNumber numberWithDouble:(0.0)];
            self.ss1995Usage = [NSNumber numberWithDouble:(0.0)];
        } else {
            self.ss1995Dosage = [NSNumber numberWithDouble:(tmp)];
            
            tmp = self.ss1995Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
            self.ss1995Usage = [NSNumber numberWithDouble:(tmp)];
        }
        
        // SS2295
        tmp = (45.0 / (self.maxTDS.doubleValue / self.TDS.doubleValue)) + (1.11 * self.CaHardness.doubleValue);
        self.ss2295Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss2295Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss2295Usage = [NSNumber numberWithDouble:(tmp)];
        
        // SS8985
        tmp = (self.MAlk.doubleValue / 3.0);
        self.ss8985Dosage = [NSNumber numberWithDouble:(tmp)];
        
        tmp = self.ss8985Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0 ;
        self.ss8985Usage = [NSNumber numberWithDouble:(tmp)];
        
        
        // Product Amounts - LIQUIDS
        
        
        tmp = 15.0 / 100.0 * self.maxTDS.doubleValue;
        self.minAlkalinity = [NSNumber numberWithDouble:(tmp)];
        NSLog(@"BoilerWaterModel: minAlk:%.02f", self.minAlkalinity.doubleValue);
        
        tmp2 = self.maxTDS.doubleValue / self.TDS.doubleValue; // common term
        
        // S5
        self.s5Dosage = [NSNumber numberWithDouble:(self.dissolvedO2.doubleValue*35.0 +(120.0 / tmp2))];
        self.s5Usage = [NSNumber numberWithDouble:(self.s5Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S10
        self.s10Dosage = [NSNumber numberWithDouble:(self.dissolvedO2.doubleValue*18.0 +(65.0 / tmp2))];
        self.s10Usage = [NSNumber numberWithDouble:(self.s10Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S123
        self.s123Dosage = [NSNumber numberWithDouble:(self.dissolvedO2.doubleValue*65.0 +(150.0 / tmp2))];
        self.s123Usage = [NSNumber numberWithDouble:(self.s123Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S125
        self.s125Dosage = [NSNumber numberWithDouble:(self.dissolvedO2.doubleValue*40.0 +(240.0 / tmp2))];
        self.s125Usage = [NSNumber numberWithDouble:(self.s125Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S26
        self.s26Dosage = [NSNumber numberWithDouble:((600.0 / tmp2))];
        self.s26Usage = [NSNumber numberWithDouble:(self.s26Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S28
        self.s28Dosage = [NSNumber numberWithDouble:((600.0 / tmp2))];
        self.s28Usage = [NSNumber numberWithDouble:(self.s28Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S19
        self.s19Dosage =  [NSNumber numberWithDouble:(self.CaHardness.doubleValue - self.MAlk.doubleValue + ((1000.0-self.minAlkalinity.doubleValue) / tmp2))];
        if (self.s19Dosage.doubleValue < 0.0){
            self.s19Usage = [NSNumber numberWithDouble:(0.0)] ;
            self.s19Dosage = [NSNumber numberWithDouble:(0.0)] ;
        } else {
            self.s19Usage = [NSNumber numberWithDouble:(self.s19Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        }
        
        // S456
        self.s456Dosage = [NSNumber numberWithDouble:(150.0 * (self.CaHardness.doubleValue+0.25) / tmp2)] ;
        self.s456Usage = [NSNumber numberWithDouble:(self.s456Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S124
        self.s124Dosage = [NSNumber numberWithDouble:((1200.0 / tmp2))];
        self.s124Usage = [NSNumber numberWithDouble:(self.s124Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S22
        self.s22Dosage = [NSNumber numberWithDouble:((200.0 / tmp2) + (4.0 * self.CaHardness.doubleValue))];
        self.s22Usage = [NSNumber numberWithDouble:(self.s22Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S23
        self.s23Dosage = [NSNumber numberWithDouble:((1000.0 / tmp2) + (20.0 * self.CaHardness.doubleValue))];
        self.s23Usage = [NSNumber numberWithDouble:(self.s23Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S88
        self.s88Dosage = [NSNumber numberWithDouble:(3.0 * self.MAlk.doubleValue)];
        self.s88Usage = [NSNumber numberWithDouble:(self.s88Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;
        
        // S95
        self.s95Dosage = [NSNumber numberWithDouble:(5.0 * self.MAlk.doubleValue)];
        self.s95Usage = [NSNumber numberWithDouble:(self.s95Dosage.doubleValue * self.annualFeed.doubleValue / 1000.0)] ;


    }
    @catch (NSException *e) {
        NSLog(@"BoilerWaterModel.calculateAmounts - exception: %@", e.reason);
    }
}

@end
