//
//  NSDate+Extra.h
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extra)
+ (NSDate *)dateFromServerString:(NSString *)railsString;
@end
