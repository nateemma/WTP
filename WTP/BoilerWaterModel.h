//
//  BoilerWaterModel.h
//  WTP
//
//  Created by Phil Price on 9/2/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//  01/23/14 - added support for liquid products


#import <Foundation/Foundation.h>

// Class that represents the data and algorithms of a boiler site

@interface BoilerWaterModel : NSObject


// Site Name
@property (copy, nonatomic) NSString *site; // this is the key for the data

// String values provided by user
@property (copy, nonatomic) NSString *inSumSteam;
@property (copy, nonatomic) NSString *inSumHours;
@property (copy, nonatomic) NSString *inSumDays;
@property (copy, nonatomic) NSString *inSumWeeks;
@property (copy, nonatomic) NSString *inWinSteam;
@property (copy, nonatomic) NSString *inWinHours;
@property (copy, nonatomic) NSString *inWinDays;
@property (copy, nonatomic) NSString *inWinWeeks;
@property (copy, nonatomic) NSString *inTDS;
@property (copy, nonatomic) NSString *inMAlk;
@property (copy, nonatomic) NSString *inPH;
@property (copy, nonatomic) NSString *inCaHardness;
@property (copy, nonatomic) NSString *inTemp;
@property (copy, nonatomic) NSString *inMaxTDS;
@property (copy, nonatomic) NSString *inMinSulphite;
@property (copy, nonatomic) NSString *inMinCausticAlk;


// Boiler Duty parameters
@property (copy, nonatomic) NSNumber *sumSteam;
@property (copy, nonatomic) NSNumber *sumHours;
@property (copy, nonatomic) NSNumber *sumDays;
@property (copy, nonatomic) NSNumber *sumWeeks;
@property (copy, nonatomic) NSNumber *winSteam;
@property (copy, nonatomic) NSNumber *winHours;
@property (copy, nonatomic) NSNumber *winDays;
@property (copy, nonatomic) NSNumber *winWeeks;

// Feedwater params
@property (copy, nonatomic) NSNumber *TDS;
@property (copy, nonatomic) NSNumber *MAlk;
@property (copy, nonatomic) NSNumber *pH;
@property (copy, nonatomic) NSNumber *CaHardness;
@property (copy, nonatomic) NSNumber *temp;


// Boiler Details params
@property (copy, nonatomic) NSNumber *maxTDS;
@property (copy, nonatomic) NSNumber *minSulphite;
@property (copy, nonatomic) NSNumber *minCausticAlk;

@property (copy, nonatomic) NSNumber *minAlkalinity;
@property (copy, nonatomic) NSNumber *annualFeed;
@property (copy, nonatomic) NSNumber *dissolvedO2;

// Calculated values - Solids
@property (copy, nonatomic) NSNumber *ss1295Dosage;
@property (copy, nonatomic) NSNumber *ss1295Usage;

@property (copy, nonatomic) NSNumber *ss1350Dosage;
@property (copy, nonatomic) NSNumber *ss1350Usage;

@property (copy, nonatomic) NSNumber *ss1095Dosage;
@property (copy, nonatomic) NSNumber *ss1095Usage;

@property (copy, nonatomic) NSNumber *ss1995Dosage;
@property (copy, nonatomic) NSNumber *ss1995Usage;

@property (copy, nonatomic) NSNumber *ss2295Dosage;
@property (copy, nonatomic) NSNumber *ss2295Usage;

@property (copy, nonatomic) NSNumber *ss8985Dosage;
@property (copy, nonatomic) NSNumber *ss8985Usage;


// Calculated values - Liquids
@property (copy, nonatomic) NSNumber *s5Dosage;
@property (copy, nonatomic) NSNumber *s5Usage;

@property (copy, nonatomic) NSNumber *s10Dosage;
@property (copy, nonatomic) NSNumber *s10Usage;

@property (copy, nonatomic) NSNumber *s123Dosage;
@property (copy, nonatomic) NSNumber *s123Usage;

@property (copy, nonatomic) NSNumber *s125Dosage;
@property (copy, nonatomic) NSNumber *s125Usage;

@property (copy, nonatomic) NSNumber *s26Dosage;
@property (copy, nonatomic) NSNumber *s26Usage;

@property (copy, nonatomic) NSNumber *s28Dosage;
@property (copy, nonatomic) NSNumber *s28Usage;

@property (copy, nonatomic) NSNumber *s19Dosage;
@property (copy, nonatomic) NSNumber *s19Usage;

@property (copy, nonatomic) NSNumber *s456Dosage;
@property (copy, nonatomic) NSNumber *s456Usage;

@property (copy, nonatomic) NSNumber *s124Dosage;
@property (copy, nonatomic) NSNumber *s124Usage;

@property (copy, nonatomic) NSNumber *s22Dosage;
@property (copy, nonatomic) NSNumber *s22Usage;

@property (copy, nonatomic) NSNumber *s23Dosage;
@property (copy, nonatomic) NSNumber *s23Usage;

@property (copy, nonatomic) NSNumber *s88Dosage;
@property (copy, nonatomic) NSNumber *s88Usage;

@property (copy, nonatomic) NSNumber *s95Dosage;
@property (copy, nonatomic) NSNumber *s95Usage;



// Methods

- (id)init;

+ (id)sharedInstance;

- (BOOL) inputsValid;

- (void) calculateAmounts ;

- (void) restore ;

- (void) save ;

- (BOOL) savedDataPresent ;
    

@end
