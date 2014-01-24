//
//  NSManagedObject+Extra.m
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "NSManagedObject+Extra.h"
#import "NSDate+Extra.h"

@implementation NSManagedObject (Extra)
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    if(![keyedValues respondsToSelector:@selector(objectForKey:)])
        return;
    
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if (value == nil) {
            // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ([value isKindOfClass:[NSNull class]]) {
            value =  nil;
        } else if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value  integerValue]];
        } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if (attributeType == NSDateAttributeType) {
			value = [NSDate dateFromServerString:value];
		}
        [self setValue:value forKey:attribute];
    }
}
@end
