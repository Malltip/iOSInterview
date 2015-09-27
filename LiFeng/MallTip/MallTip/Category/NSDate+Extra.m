//
//  NSDate+Extra.m
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "NSDate+Extra.h"

@implementation NSDate (Extra)
+ (NSDate *)dateFromServerString:(NSString *)railsString {
	//2013-11-29T22:27:35z.
	NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss'z'";
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	[formatter setDateFormat:formatString];
	NSDate *ret = [formatter dateFromString:railsString];
	return ret;
}
@end
