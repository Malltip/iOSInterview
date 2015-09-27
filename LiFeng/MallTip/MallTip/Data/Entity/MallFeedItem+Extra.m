//
//  MallFeedItem+Extra.m
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "MallFeedItem+Extra.h"
#import "NSManagedObject+Extra.h"
#import "NSDate+Extra.h"

@implementation MallFeedItem (Extra)
- (void)setValuesFromDictionary:(NSDictionary *)dictionary
{
    [self safeSetValuesForKeysWithDictionary:dictionary];
    self.mallNameId = dictionary[@"MallNameId"];
    self.endDate = [NSDate dateFromServerString:dictionary[@"EndDate"]];
}
@end
