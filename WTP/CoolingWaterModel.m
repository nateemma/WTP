//
//  CoolingWaterModel.m
//  WTP
//
//  Created by Phil Price on 9/16/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//  11/6/13 - removed cost parameters by customer request (commented out for now)
//  01/23/14 - added support for liquid products
//
//

#import "CoolingWaterModel.h"

@implementation CoolingWaterModel


////////////////////////////////////////////////
// Singleton-related methods:
////////////////////////////////////////////////


static ProductType currProductType;
static CoolingWaterModel *sharedInstance = nil;

// Get the shared instance and create it if necessary.
// This is the thread-safe version

+ (CoolingWaterModel *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[CoolingWaterModel alloc] init];
    });
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // set the values to an invalid value
        self.circulation   = [NSNumber numberWithDouble:(-1)];
        self.deltaT        = [NSNumber numberWithDouble:(-1)];
        self.sumpVolume    = [NSNumber numberWithDouble:(-1)];
        self.sysVolume     = [NSNumber numberWithDouble:(-1)];
        self.concFactor    = [NSNumber numberWithDouble:(-1)];
        self.TDS           = [NSNumber numberWithDouble:(-1)];
        self.totalHardness = [NSNumber numberWithDouble:(-1)];
        self.MAlk          = [NSNumber numberWithDouble:(-1)];
        self.pH            = [NSNumber numberWithDouble:(-1)];
        self.chlorides     = [NSNumber numberWithDouble:(-1)];
        self.hours         = [NSNumber numberWithDouble:(-1)];
        self.days          = [NSNumber numberWithDouble:(-1)];
        self.weeks         = [NSNumber numberWithDouble:(-1)];
        
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
    NSString   *savePath = [@"~/Documents/cooling.plist" stringByExpandingTildeInPath];
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
            sharedInstance.inCirculation   = [dict objectForKey:@"inCirculation"];
            sharedInstance.inDeltaT        = [dict objectForKey:@"inDeltaT"];
            sharedInstance.inSumpVolume    = [dict objectForKey:@"inSumpVolume"];
            sharedInstance.inSysVolume     = [dict objectForKey:@"inSysVolume"];
            sharedInstance.inConcFactor    = [dict objectForKey:@"inConcFactor"];
            sharedInstance.inTDS           = [dict objectForKey:@"inTDS"];
            sharedInstance.inTotalHardness = [dict objectForKey:@"inTotalHardness"];
            sharedInstance.inMAlk          = [dict objectForKey:@"inMAlk"];
            sharedInstance.inPH            = [dict objectForKey:@"inPH"];
            sharedInstance.inChlorides     = [dict objectForKey:@"inChlorides"];
            sharedInstance.inHours         = [dict objectForKey:@"inHours"];
            sharedInstance.inDays          = [dict objectForKey:@"inDays"];
            sharedInstance.inWeeks         = [dict objectForKey:@"inWeeks"];
            
            // Log the retrieved values
            NSLog(@"BoilerWaterModel: retrieved values from file:");
            for (id key in dict) {
                NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
            }
        }
        
    }
    @catch (NSException *e) {
        NSLog(@"CoolingWaterModel.restore - exception: %@", e.reason);
    }
    
    
}


// save current data for next activation
- (void) save {
    @try {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]  init];
        
        [dict setObject:sharedInstance.site            forKey:@"inSite"];
        [dict setObject:sharedInstance.inCirculation   forKey:@"inCirculation"];
        [dict setObject:sharedInstance.inDeltaT        forKey:@"inDeltaT"];
        [dict setObject:sharedInstance.inSumpVolume    forKey:@"inSumpVolume"];
        [dict setObject:sharedInstance.inSysVolume     forKey:@"inSysVolume"];
        [dict setObject:sharedInstance.inConcFactor    forKey:@"inConcFactor"];
        [dict setObject:sharedInstance.inTDS           forKey:@"inTDS"];
        [dict setObject:sharedInstance.inTotalHardness forKey:@"inTotalHardness"];
        [dict setObject:sharedInstance.inMAlk          forKey:@"inMAlk"];
        [dict setObject:sharedInstance.inPH            forKey:@"inPH"];
        [dict setObject:sharedInstance.inChlorides     forKey:@"inChlorides"];
        [dict setObject:sharedInstance.inHours         forKey:@"inHours"];
        [dict setObject:sharedInstance.inDays          forKey:@"inDays"];
        [dict setObject:sharedInstance.inWeeks         forKey:@"inWeeks"];
        
        [dict writeToFile:[self dataFilePath] atomically: YES];
        
        // Log the retrieved values
        NSLog(@"CoolingWaterModel: Saving values...");
        for (id key in dict) {
            NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
        }
    }
    @catch (NSException *e) {
        NSLog(@"CoolingWaterModel.save - exception: %@", e.reason);
    }
    
}



