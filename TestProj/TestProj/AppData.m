//
//  AppData.m
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import "AppData.h"

NSString * const API_KEY       = @"abcdef";
NSString * const BASEURL_PROD  = @"https://m.malltip.com/api/v1/mall/";
NSString * const BASEURL_DEVEL = @"https://m.malltip.com/api/v1/mall/";
NSString * const BASEURL_IMAGE = @"https://d2yrj8lu79au2z.cloudfront.net/logos/";
BOOL       const DEVEL_SERVER  = YES;


static AppData * instance;

@implementation AppData
{
    NSUserDefaults * _userDefaults;
}

+ (AppData *)appData{
    @synchronized (self){
        if (instance == nil){
            instance = [[AppData alloc] init];
        }
    }
    return instance;
}

- (id)init{
    self = [super init];
    if (self){
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}


#pragma mark - Feeds

- (NSArray *)feeds{
    NSData * data = [_userDefaults objectForKey:@"feeds"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setFeeds:(NSArray *)feeds{
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:feeds];
    
    [_userDefaults setObject:data forKey:@"feeds"];
    [_userDefaults synchronize];
}



#pragma mark - globa function
-(NSString *)apiKey{
    return API_KEY;
}

- (NSString *)getBaseUrl{
    if (DEVEL_SERVER){
        return BASEURL_DEVEL;
    }
    else{
        return BASEURL_PROD;
    }
}

- (NSString *)getBaseImageUrl{
    return BASEURL_IMAGE;
}


@end