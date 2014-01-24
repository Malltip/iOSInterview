//
//  DataManager.h
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager*)manager;
- (NSManagedObjectContext *)managedObjectContext;

- (void)getFeedsforMallWithID:(NSNumber*)itemID withOffsetFeedID:(NSNumber *)offsetID withCompletionHandler:(void(^)(BOOL success, int offsetID, NSString *error))handler;
- (void)getFeedsforMallWithID:(NSNumber*)itemID withCompletionHandler:(void(^)(BOOL success, int offsetID, NSString *error))handler;
;
@end
