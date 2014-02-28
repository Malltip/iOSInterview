//
//  MTFeedDownloader.m
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import "MTFeedDownloader.h"
#import "MTFeed.h"

static NSString *const feedsKey = @"feeds";
static NSString *const offsetKey = @"offset";

static NSString *const kAPIEndpointString = @"https://m.malltip.com/api/v1/mall/";

@implementation MTFeedDownloader

+ (void)downloadFeedForMallID:(NSNumber *)mallID
                   withOffset:(NSNumber *)offset
         andCompletionHandler:(feedCompletionHandler)completionHandler
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@/feed/offset/%@",
                           kAPIEndpointString,
                           mallID,
                           offset];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldUsePipelining:YES];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"Connection Error: %@", connectionError.localizedDescription);
                                   completionHandler(NO, nil, nil, connectionError);
                               } else {
                                   NSError *jsonError = nil;
                                   NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&jsonError];
                                   // If the JSON data is valid
                                   if (rootDictionary && (id)rootDictionary != [NSNull null] && !jsonError) {
                                       NSNumber *offset = [NSNumber numberWithLong:[[rootDictionary objectForKey:offsetKey] longValue]];
                                       NSArray *feedsArray = [rootDictionary objectForKey:feedsKey];
                                       
                                       // Array to store the parsed MTFeed objects
                                       NSMutableArray *feedObjects = [NSMutableArray array];
                                       for (NSDictionary *feedDictionary in feedsArray) {
                                           MTFeed *feed = [[MTFeed alloc] initWithDictionary:feedDictionary];
                                           [feedObjects addObject:feed];
                                       }
                                       
                                       completionHandler(YES, [NSArray arrayWithArray:feedObjects], offset, nil);
                                       
                                   } else {
                                       NSLog(@"JSON Error");
                                       completionHandler(NO, nil, nil, jsonError);
                                   }
                               }
                           }];
}

@end
