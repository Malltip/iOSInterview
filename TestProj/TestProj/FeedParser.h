//
//  FeedParser.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FeedParserDelegate <NSObject>

@required
- (void)FeedParserDidParser:(NSArray *)feeds withOffset:(NSNumber*)offset;

@end

@interface FeedParser : NSObject

@property id<FeedParserDelegate> delegate;

- (id)initWithJSONData:(NSData *)JSONData;

- (void)start;


@end
