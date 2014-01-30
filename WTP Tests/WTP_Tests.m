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
            //NSLog(@"\"%@\"  Actual:%.03f Expected:%.03f", fieldName, actValue.floatValue, expValue.floatValue);
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

//////////////////////
// BOILER MODEL TESTS
//////////////////////

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
    // SOLIDS
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
    
    // LIQUIDS
    
    NSNumber *expMinAlkalinity;
    
    NSNumber *expS5Dosage;
    NSNumber *expS5Usage;
    
    NSNumber *expS10Dosage;
    NSNumber *expS10Usage;
    
    NSNumber *expS123Dosage;
    NSNumber *expS123Usage;
    
    NSNumber *expS125Dosage;
    NSNumber *expS125Usage;
    
    NSNumber *expS26Dosage;
    NSNumber *expS26Usage;
    
    NSNumber *expS28Dosage;
    NSNumber *expS28Usage;
    
    NSNumber *expS19Dosage;
    NSNumber *expS19Usage;
    
    NSNumber *expS456Dosage;
    NSNumber *expS456Usage;
    
    NSNumber *expS124Dosage;
    NSNumber *expS124Usage;
    
    NSNumber *expS22Dosage;
    NSNumber *expS22Usage;
    
    NSNumber *expS23Dosage;
    NSNumber *expS23Usage;
    
    NSNumber *expS88Dosage;
    NSNumber *expS88Usage;
    
    NSNumber *expS95Dosage;
    NSNumber *expS95Usage;

    
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
                        // SOLIDS
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
                        
                        // LIQUIDS
                        expMinAlkalinity = [self scanFloat:scanner];
                        
                        expS5Dosage = [self scanFloat:scanner];
                        expS5Usage  = [self scanFloat:scanner];
                        
                        expS10Dosage = [self scanFloat:scanner];
                        expS10Usage  = [self scanFloat:scanner];
                        
                        expS123Dosage = [self scanFloat:scanner];
                        expS123Usage  = [self scanFloat:scanner];
                        
                        expS125Dosage = [self scanFloat:scanner];
                        expS125Usage  = [self scanFloat:scanner];
                        
                        expS26Dosage = [self scanFloat:scanner];
                        expS26Usage  = [self scanFloat:scanner];
                        
                        expS28Dosage = [self scanFloat:scanner];
                        expS28Usage  = [self scanFloat:scanner];
                        
                        expS19Dosage = [self scanFloat:scanner];
                        expS19Usage  = [self scanFloat:scanner];
                        
                        expS456Dosage = [self scanFloat:scanner];
                        expS456Usage  = [self scanFloat:scanner];
                        
                        expS124Dosage = [self scanFloat:scanner];
                        expS124Usage  = [self scanFloat:scanner];
                        
                        expS22Dosage = [self scanFloat:scanner];
                        expS22Usage  = [self scanFloat:scanner];
                        
                        expS23Dosage = [self scanFloat:scanner];
                        expS23Usage  = [self scanFloat:scanner];
                        
                        expS88Dosage = [self scanFloat:scanner];
                        expS88Usage  = [self scanFloat:scanner];
                        
                        expS95Dosage = [self scanFloat:scanner];
                        expS95Usage  = [self scanFloat:scanner];
                       
                        
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
                        
                        // SOLIDS
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1295Dosage expected:expSS1295Dosage name:@"SS1295 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.ss1295Usage  expected:expSS1295Usage  name:@"SS1295  Usage"]);
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
                        
                        // LIQUIDS
                        
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.minAlkalinity expected:expMinAlkalinity name:@"min Alkalinity"]);
                        
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s5Dosage expected:expS5Dosage name:@"S5 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s5Usage  expected:expS5Usage name:@"S5Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s10Dosage expected:expS10Dosage name:@"S10 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s10Usage  expected:expS10Usage name:@"S10Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s123Dosage expected:expS123Dosage name:@"S123 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s123Usage  expected:expS123Usage name:@"S123Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s125Dosage expected:expS125Dosage name:@"S125 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s125Usage  expected:expS125Usage name:@"S125Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s26Dosage expected:expS26Dosage name:@"S26 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s26Usage  expected:expS26Usage name:@"S26Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s28Dosage expected:expS28Dosage name:@"S28 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s28Usage  expected:expS28Usage name:@"S28Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s19Dosage expected:expS19Dosage name:@"S19 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s19Usage  expected:expS19Usage name:@"S19Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s456Dosage expected:expS456Dosage name:@"S456 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s456Usage  expected:expS456Usage name:@"S456Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s124Dosage expected:expS124Dosage name:@"S124 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s124Usage  expected:expS124Usage name:@"S124Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s22Dosage expected:expS22Dosage name:@"S22 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s22Usage  expected:expS22Usage name:@"S22Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s23Dosage expected:expS23Dosage name:@"S23 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s23Usage  expected:expS23Usage name:@"S23Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s88Dosage expected:expS88Dosage name:@"S88 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s88Usage  expected:expS88Usage name:@"S88Usage Usage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s95Dosage expected:expS95Dosage name:@"S95 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mBoilerModel.s95Usage  expected:expS95Usage name:@"S95Usage Usage"]);
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




