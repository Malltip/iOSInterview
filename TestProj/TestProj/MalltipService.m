//
//  MalltipService.m
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import "MalltipService.h"
#import "AppData.h"
#import "FeedParser.h"

@implementation MalltipService

- (void)getFeedsWithMallID:(NSString*)strMallID andOffset:(int)offset{
    NSString * url = [[AppData appData].getBaseUrl stringByAppendingFormat:@"%@/feed/offset/%d", strMallID, offset];
    
    HttpService * http = [[HttpService alloc] init];
    http.delegate = self;
    [http requestDataFromUrl:[NSURL URLWithString:url] type:SSSERVICE_GETFEED];
}


#pragma mark - httpService delegate
- (void)httpServiceDidPostWithReceiveData:(NSData *)data type:(NSNumber *)type{
    switch (type.intValue) {
        default:
            break;
    }
}

- (void)httpServiceDidRequestData:(NSData *)data type:(NSNumber *)type{
    switch (type.intValue) {
        case SSSERVICE_GETFEED:
        {
            FeedParser * parser = [[FeedParser alloc] initWithJSONData:data];
            parser.delegate = self;
            [parser start];
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - suggestion delegate
- (void)FeedParserDidParser:(NSArray *)feeds withOffset:(NSNumber*)offset{
    NSLog(@"\nload feeds ok");
    [self.delegate performSelector:@selector(MalltipServiceDIdGetFeeds:withOffset:) withObject:feeds withObject:offset];
}


@end