////////////////////////////////////////////////
// Functional logic
////////////////////////////////////////////////


// checks that inputs have been defined and are valid
- (BOOL) inputsValid{
    BOOL result = YES;
    
    // check that values are not still the initial values
    if (self.circulation < 0){
        return NO;
    }
    if (self.deltaT < 0){
        return NO;
    }
    if (self.sumpVolume < 0){
        return NO;
    }
    if (self.sysVolume < 0){
        return NO;
    }
    if (self.concFactor < 0){
        return NO;
    }
    if (self.TDS < 0){
        return NO;
    }
    if (self.totalHardness < 0){
        return NO;
    }
    if (self.MAlk < 0){
        return NO;
    }
    if (self.pH < 0){
        return NO;
    }
    if (self.chlorides < 0){
        return NO;
    }
    if (self.hours < 0){
        return NO;
    }
    if (self.days < 0){
        return NO;
    }
    if (self.weeks < 0){
        return NO;
    }
    
    return result;
}


// function to calculate product amounts based on input data
// Note, assumes that all data is correctly entered (i.e. checked elsewhere before calling)

- (void)calculateAmounts {
    NSLog(@"CoolingWaterModel: calculateAmounts()");
    
    float tmp; // temp variable for holding double values
    
    @try {
        
        if (self.inputsValid){
            
            // SOLIDS
            
            // Evaporation
            tmp = self.circulation.doubleValue * self.deltaT.doubleValue * 1.8 * 0.001;// 1.8 = conversion to Farenheit
            self.evaporation = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: evaporation=%.08f", self.evaporation.doubleValue);
            
            // Bleed
            tmp = self.evaporation.doubleValue / (self.concFactor.doubleValue - 1.0);
            self.bleed = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: bleed=%.08f", self.bleed.doubleValue);
            
            // Makeup
            tmp = self.evaporation.doubleValue + self.bleed.doubleValue;
            self.makeup = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: makeup=%.08f", self.makeup.doubleValue);
            
            // Makeup/Annum
            tmp = (self.makeup.doubleValue * (self.hours.doubleValue * self.days.doubleValue * self.weeks.doubleValue));
            
            self.makeupAnnum = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: hrs:%.02f days:%.02f weeks:%.02f", self.hours.doubleValue, self.days.doubleValue, self.weeks.doubleValue);
            //NSLog(@"CoolingWaterModel: makeupAnnum=%.02f", self.makeupAnnum.doubleValue);
            
            // Theoretical Quality values
            tmp = self.TDS.doubleValue * self.concFactor.doubleValue;
            self.theoryQ1 = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: theoryQ1=%.02f", self.theoryQ1.doubleValue);
            
            tmp = self.totalHardness.doubleValue * self.concFactor.doubleValue;
            self.theoryQ2 = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: theoryQ2=%.02f", self.theoryQ2.doubleValue);
            
            tmp = self.MAlk.doubleValue * self.concFactor.doubleValue;
            self.theoryQ3 = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: theoryQ3=%.02f", self.theoryQ3.doubleValue);
            
            tmp = self.pH.doubleValue + 0.7;
            self.theoryQ4 = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: theoryQ4=%.02f", self.theoryQ4.doubleValue);
            
            tmp = self.chlorides.doubleValue * self.concFactor.doubleValue;
            self.theoryQ5 = [NSNumber numberWithDouble:(tmp)];
            //NSLog(@"CoolingWaterModel: theoryQ5=%.02f", self.theoryQ5.doubleValue);
            
            // Products parameters
            self.hs2097Dosage = [NSNumber numberWithDouble:(20)];
            tmp = ((self.hs2097Dosage.doubleValue / 1000.0) / self.concFactor.doubleValue) * self.makeupAnnum.doubleValue;
            self.hs2097Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.hs2097CostKg = [NSNumber numberWithDouble:(7.44)];
            tmp = self.hs2097Usage.doubleValue * self.hs2097CostKg.doubleValue;
            self.hs2097CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.hs4390Dosage = [NSNumber numberWithDouble:(20)];
            tmp = ((self.hs4390Dosage.doubleValue / 1000.0) / self.concFactor.doubleValue) * self.makeupAnnum.doubleValue;
            self.hs4390Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.hs4390CostKg = [NSNumber numberWithDouble:(15.84)];
            tmp = self.hs4390Usage.doubleValue * self.hs4390CostKg.doubleValue;
            self.hs4390CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.hs3990Dosage = [NSNumber numberWithDouble:(20)];
            tmp = ((self.hs3990Dosage.doubleValue / 1000.0) / self.concFactor.doubleValue) * self.makeupAnnum.doubleValue;
            self.hs3990Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.hs3990CostKg = [NSNumber numberWithDouble:(8.4)];
            tmp = self.hs3990Usage.doubleValue * self.hs3990CostKg.doubleValue;
            self.hs3990CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            // Biocides
            self.cs4400Dosage = [NSNumber numberWithDouble:(15)];
            tmp = self.sysVolume.doubleValue * 52.0 * (self.cs4400Dosage.doubleValue / 1000.0);
            self.cs4400Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.cs4400CostKg = [NSNumber numberWithDouble:(16.55)];
            tmp = self.cs4400Usage.doubleValue * self.cs4400CostKg.doubleValue;
            self.cs4400CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.cs4802Dosage = [NSNumber numberWithDouble:(20)];
            tmp = self.sumpVolume.doubleValue * 52.0 * (self.cs4802Dosage.doubleValue / 1000.0);
            self.cs4802Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.cs4802CostKg = [NSNumber numberWithDouble:(12.8)];
            tmp = self.cs4802Usage.doubleValue * self.cs4802CostKg.doubleValue;
            self.cs4802CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.cs4490Dosage = [NSNumber numberWithDouble:(20)];
            tmp = self.sysVolume.doubleValue * 52.0 * (self.cs4490Dosage.doubleValue / 1000.0);
            self.cs4490Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.cs4490CostKg = [NSNumber numberWithDouble:(22.25)];
            tmp = self.cs4490Usage.doubleValue * self.cs4490CostKg.doubleValue;
            self.cs4490CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.scg1Dosage = [NSNumber numberWithDouble:(5)];
            tmp = self.sysVolume.doubleValue * 52.0 * (self.scg1Dosage.doubleValue / 1000.0);
            self.scg1Usage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.scg1CostKg = [NSNumber numberWithDouble:(7.3)];
            tmp = self.scg1Usage.doubleValue * self.scg1CostKg.doubleValue;
            self.scg1CostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.cschlorDosage = [NSNumber numberWithDouble:(5)];
            tmp = self.sysVolume.doubleValue * 52.0 * (self.cschlorDosage.doubleValue / 1000.0);
            self.cschlorUsage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.cschlorCostKg = [NSNumber numberWithDouble:(9.69)];
            tmp = self.cschlorUsage.doubleValue * self.cschlorCostKg.doubleValue;
            self.cschlorCostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            self.c42tDosage = [NSNumber numberWithDouble:(5)];
            tmp = self.sysVolume.doubleValue * 52.0 * (self.c42tDosage.doubleValue / 1000.0);
            self.c42tUsage  = [NSNumber numberWithDouble:(tmp)];
            /*
            self.c42tCostKg = [NSNumber numberWithDouble:(6.9)];
            tmp = self.c42tUsage.doubleValue * self.c42tCostKg.doubleValue;
            self.c42tCostAnnum = [NSNumber numberWithDouble:(tmp)];
             */
            
            
            // LIQUIDS
            
            // Inhibitors
            tmp = self.makeupAnnum.doubleValue / (1000.0 * self.concFactor.doubleValue); // common factor
            
            self.h207Dosage = [NSNumber numberWithDouble:(100.0)];
            self.h207Usage = [NSNumber numberWithDouble:(self.h207Dosage.doubleValue * tmp)];
            
            self.h2073Dosage = [NSNumber numberWithDouble:(300.0)];
            self.h2073Usage = [NSNumber numberWithDouble:(self.h2073Dosage.doubleValue * tmp)];
            
            self.h280Dosage = [NSNumber numberWithDouble:(80.0)];
            self.h280Usage = [NSNumber numberWithDouble:(self.h280Dosage.doubleValue * tmp)];
            
            self.h2805Dosage = [NSNumber numberWithDouble:(160.0)];
            self.h2805Usage = [NSNumber numberWithDouble:(self.h2805Dosage.doubleValue * tmp)];
            
            self.h390Dosage = [NSNumber numberWithDouble:(50.0)];
            self.h390Usage = [NSNumber numberWithDouble:(self.h390Dosage.doubleValue * tmp)];
            
            self.h3905Dosage = [NSNumber numberWithDouble:(100.0)];
            self.h3905Usage = [NSNumber numberWithDouble:(self.h3905Dosage.doubleValue * tmp)];
            
            self.h391Dosage = [NSNumber numberWithDouble:(150.0)];
            self.h391Usage = [NSNumber numberWithDouble:(self.h391Dosage.doubleValue * tmp)];
            
            self.h423Dosage = [NSNumber numberWithDouble:(100.0)];
            self.h423Usage = [NSNumber numberWithDouble:(self.h423Dosage.doubleValue * tmp)];
            
            self.h425Dosage = [NSNumber numberWithDouble:(100.0)];
            self.h425Usage = [NSNumber numberWithDouble:(self.h425Dosage.doubleValue * tmp)];
            
            self.h4255Dosage = [NSNumber numberWithDouble:(200.0)];
            self.h4255Usage = [NSNumber numberWithDouble:(self.h4255Dosage.doubleValue * tmp)];
            
            self.h535Dosage = [NSNumber numberWithDouble:(100.0)];
            self.h535Usage = [NSNumber numberWithDouble:(self.h535Dosage.doubleValue * tmp)];
            
            self.h874Dosage = [NSNumber numberWithDouble:(120.0)];
            self.h874Usage = [NSNumber numberWithDouble:(self.h874Dosage.doubleValue * tmp)];
            
            // Biocides - non-oxidisers
            tmp = self.sysVolume.doubleValue * 52.0 / 1000.0 ; // common factor
            
            self.c31Dosage = [NSNumber numberWithDouble:(200.0)];
            self.c31Usage = [NSNumber numberWithDouble:(self.c31Dosage.doubleValue * tmp)];
            
            self.c32Dosage = [NSNumber numberWithDouble:(100.0)];
            self.c32Usage = [NSNumber numberWithDouble:(self.c32Dosage.doubleValue * tmp)];
            
            self.c44Dosage = [NSNumber numberWithDouble:(80.0)];
            self.c44Usage = [NSNumber numberWithDouble:(self.c44Dosage.doubleValue * tmp)];
            
            self.c45Dosage = [NSNumber numberWithDouble:(125.0)];
            self.c45Usage = [NSNumber numberWithDouble:(self.c45Dosage.doubleValue * tmp)];
            
            self.c48Dosage = [NSNumber numberWithDouble:(250.0)];
            self.c48Usage = [NSNumber numberWithDouble:(self.c48Dosage.doubleValue * tmp)];
            
            self.c51Dosage = [NSNumber numberWithDouble:(125.0)];
            self.c51Usage = [NSNumber numberWithDouble:(self.c51Dosage.doubleValue * tmp)];
            
            self.c52Dosage = [NSNumber numberWithDouble:(100.0)];
            self.c52Usage = [NSNumber numberWithDouble:(self.c52Dosage.doubleValue * tmp)];
            
            self.c54Dosage = [NSNumber numberWithDouble:(100.0)];
            self.c54Usage = [NSNumber numberWithDouble:(self.c54Dosage.doubleValue * tmp)];
            
            self.c58Dosage = [NSNumber numberWithDouble:(100.0)];
            self.c58Usage = [NSNumber numberWithDouble:(self.c58Dosage.doubleValue * tmp)];

            
        } else {
            NSLog(@"CoolingWaterModel: inputs not fully defined");
        }
    }
    @catch (NSException *e) {
        NSLog(@"CoolingWaterModel.calculateAmounts - exception: %@", e.reason);
    }
    
}

@end
