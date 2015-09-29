//
//  HttpService.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SSSERVICE_GETFEED 1

@protocol HttpServiceDelegate <NSObject>

- (void)httpServiceDidPostWithReceiveData:(NSData *)data type:(NSNumber *) type;
- (void)httpServiceDidRequestData:(NSData *)data type:(NSNumber *)type;


@end

@interface HttpService : NSObject 

@property id<HttpServiceDelegate> delegate;

- (void)sendAsyncPostRequestWithUrl:(NSURL *)url data:(NSData *)data type:(int)type;
- (void)requestDataFromUrl:(NSURL *)url type:(int)type;

@end
