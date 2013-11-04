//
//  WTP_Tests.m
//  WTP Tests
//
//  Created by Phil Price on 10/1/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BoilerWaterModel.h"
#import "CoolingWaterModel.h"

@interface WTP_Tests : XCTestCase

@end

@implementation WTP_Tests

BoilerWaterModel  *mBoilerModel;
CoolingWaterModel *mCoolingModel;

- (void)setUp
{
    [super setUp];
    // This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// compares 2 numbers for rough equality
// Data is rounded to 2 decimal places, so differences of up to 0.05 are OK
- (BOOL) fieldsMatch:(NSNumber *)actValue expected:(NSNumber *)expValue name:(NSString *)fieldName {
    BOOL result = NO;
    @try{
        float exp = expValue.floatValue;
        if (exp < 0.0) exp = 0.0; // reset -ve numbers to 0
        
        float diff = exp - actValue.floatValue;
        float pdiff =0;
        
        if (exp > 0.0) {
            pdiff = (diff / exp ) * 100.0 ; // difference relative to expected result
        }
        //if (fabsf(diff) > 0.051){
        if (fabsf(pdiff) > 0.1){ // >0.1% difference
            //if (fabsf(pdiff) > 1.0){ // >1% difference
            result = NO;
            NSLog(@"!!! Field %@ does not match. Actual:%.03f Expected:%.03f Diff:%.08f", fieldName, actValue.floatValue, expValue.floatValue, diff);
        } else {
            NSLog(@"\"%@\"  Actual:%.03f Expected:%.03f", fieldName, actValue.floatValue, expValue.floatValue);
           result = YES;
        }
    }
    @catch (NSException *e){
        result = NO;
        NSLog (@"fieldsMatch() Exception: %@", e.reason);
    }
    return result;
}

// scan a float and return as NSNumber
- (NSNumber *) scanFloat:(NSScanner *)scanner {
    float ftmp;
    [scanner scanFloat:&ftmp];
    //NSLog(@"Scanned float:%.02f", ftmp);
    return[NSNumber numberWithFloat:(ftmp)];
    
}


// Boiler Model test
// Reads data from CSV file and comapres expected values against those calculated by the model
- (void)testBoilerModel
{
    
    // parameters to hold input values
    NSNumber *inSumSteam;
    NSNumber *inSumHours;
    NSNumber *inSumDays;
    NSNumber *inSumWeeks;
    NSNumber *inWinSteam;
    NSNumber *inWinHours;
    NSNumber *inWinDays;
    NSNumber *inWinWeeks;
    NSNumber *inTDS;
    NSNumber *inMAlk;
    NSNumber *inPH;
    NSNumber *inCaHardness;
    NSNumber *inTemp;
    NSNumber *inMaxTDS;
    NSNumber *inMinSulphite;
    NSNumber *inMinCausticAlk;
    
    // parameters to hold expected results
    NSNumber *totalAnnual;
    NSNumber *dissolvedO2;
    NSNumber *expSS1295Dosage;
    NSNumber *expSS1295Usage;
    
    NSNumber *expSS1350Dosage;
    NSNumber *expSS1350Usage;
    
    NSNumber *expSS1095Dosage;
    NSNumber *expSS1095Usage;
    
    NSNumber *expSS1995Dosage;
    NSNumber *expSS1995Usage;
    
    NSNumber *expSS2295Dosage;
    NSNumber *expSS2295Usage;
    
    NSNumber *expSS8985Dosage;
    NSNumber *expSS8985Usage;
    
    
    @try{
        NSLog(@"========================================================================================");
        NSLog(@"*************************");
        NSLog(@"*** testBoilerModel() ***");
        NSLog(@"*************************");
        
        // open the test file
        NSString *rootDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"testdata"];
        NSString *testFilePath = [rootDirectory stringByAppendingString:@"/testboilerdata.csv"];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:testFilePath];
        
        XCTAssertTrue(fileExists, @"Checking existence of test data file");
        
        if (fileExists){
            
            NSLog(@"Processing file %@", testFilePath);
            
            // get instance of the boiler model
            mBoilerModel = [BoilerWaterModel sharedInstance];
            
            // A bit of a hack: read the whole file and split into lines
            
            NSString *contents = [NSString stringWithContentsOfFile:testFilePath encoding:NSUTF8StringEncoding error:nil];
            
            NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
            
            int count = 0;
            for (NSString* line in lines) {
                if (line.length) {
                    if (isdigit([line characterAtIndex:0])) { // check for numeric data
                        count++;
                        NSLog(@"****** TEST %i ******", count);
                        NSLog(@"line: %@", line);
                        
                        NSScanner *scanner = [NSScanner scannerWithString:line];
                        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
                        
                        // scan the input parameters
                        inSumSteam = [self scanFloat:scanner];
                        inSumHours = [self scanFloat:scanner];
                        inSumDays = [self scanFloat:scanner];
                        inSumWeeks = [self scanFloat:scanner];
                        inWinSteam = [self scanFloat:scanner];
                        inWinHours = [self scanFloat:scanner];
                        inWinDays = [self scanFloat:scanner];
                        inWinWeeks = [self scanFloat:scanner];
                        inTDS = [self scanFloat:scanner];
                        inMAlk = [self scanFloat:scanner];
                        inPH = [self scanFloat:scanner];
                        inCaHardness = [self scanFloat:scanner];
                        inTemp = [self scanFloat:scanner];
                        inMaxTDS = [self scanFloat:scanner];
                        inMinSulphite = [self scanFloat:scanner];
                        inMinCausticAlk = [self scanFloat:scanner];
                        
                        // scan the expected output values
                        totalAnnual = [self scanFloat:scanner];
                        dissolvedO2 = [self scanFloat:scanner];
                        expSS1295Dosage = [self scanFloat:scanner];
                        expSS1295Usage  = [self scanFloat:scanner];
                        expSS1350Dosage = [self scanFloat:scanner];
                        expSS1350Usage  = [self scanFloat:scanner];
                        expSS1095Dosage = [self scanFloat:scanner];
                        expSS1095Usage  = [self scanFloat:scanner];
                        expSS1995Dosage = [self scanFloat:scanner];
                        expSS1995Usage  = [self scanFloat:scanner];
                        expSS2295Dosage = [self scanFloat:scanner];
                        expSS2295Usage  = [self scanFloat:scanner];
                        expSS8985Dosage = [self scanFloat:scanner];
                        expSS8985Usage  = [self scanFloat:scanner];
                        
                        // set Boiler Duty parameters
                        mBoilerModel.sumSteam      = inSumSteam;
                        mBoilerModel.sumHours      = inSumHours;
                        mBoilerModel.sumDays       = inSumDays;
                        mBoilerModel.sumWeeks      = inSumWeeks;
                        mBoilerModel.winSteam      = inWinSteam;
                        mBoilerModel.winHours      = inWinHours;
                        mBoilerModel.winDays       = inWinDays;
                        mBoilerModel.winWeeks      = inWinWeeks;
                        mBoilerModel.TDS           = inTDS;
                        mBoilerModel.MAlk          = inMAlk;
                        mBoilerModel.pH            = inPH;
                        mBoilerModel.CaHardness    = inCaHardness;
                        mBoilerModel.temp          = inTemp;
                        mBoilerModel.maxTDS        = inMaxTDS;
                        mBoilerModel.minSulphite   = inMinSulphite;
                        mBoilerModel.minCausticAlk = inMinCausticAlk;
                        
                        // calculate values
                        [mBoilerModel calculateAmounts];
                        
                        // compare results
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.annualFeed expected:totalAnnual name:@"Annual Feed"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.dissolvedO2 expected:dissolvedO2 name:@"Dissolved O2"]);
                        
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1295Dosage expected:expSS1295Dosage name:@"SS1295 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1295Usage  expected:expSS1295Usage  name:@"SS1295 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1350Dosage expected:expSS1350Dosage name:@"SS1350 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1350Usage  expected:expSS1350Usage  name:@"SS1350 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1095Dosage expected:expSS1095Dosage name:@"SS1095 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1095Usage  expected:expSS1095Usage  name:@"SS1095 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1995Dosage expected:expSS1995Dosage name:@"SS1995 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1995Usage  expected:expSS1995Usage  name:@"SS1995 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss2295Dosage expected:expSS2295Dosage name:@"SS2295 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss2295Usage  expected:expSS2295Usage  name:@"SS2295 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss8985Dosage expected:expSS8985Dosage name:@"SS8985 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss8985Usage  expected:expSS8985Usage  name:@"SS8985 Usage"]);
                    } else {
                        //NSLog(@"Ignoring line: %@", line);
                    }
                    
                } else {
                    //NSLog(@"Null line ignored");
                }
            } // end loop
            
            NSLog(@"Processed %d tests", count);;
            NSLog(@"========================================================================================");
            
            // close the file
            
        } else {
            NSLog(@"File does not exist: %@", testFilePath);
        }
    }
    @catch (NSException *e){
        NSLog(@"Exception: %@", e.reason);
        XCTAssertTrue(NO, @"Exception during test");
    }
} // testBoilerModel



