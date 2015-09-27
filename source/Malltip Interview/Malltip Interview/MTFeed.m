//
//  MTFeed.m
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import "MTFeed.h"

static NSString *const feedIDKey = @"feedId";
static NSString *const retailerIDKey = @"retailerId";
static NSString *const retailerNameKey = @"retailerName";
static NSString *const titleKey = @"title";
static NSString *const dateValidKey = @"dateValid";
static NSString *const endDateKey = @"endDate";
static NSString *const hasLogoKey = @"hasLogo";
static NSString *const isInMallKey = @"isInMall";
static NSString *const mallIDNameKey = @"mallIDName";
static NSString *const approvedKey = @"approved";
static NSString *const isSavedKey = @"isSaved";
static NSString *const isValidKey = @"isValid";

static NSString *const kLogoEndpoint = @"https://d2yrj8lu79au2z.cloudfront.net/logos/";

@implementation MTFeed

#pragma mark - Public Methods
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _feedID = [dictionary objectForKey:feedIDKey];
        _retailerID = [dictionary objectForKey:retailerIDKey];
        _retailerName = [dictionary objectForKey:retailerNameKey];
        _title = [dictionary objectForKey:titleKey];
        _dateValid = [dictionary objectForKey:dateValidKey];
        _endDate = [self dateForDateString:[dictionary objectForKey:endDateKey]];
        _hasLogo = [[dictionary objectForKey:hasLogoKey] boolValue];
        _isInMall = [[dictionary objectForKey:isInMallKey] boolValue];
        _mallIDName = [dictionary objectForKey:mallIDNameKey];
        _approved = [[dictionary objectForKey:approvedKey] boolValue];
        _isSaved = [[dictionary objectForKey:isSavedKey] boolValue];
        _isValid = [[dictionary objectForKey:isValidKey] boolValue];
    }
    return self;
}

- (void)getLogoWithCompletionHandler:(logoCompletionHandler)completionHandler;
{
    // Create the request
    NSString *urlString = [NSString stringWithFormat:@"%@%@.png",
                           kLogoEndpoint,
                           _retailerID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPShouldUsePipelining:YES];
    
    // Asychronously grab the image data and return it through the block
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"Connection Errror: %@", connectionError.localizedDescription);
                                   completionHandler(NO, nil, connectionError);
                               } else {
                                   UIImage *logo = [UIImage imageWithData:data];
                                   completionHandler(YES, logo, nil);
                               }
                           }];
}

#pragma mark - Private Methods
// Format the date string into an NSDate
- (NSDate *)dateForDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd'T'hh:mm:ss'H'"];
    return [formatter dateFromString:dateString];
}

@end