///////////////////////
// COOLING MODEL TESTS
///////////////////////

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
    
    
    // LIQUIDS
    
    // Inhibitors
    NSNumber *expH207Dosage;
    NSNumber *expH207Usage;
    
    NSNumber *expH2073Dosage;
    NSNumber *expH2073Usage;
    
    NSNumber *expH280Dosage;
    NSNumber *expH280Usage;
    
    NSNumber *expH2805Dosage;
    NSNumber *expH2805Usage;
    
    NSNumber *expH390Dosage;
    NSNumber *expH390Usage;
    
    NSNumber *expH3905Dosage;
    NSNumber *expH3905Usage;
    
    NSNumber *expH391Dosage;
    NSNumber *expH391Usage;
    
    NSNumber *expH423Dosage;
    NSNumber *expH423Usage;
    
    NSNumber *expH425Dosage;
    NSNumber *expH425Usage;
    
    NSNumber *expH4255Dosage;
    NSNumber *expH4255Usage;
    
    NSNumber *expH535Dosage;
    NSNumber *expH535Usage;
    
    NSNumber *expH874Dosage;
    NSNumber *expH874Usage;
    
    // Biocides - non-oxidisers
    NSNumber *expC31Dosage;
    NSNumber *expC31Usage;
    
    NSNumber *expC32Dosage;
    NSNumber *expC32Usage;
    
    NSNumber *expC44Dosage;
    NSNumber *expC44Usage;
    
    NSNumber *expC45Dosage;
    NSNumber *expC45Usage;
    
    NSNumber *expC48Dosage;
    NSNumber *expC48Usage;
    
    NSNumber *expC51Dosage;
    NSNumber *expC51Usage;
    
    NSNumber *expC52Dosage;
    NSNumber *expC52Usage;
    
    NSNumber *expC54Dosage;
    NSNumber *expC54Usage;
    
    NSNumber *expC58Dosage;
    NSNumber *expC58Usage;
    

    
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
                        
                        // Inhibitors
                        expH207Dosage = [self scanFloat:scanner];
                        expH207Usage = [self scanFloat:scanner];
                        expH2073Dosage = [self scanFloat:scanner];
                        expH2073Usage = [self scanFloat:scanner];
                        expH280Dosage = [self scanFloat:scanner];
                        expH280Usage = [self scanFloat:scanner];
                        expH2805Dosage = [self scanFloat:scanner];
                        expH2805Usage = [self scanFloat:scanner];
                        expH390Dosage = [self scanFloat:scanner];
                        expH390Usage = [self scanFloat:scanner];
                        expH3905Dosage = [self scanFloat:scanner];
                        expH3905Usage = [self scanFloat:scanner];
                        expH391Dosage = [self scanFloat:scanner];
                        expH391Usage = [self scanFloat:scanner];
                        expH423Dosage = [self scanFloat:scanner];
                        expH423Usage = [self scanFloat:scanner];
                        expH425Dosage = [self scanFloat:scanner];
                        expH425Usage = [self scanFloat:scanner];
                        expH4255Dosage = [self scanFloat:scanner];
                        expH4255Usage = [self scanFloat:scanner];
                        expH535Dosage = [self scanFloat:scanner];
                        expH535Usage = [self scanFloat:scanner];
                        expH874Dosage = [self scanFloat:scanner];
                        expH874Usage = [self scanFloat:scanner];
                        
                        // Biocides - non-oxidisers
                        expC31Dosage = [self scanFloat:scanner];
                        expC31Usage = [self scanFloat:scanner];
                        expC32Dosage = [self scanFloat:scanner];
                        expC32Usage = [self scanFloat:scanner];
                        expC44Dosage = [self scanFloat:scanner];
                        expC44Usage = [self scanFloat:scanner];
                        expC45Dosage = [self scanFloat:scanner];
                        expC45Usage = [self scanFloat:scanner];
                        expC48Dosage = [self scanFloat:scanner];
                        expC48Usage = [self scanFloat:scanner];
                        expC51Dosage = [self scanFloat:scanner];
                        expC51Usage = [self scanFloat:scanner];
                        expC52Dosage = [self scanFloat:scanner];
                        expC52Usage = [self scanFloat:scanner];
                        expC54Dosage = [self scanFloat:scanner];
                        expC54Usage = [self scanFloat:scanner];
                        expC58Dosage = [self scanFloat:scanner];
                        expC58Usage = [self scanFloat:scanner];

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
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097CostKg expected:expHs2097CostKg  name:@"HS2097 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.hs2097CostAnnum expected:expHs2097CostAnnum  name:@"HS2097 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390Dosage expected:expHs4390Dosage  name:@"HS4390 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390Usage expected:expHs4390Usage  name:@"HS4390 Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390CostKg expected:expHs4390CostKg  name:@"HS4390 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.hs4390CostAnnum expected:expHs4390CostAnnum  name:@"HS4390 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990Dosage expected:expHs3990Dosage  name:@"HS3390 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990Usage expected:expHs3990Usage  name:@"HS3390 Usage"]);
                       // XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990CostKg expected:expHs3990CostKg  name:@"HS3390 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.hs3990CostAnnum expected:expHs3990CostAnnum  name:@"HS3390 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400Dosage expected:expCs4400Dosage  name:@"CS4400 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400Usage expected:expCs4400Usage  name:@"CS4400 Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400CostKg expected:expCs4400CostKg  name:@"CS4400 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4400CostAnnum expected:expCs4400CostAnnum  name:@"CS4400 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802Dosage expected:expCs4802Dosage  name:@"CS4802 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802Usage expected:expCs4802Usage  name:@"CS4802 Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802CostKg expected:expCs4802CostKg  name:@"CS4802 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4802CostAnnum expected: expCs4802CostAnnum  name:@"CS4802 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490Dosage expected:expCs4490Dosage  name:@"CS4490 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490Usage expected:expCs4490Usage  name:@"CS4490 Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490CostKg expected:expCs4490CostKg  name:@"CS4490 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cs4490CostAnnum expected:expCs4490CostAnnum  name:@"CS4490 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1Dosage expected:expScg1Dosage  name:@"SCG1 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1Usage expected:expScg1Usage  name:@"SCG1 Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1CostKg expected:expScg1CostKg  name:@"SCG1 Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.scg1CostAnnum expected:expScg1CostAnnum  name:@"SCG1 Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorDosage expected:expCschlorDosage  name:@"CSChlor Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorUsage expected:expCschlorUsage  name:@"CSChlor Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorCostKg expected:expCschlorCostKg  name:@"CSChlor Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.cschlorCostAnnum expected:expCschlorCostAnnum  name:@"CSChlor Cost/Annum"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tDosage expected:expC42tDosage  name:@"C42T Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tUsage expected:expC42tUsage  name:@"C42T Usage"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tCostKg expected:expC42tCostKg  name:@"C42T Cost/kg"]);
                        //XCTAssertTrue([self fieldsMatch:mCoolingModel.c42tCostAnnum expected:expC42tCostAnnum  name:@"C42T Cost/Annum"]);
                        
                        // Inhibitors
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h207Dosage expected:expH207Dosage  name:@"H207  Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h207Usage expected:expH207Usage  name:@"H207 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h2073Dosage expected:expH2073Dosage  name:@"H2073 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h2073Usage expected:expH2073Usage  name:@"H2073 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h280Dosage expected:expH280Dosage  name:@"H280 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h280Usage expected:expH280Usage  name:@"H280 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h2805Dosage expected:expH2805Dosage  name:@"H2805 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h2805Usage expected:expH2805Usage  name:@"H2805 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h390Dosage expected:expH390Dosage  name:@"H390 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h390Usage expected:expH390Usage  name:@"H390 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h3905Dosage expected:expH3905Dosage  name:@"H3905 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h3905Usage expected:expH3905Usage  name:@"H3905 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h391Dosage expected:expH391Dosage  name:@"H391 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h391Usage expected:expH391Usage  name:@"H391 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h423Dosage expected:expH423Dosage  name:@"H423 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h423Usage expected:expH423Usage  name:@"H423 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h425Dosage expected:expH425Dosage  name:@"H425 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h425Usage expected:expH425Usage  name:@"H425 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h4255Dosage expected:expH4255Dosage  name:@"H4255 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h4255Usage expected:expH4255Usage  name:@"H4255 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h535Dosage expected:expH535Dosage  name:@"H535 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h535Usage expected:expH535Usage  name:@"H535 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h874Dosage expected:expH874Dosage  name:@"H874 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.h874Usage expected:expH874Usage  name:@"H874 Usage"]);
                        
                        // Biocides - non-oxidisers
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c31Dosage expected:expC31Dosage  name:@"C31 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c31Usage expected:expC31Usage  name:@"C31 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c32Dosage expected:expC32Dosage  name:@"C32 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c32Usage expected:expC32Usage  name:@"C32 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c44Dosage expected:expC44Dosage  name:@"C44 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c44Usage expected:expC44Usage  name:@"C44 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c45Dosage expected:expC45Dosage  name:@"C45 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c45Usage expected:expC45Usage  name:@"C45 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c48Dosage expected:expC48Dosage  name:@"C48 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c48Usage expected:expC48Usage  name:@"C48 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c51Dosage expected:expC51Dosage  name:@"C51 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c51Usage expected:expC51Usage  name:@"C51 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c52Dosage expected:expC52Dosage  name:@"C52 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c52Usage expected:expC52Usage  name:@"C52 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c54Dosage expected:expC54Dosage  name:@"C54 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c54Usage expected:expC54Usage  name:@"C54 Usage"]);
                        
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c58Dosage expected:expC58Dosage  name:@"C58 Dosage"]);
                        XCTAssertTrue([self fieldsMatch:mCoolingModel.c58Usage expected:expC58Usage  name:@"C58 Usage"]);

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
