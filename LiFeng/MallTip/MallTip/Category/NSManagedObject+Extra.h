//
//  NSManagedObject+Extra.h
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extra)
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
@end
