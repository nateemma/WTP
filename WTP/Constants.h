//
//  Constants.h
//  WTP
//
//  Created by Philip Price on 1/27/16.
//  Copyright © 2016 Nateemma. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// Manual Segues

#define SEGUE_BOILER_INPUT @"BoilerInput"
#define SEGUE_COOLING_INPUT @"CoolingInput"

#define SEGUE_BOILER_SOLIDS @"BoilerSolidProducts"
#define SEGUE_BOILER_LIQUIDS @"BoilerLiquidProducts"

#define SEGUE_COOLING_SOLIDS @"CoolingSolidProducts"
#define SEGUE_COOLING_LIQUIDS @"CoolingLiquidProducts"


// type of product
typedef NS_ENUM(NSInteger, ProductType) { NONE, SOLID, LIQUID };

#endif /* Constants_h */
