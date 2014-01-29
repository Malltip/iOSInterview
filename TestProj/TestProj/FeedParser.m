//
//  FeedParser.m
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import "FeedParser.h"
#import "Feed.h"
#import "NSString+SBJSON.h"

@implementation FeedParser
{
    NSString *_strJSON;
    NSArray *_arrayJSON;
    Feed * _tempFeed;
    NSMutableArray * _feeds;
}



- (id)initWithJSONData:(NSData *)JSONData{
    self = [super init];
    if (self){
        
        _strJSON = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        _arrayJSON = [NSMutableArray array];
        _feeds = [NSMutableArray array];
    }
    return self;
}

- (void)start{
    NSNumber *offset = [[_strJSON JSONValue] objectForKey:@"offset"];
    _arrayJSON = (NSArray*)[[_strJSON JSONValue] objectForKey:@"feeds"];
    NSUInteger nCount = [_arrayJSON count];
    
    for (int i = 0; i < nCount; i ++) {
        NSDictionary *dicJSONElement = [_arrayJSON objectAtIndex:i];
        _tempFeed = [[Feed alloc] init];
        
        _tempFeed.feedId = [dicJSONElement objectForKey:@"feedId"];
        _tempFeed.retailerId = [dicJSONElement objectForKey:@"retailerId"];
        _tempFeed.retailerName = [dicJSONElement objectForKey:@"retailerName"];
        _tempFeed.title = [dicJSONElement objectForKey:@"title"];
        _tempFeed.dateValid = [dicJSONElement objectForKey:@"dateValid"];
        _tempFeed.EndDate = [dicJSONElement objectForKey:@"EndDate"];
        _tempFeed.hasLogo = [[dicJSONElement objectForKey:@"hasLogo"] boolValue];
        _tempFeed.isInMall = [[dicJSONElement objectForKey:@"isInMall"] boolValue];
        _tempFeed.MallNameId = [dicJSONElement objectForKey:@"MallNameId"];
        _tempFeed.approved = [[dicJSONElement objectForKey:@"approved"] boolValue];
        _tempFeed.isSaved = [[dicJSONElement objectForKey:@"isSaved"] boolValue];
        _tempFeed.isValid = [[dicJSONElement objectForKey:@"isValid"] boolValue];
        
        [_feeds addObject:_tempFeed];
    }
    _tempFeed= nil;
    
    NSLog(@"Feed parse ends");
    [self.delegate performSelector:@selector(FeedParserDidParser:withOffset:) withObject:_feeds withObject:offset];
    
}



@end

