//
//  CoolingWaterModel.h
//  WTP
//
//  Created by Phil Price on 9/16/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//
//
//  11/6/13 - removed cost parameters by customer request (commented out for now)
//

#import <Foundation/Foundation.h>

@interface CoolingWaterModel :  NSObject

// string versions of inputs

@property (copy, nonatomic) NSString *inCirculation;
@property (copy, nonatomic) NSString *inDeltaT;
@property (copy, nonatomic) NSString *inSumpVolume;
@property (copy, nonatomic) NSString *inSysVolume;
@property (copy, nonatomic) NSString *inConcFactor;

@property (copy, nonatomic) NSString *inTDS;
@property (copy, nonatomic) NSString *inTotalHardness;
@property (copy, nonatomic) NSString *inMAlk;
@property (copy, nonatomic) NSString *inPH;
@property (copy, nonatomic) NSString *inChlorides;

@property (copy, nonatomic) NSString *inHours;
@property (copy, nonatomic) NSString *inDays;
@property (copy, nonatomic) NSString *inWeeks;

// Site name
@property (copy, nonatomic) NSString *site;

// Criteria parameters
@property (copy, nonatomic) NSNumber *circulation;
@property (copy, nonatomic) NSNumber *deltaT;
@property (copy, nonatomic) NSNumber *sumpVolume;
@property (copy, nonatomic) NSNumber *sysVolume;
@property (copy, nonatomic) NSNumber *concFactor;


// Makeup Water Quality params
@property (copy, nonatomic) NSNumber *TDS;
@property (copy, nonatomic) NSNumber *totalHardness;
@property (copy, nonatomic) NSNumber *MAlk;
@property (copy, nonatomic) NSNumber *pH;
@property (copy, nonatomic) NSNumber *chlorides;


// Duty/Operation params

@property (copy, nonatomic) NSNumber *hours;
@property (copy, nonatomic) NSNumber *days;
@property (copy, nonatomic) NSNumber *weeks;


// Calculated values

// Criteria-based intermediate values
@property (copy, nonatomic) NSNumber *evaporation;
@property (copy, nonatomic) NSNumber *bleed;
@property (copy, nonatomic) NSNumber *makeup;
@property (copy, nonatomic) NSNumber *makeupAnnum;

// I don't know what these are, just intermediate values
@property (copy, nonatomic) NSNumber *theoryQ1;
@property (copy, nonatomic) NSNumber *theoryQ2;
@property (copy, nonatomic) NSNumber *theoryQ3;
@property (copy, nonatomic) NSNumber *theoryQ4;
@property (copy, nonatomic) NSNumber *theoryQ5;

// Product-based values
@property (copy, nonatomic) NSNumber *hs2097Dosage;
@property (copy, nonatomic) NSNumber *hs2097Usage;
//@property (copy, nonatomic) NSNumber *hs2097CostKg;
//@property (copy, nonatomic) NSNumber *hs2097CostAnnum;
//@property (copy, nonatomic) NSString *hs2097Description;

@property (copy, nonatomic) NSNumber *hs4390Dosage;
@property (copy, nonatomic) NSNumber *hs4390Usage;
//@property (copy, nonatomic) NSNumber *hs4390CostKg;
//@property (copy, nonatomic) NSNumber *hs4390CostAnnum;
//@property (copy, nonatomic) NSString *hs4390Description;

@property (copy, nonatomic) NSNumber *hs3990Dosage;
@property (copy, nonatomic) NSNumber *hs3990Usage;
//@property (copy, nonatomic) NSNumber *hs3990CostKg;
//@property (copy, nonatomic) NSNumber *hs3990CostAnnum;
//@property (copy, nonatomic) NSString *hs3990Description;

// Biocide values

@property (copy, nonatomic) NSNumber *cs4400Dosage;
@property (copy, nonatomic) NSNumber *cs4400Usage;
//@property (copy, nonatomic) NSNumber *cs4400CostKg;
//@property (copy, nonatomic) NSNumber *cs4400CostAnnum;
//@property (copy, nonatomic) NSString *cs4400Description;

@property (copy, nonatomic) NSNumber *cs4802Dosage;
@property (copy, nonatomic) NSNumber *cs4802Usage;
//@property (copy, nonatomic) NSNumber *cs4802CostKg;
//@property (copy, nonatomic) NSNumber *cs4802CostAnnum;
//@property (copy, nonatomic) NSString *cs4802Description;

