//
//  FieldNavigationLink.m
//  WTP
//
//  Created by Phil Price on 9/23/13.
//  Copyright (c) 2013 Nateemma. All rights reserved.
//

#import "FieldNavigationLink.h"

@implementation FieldNavigationLink

UITextField *currField;
UITextField *nextField;
UITextField *prevField;

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id) initWithFields:(UITextField *)currFld next:(UITextField *)nextFld prev:(UITextField *)prevFld {
    self = [super init];
    if (self){
        self.currField = currFld;
        self.nextField = nextFld;
        self.prevField = prevFld;
        NSLog(@"FieldNavigationLink.initWithFields: %@", self);
    } else {
        NSLog(@"FieldNavigationLink.initWithFields() - Oops! Error creating self");
    }
    return self;
}

@end
