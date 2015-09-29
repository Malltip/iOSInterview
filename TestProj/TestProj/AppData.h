//
//  AppData.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const API_KEY;
extern NSString * const BASEURL_PROD;
extern NSString * const BASEURL_DEVEL;
extern NSString * const BASEURL_IMAGE;
extern BOOL const DEVEL_SERVER;

@interface AppData : NSObject

+ (AppData *)appData;


- (NSString *)getBaseUrl;

- (NSString *)getBaseImageUrl;

@end