@property (copy, nonatomic) NSNumber *cs4490Dosage;
@property (copy, nonatomic) NSNumber *cs4490Usage;
//@property (copy, nonatomic) NSNumber *cs4490CostKg;
//@property (copy, nonatomic) NSNumber *cs4490CostAnnum;
//@property (copy, nonatomic) NSString *cs4490Description;

@property (copy, nonatomic) NSNumber *scg1Dosage;
@property (copy, nonatomic) NSNumber *scg1Usage;
//@property (copy, nonatomic) NSNumber *scg1CostKg;
//@property (copy, nonatomic) NSNumber *scg1CostAnnum;
//@property (copy, nonatomic) NSString *scg1Description;

@property (copy, nonatomic) NSNumber *cschlorDosage;
@property (copy, nonatomic) NSNumber *cschlorUsage;
//@property (copy, nonatomic) NSNumber *cschlorCostKg;
//@property (copy, nonatomic) NSNumber *cschlorCostAnnum;
//@property (copy, nonatomic) NSString *cschlorDescription;

@property (copy, nonatomic) NSNumber *c42tDosage;
@property (copy, nonatomic) NSNumber *c42tUsage;
//@property (copy, nonatomic) NSNumber *c42tCostKg;
//@property (copy, nonatomic) NSNumber *c42tCostAnnum;
//@property (copy, nonatomic) NSString *c42tDescription;

// LIQUIDS

// Inhibitors
@property (copy, nonatomic) NSNumber *h207Dosage;
@property (copy, nonatomic) NSNumber *h207Usage;

@property (copy, nonatomic) NSNumber *h2073Dosage;
@property (copy, nonatomic) NSNumber *h2073Usage;

@property (copy, nonatomic) NSNumber *h280Dosage;
@property (copy, nonatomic) NSNumber *h280Usage;

@property (copy, nonatomic) NSNumber *h2805Dosage;
@property (copy, nonatomic) NSNumber *h2805Usage;

@property (copy, nonatomic) NSNumber *h390Dosage;
@property (copy, nonatomic) NSNumber *h390Usage;

@property (copy, nonatomic) NSNumber *h3905Dosage;
@property (copy, nonatomic) NSNumber *h3905Usage;

@property (copy, nonatomic) NSNumber *h391Dosage;
@property (copy, nonatomic) NSNumber *h391Usage;

@property (copy, nonatomic) NSNumber *h423Dosage;
@property (copy, nonatomic) NSNumber *h423Usage;

@property (copy, nonatomic) NSNumber *h425Dosage;
@property (copy, nonatomic) NSNumber *h425Usage;

@property (copy, nonatomic) NSNumber *h4255Dosage;
@property (copy, nonatomic) NSNumber *h4255Usage;

@property (copy, nonatomic) NSNumber *h535Dosage;
@property (copy, nonatomic) NSNumber *h535Usage;

@property (copy, nonatomic) NSNumber *h874Dosage;
@property (copy, nonatomic) NSNumber *h874Usage;

// Biocides - non-oxidisers
@property (copy, nonatomic) NSNumber *c31Dosage;
@property (copy, nonatomic) NSNumber *c31Usage;

@property (copy, nonatomic) NSNumber *c32Dosage;
@property (copy, nonatomic) NSNumber *c32Usage;

@property (copy, nonatomic) NSNumber *c44Dosage;
@property (copy, nonatomic) NSNumber *c44Usage;

@property (copy, nonatomic) NSNumber *c45Dosage;
@property (copy, nonatomic) NSNumber *c45Usage;

@property (copy, nonatomic) NSNumber *c48Dosage;
@property (copy, nonatomic) NSNumber *c48Usage;

@property (copy, nonatomic) NSNumber *c51Dosage;
@property (copy, nonatomic) NSNumber *c51Usage;

@property (copy, nonatomic) NSNumber *c52Dosage;
@property (copy, nonatomic) NSNumber *c52Usage;

@property (copy, nonatomic) NSNumber *c54Dosage;
@property (copy, nonatomic) NSNumber *c54Usage;

@property (copy, nonatomic) NSNumber *c58Dosage;
@property (copy, nonatomic) NSNumber *c58Usage;



// Methods

- (id)init;

+ (id)sharedInstance;

- (BOOL) inputsValid;

- (void) calculateAmounts ;

- (void) restore ;

- (void) save ;

@end
