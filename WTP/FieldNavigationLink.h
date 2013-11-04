//
//  FieldNavigationLink.h
//  WTP
//
//  Created by Phil Price on 9/23/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldNavigationLink : NSObject


@property (nonatomic, weak) UITextField *currField;
@property (nonatomic, weak) UITextField *nextField;
@property (nonatomic, weak) UITextField *prevField;


- (id) init;

- (id) initWithFields:(UITextField *)currFld next:(UITextField *)nextFld prev:(UITextField *)prevFld ;

@end
