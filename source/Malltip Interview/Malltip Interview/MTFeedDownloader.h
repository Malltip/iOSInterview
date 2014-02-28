//
//  MTFeedDownloader.h
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^feedCompletionHandler)(BOOL success,
                                      NSArray *feeds,
                                      NSNumber *nextOffset,
                                      NSError *error);

@interface MTFeedDownloader : NSObject

// Download a feed for the given mallID with the given offset and return the data through the completionHandler
+ (void)downloadFeedForMallID:(NSNumber *)mallID
                   withOffset:(NSNumber *)offset
         andCompletionHandler:(feedCompletionHandler)completionHandler;

@end
