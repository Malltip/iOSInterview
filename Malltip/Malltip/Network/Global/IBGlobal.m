//
//  IBGlobal.m
//  iButtons
//
//  Created by Cai QingRe on 3/20/13.
//  Copyright (c) 2013 XYZ. All rights reserved.
//

#import "IBGlobal.h"

@implementation IBGlobal

#pragma mark singleton
//======================================================================================================================================
+ (id)getInstance {
    static IBGlobal * instance = nil;
    if (!instance) {
        instance = [[IBGlobal alloc] init];
    }
    return instance;
}

#pragma mark init
//======================================================================================================================================
- (id)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark Global Function
//======================================================================================================================================

@end