// Cooling Model test
// Reads data from CSV file and comapres expected values against those calculated by the model

- (void)testCoolingModel
{
    
    // parameters to hold input values
    
    // Criteria parameters
    NSNumber *inCirculation;
    NSNumber *inDeltaTF;
    NSNumber *inDeltaTC;
    NSNumber *inSumpVolume;
    NSNumber *inSysVolume;
    NSNumber *inConcFactor;
    
    
    // Makeup Water Quality params
    NSNumber *inTDS;
    NSNumber *inTotalHardness;
    NSNumber *inMAlk;
    NSNumber *inPH;
    NSNumber *inChlorides;
    
    
    // Duty/Operation params
    
    NSNumber *inHours;
    NSNumber *inDays;
    NSNumber *inWeeks;
    
    
    // Calculated values
    
    // Criteria-based intermediate values
    NSNumber *expEvaporation;
    NSNumber *expBleed;
    NSNumber *expMakeup;
    NSNumber *expMakeupAnnum;
    
    // I don't know what these are, just intermediate values
    NSNumber *expTheoryQ1;
    NSNumber *expTheoryQ2;
    NSNumber *expTheoryQ3;
    NSNumber *expTheoryQ4;
    NSNumber *expTheoryQ5;
    
    // Product-based values
    NSNumber *expHs2097Dosage;
    NSNumber *expHs2097Usage;
    NSNumber *expHs2097CostKg;
    NSNumber *expHs2097CostAnnum;
    
    NSNumber *expHs4390Dosage;
    NSNumber *expHs4390Usage;
    NSNumber *expHs4390CostKg;
    NSNumber *expHs4390CostAnnum;
    
    NSNumber *expHs3990Dosage;
    NSNumber *expHs3990Usage;
    NSNumber *expHs3990CostKg;
    NSNumber *expHs3990CostAnnum;
    
    // Biocide values
    
    NSNumber *expCs4400Dosage;
    NSNumber *expCs4400Usage;
    NSNumber *expCs4400CostKg;
    NSNumber *expCs4400CostAnnum;
    
    NSNumber *expCs4802Dosage;
    NSNumber *expCs4802Usage;
    NSNumber *expCs4802CostKg;
    NSNumber *expCs4802CostAnnum;
    
    NSNumber *expCs4490Dosage;
    NSNumber *expCs4490Usage;
    NSNumber *expCs4490CostKg;
    NSNumber *expCs4490CostAnnum;
    
    NSNumber *expScg1Dosage;
    NSNumber *expScg1Usage;
    NSNumber *expScg1CostKg;
    NSNumber *expScg1CostAnnum;
    
    NSNumber *expCschlorDosage;
    NSNumber *expCschlorUsage;
    NSNumber *expCschlorCostKg;
    NSNumber *expCschlorCostAnnum;
    
    NSNumber *expC42tDosage;
    NSNumber *expC42tUsage;
    NSNumber *expC42tCostKg;
    NSNumber *expC42tCostAnnum;
    
    NSError *error = nil;
    
    @try{
        NSLog(@"========================================================================================");
        NSLog(@"**************************");
        NSLog(@"*** testCoolingModel() ***");
        NSLog(@"**************************");
        
        // open the test file
        NSString *rootDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"testdata"];
        NSString *testFilePath = [rootDirectory stringByAppendingString:@"/testcoolingdata.csv"];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:testFilePath];
        
        XCTAssertTrue(fileExists, @"Checking existence of test data file");
        
        if (fileExists){
            
            NSLog(@"Processing file %@", testFilePath);
            
            // get instance of the boiler model
            mCoolingModel = [CoolingWaterModel sharedInstance];
            
            // A bit of a hack: read the whole file and split into lines
            
            //NSString *contents = [NSString stringWithContentsOfFile:testFilePath encoding:NSUTF8StringEncoding error:&error];
            NSString *contents = [NSString stringWithContentsOfFile:testFilePath encoding:NSASCIIStringEncoding error:&error];
            
            if (error != nil){
                NSLog(@"error returned: %@", error.description);
            }
            XCTAssertTrue(([contents length] > 0), @"Data in file");
            
            NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
            
            XCTAssertTrue(([lines count] > 0), @"Lines in file");
            
            int count = 0;
            for (NSString* line in lines) {
                if (line.length) {
                    if (isdigit([line characterAtIndex:0])) { // check for numeric data
                        count++;
                        NSLog(@"+===================+");
                        NSLog(@"|      TEST %i      |", count);
                        NSLog(@"+===================+");
                        NSLog(@"line: %@", line);
                       
                        NSScanner *scanner = [NSScanner scannerWithString:line];
                        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
                        
                        inCirculation = [self scanFloat:scanner];
                        inDeltaTF = [self scanFloat:scanner];
                        //inDeltaTC = [self scanFloat:scanner];
                        inDeltaTC = [NSNumber numberWithFloat:(inDeltaTF.floatValue / 1.8)]; // problem with rounding of numbers by Excel
                        inSumpVolume = [self scanFloat:scanner];
                        inSysVolume = [self scanFloat:scanner];
                        inConcFactor = [self scanFloat:scanner];
                        inTDS = [self scanFloat:scanner];
                        inTotalHardness = [self scanFloat:scanner];
                        inMAlk = [self scanFloat:scanner];
                        inPH = [self scanFloat:scanner];
                        inChlorides = [self scanFloat:scanner];
                        inHours = [self scanFloat:scanner];
                        inDays = [self scanFloat:scanner];
                        inWeeks = [self scanFloat:scanner];
                        
                        // Calculated values
                        expEvaporation = [self scanFloat:scanner];
                        expBleed = [self scanFloat:scanner];
                        expMakeup = [self scanFloat:scanner];
                        expMakeupAnnum = [self scanFloat:scanner];
                        expTheoryQ1 = [self scanFloat:scanner];
                        expTheoryQ2 = [self scanFloat:scanner];
                        expTheoryQ3 = [self scanFloat:scanner];
                        expTheoryQ4 = [self scanFloat:scanner];
                        expTheoryQ5 = [self scanFloat:scanner];
                        expHs2097Dosage = [self scanFloat:scanner];
                        expHs2097Usage = [self scanFloat:scanner];
                        expHs2097CostKg = [self scanFloat:scanner];
                        expHs2097CostAnnum = [self scanFloat:scanner];
                        expHs4390Dosage = [self scanFloat:scanner];
                        expHs4390Usage = [self scanFloat:scanner];
                        expHs4390CostKg = [self scanFloat:scanner];
                        expHs4390CostAnnum = [self scanFloat:scanner];
                        expHs3990Dosage = [self scanFloat:scanner];
                        expHs3990Usage = [self scanFloat:scanner];
                        expHs3990CostKg = [self scanFloat:scanner];
                        expHs3990CostAnnum = [self scanFloat:scanner];
                        expCs4400Dosage = [self scanFloat:scanner];
                        expCs4400Usage = [self scanFloat:scanner];
                        expCs4400CostKg = [self scanFloat:scanner];
                        expCs4400CostAnnum = [self scanFloat:scanner];
                        expCs4802Dosage = [self scanFloat:scanner];
                        expCs4802Usage = [self scanFloat:scanner];
                        expCs4802CostKg = [self scanFloat:scanner];
                        expCs4802CostAnnum = [self scanFloat:scanner];
                        expCs4490Dosage = [self scanFloat:scanner];
                        expCs4490Usage = [self scanFloat:scanner];
                        expCs4490CostKg = [self scanFloat:scanner];
                        expCs4490CostAnnum = [self scanFloat:scanner];
                        expScg1Dosage = [self scanFloat:scanner];
                        expScg1Usage = [self scanFloat:scanner];
                        expScg1CostKg = [self scanFloat:scanner];
                        expScg1CostAnnum = [self scanFloat:scanner];
                        expCschlorDosage = [self scanFloat:scanner];
                        expCschlorUsage = [self scanFloat:scanner];
                        expCschlorCostKg = [self scanFloat:scanner];
                        expCschlorCostAnnum = [self scanFloat:scanner];
                        expC42tDosage = [self scanFloat:scanner];
                        expC42tUsage = [self scanFloat:scanner];
                        expC42tCostKg = [self scanFloat:scanner];
                        expC42tCostAnnum = [self scanFloat:scanner];
                        
                        // set cooling model inputs
                        mCoolingModel.circulation = inCirculation  ;
                        mCoolingModel.deltaT =    inDeltaTC  ;
                        mCoolingModel.sumpVolume = inSumpVolume  ;
                        mCoolingModel.sysVolume = inSysVolume  ;
                        mCoolingModel.concFactor = inConcFactor  ;
                        mCoolingModel.TDS           = inTDS  ;
                        mCoolingModel.totalHardness = inTotalHardness  ;
                        mCoolingModel.MAlk = inMAlk  ;
                        mCoolingModel.pH = inPH  ;
                        mCoolingModel.chlorides = inChlorides  ;
                        mCoolingModel.hours = inHours  ;
                        mCoolingModel.days = inDays  ;
                        mCoolingModel.weeks = inWeeks  ;
                        
                        
                        // calculate values
                        [mCoolingModel calculateAmounts];
                        
                        // compare results
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.evaporation expected:expEvaporation  name:@"Evaporation"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.bleed expected:expBleed  name:@"Bleed"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.makeup expected:expMakeup  name:@"Makeup"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.makeupAnnum expected:expMakeupAnnum  name:@"Makeup per Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.theoryQ1 expected:expTheoryQ1  name:@"Theoretcial Quantity #1"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.theoryQ2 expected:expTheoryQ2  name:@"Theoretcial Quantity #2"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.theoryQ3 expected:expTheoryQ3  name:@"Theoretcial Quantity #3"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.theoryQ4 expected:expTheoryQ4  name:@"Theoretcial Quantity #4"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.theoryQ5 expected:expTheoryQ5  name:@"Theoretcial Quantity #5"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097Dosage expected:expHs2097Dosage  name:@"HS2097 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097Usage expected:expHs2097Usage  name:@"HS2097 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097CostKg expected:expHs2097CostKg  name:@"HS2097 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097CostAnnum expected:expHs2097CostAnnum  name:@"HS2097 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390Dosage expected:expHs4390Dosage  name:@"HS4390 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390Usage expected:expHs4390Usage  name:@"HS4390 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390CostKg expected:expHs4390CostKg  name:@"HS4390 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390CostAnnum expected:expHs4390CostAnnum  name:@"HS4390 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990Dosage expected:expHs3990Dosage  name:@"HS3390 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990Usage expected:expHs3990Usage  name:@"HS3390 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990CostKg expected:expHs3990CostKg  name:@"HS3390 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990CostAnnum expected:expHs3990CostAnnum  name:@"HS3390 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400Dosage expected:expCs4400Dosage  name:@"CS4400 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400Usage expected:expCs4400Usage  name:@"CS4400 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400CostKg expected:expCs4400CostKg  name:@"CS4400 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400CostAnnum expected:expCs4400CostAnnum  name:@"CS4400 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802Dosage expected:expCs4802Dosage  name:@"CS4802 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802Usage expected:expCs4802Usage  name:@"CS4802 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802CostKg expected:expCs4802CostKg  name:@"CS4802 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802CostAnnum expected: expCs4802CostAnnum  name:@"CS4802 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490Dosage expected:expCs4490Dosage  name:@"CS4490 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490Usage expected:expCs4490Usage  name:@"CS4490 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490CostKg expected:expCs4490CostKg  name:@"CS4490 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490CostAnnum expected:expCs4490CostAnnum  name:@"CS4490 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1Dosage expected:expScg1Dosage  name:@"SCG1 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1Usage expected:expScg1Usage  name:@"SCG1 Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1CostKg expected:expScg1CostKg  name:@"SCG1 Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1CostAnnum expected:expScg1CostAnnum  name:@"SCG1 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorDosage expected:expCschlorDosage  name:@"CSChlor Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorUsage expected:expCschlorUsage  name:@"CSChlor Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorCostKg expected:expCschlorCostKg  name:@"CSChlor Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorCostAnnum expected:expCschlorCostAnnum  name:@"CSChlor Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tDosage expected:expC42tDosage  name:@"C42T Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tUsage expected:expC42tUsage  name:@"C42T Usage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tCostKg expected:expC42tCostKg  name:@"C42T Cost/kg"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tCostAnnum expected:expC42tCostAnnum  name:@"C42T Cost/Annum"]);
                        
                    } else {
                        //NSLog(@"Ignoring line: %@", line);
                    }
                    
                } else {
                    //NSLog(@"Null line ignored");
                }
            } // end loop
            
            NSLog(@"Processed %d tests", count);;
            NSLog(@"========================================================================================");
            
            // close the file
            
        } else {
            NSLog(@"File does not exist: %@", testFilePath);
        }
    }
    @catch (NSException *e){
        NSLog(@"Exception: %@", e.reason);
        XCTAssertTrue(NO, @"Exception during test");
    }} //testCoolingModel

@end
