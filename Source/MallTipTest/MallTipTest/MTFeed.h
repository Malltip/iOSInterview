//
//  MTFeed.h
//  MallTipTest
//
//  Created by Matthew Griffin on 2/6/14.
//  Copyright (c) 2014 Matthew Griffin. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MTFeed : NSManagedObject

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *dateValid;

@property NSString* retailerId;

@end
