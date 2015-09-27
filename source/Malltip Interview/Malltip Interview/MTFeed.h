//
//  MTFeed.h
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import <Foundation/Foundation.h>

// Completion block for returning the logo
typedef void (^logoCompletionHandler)(BOOL success,
                                         UIImage *logo,
                                         NSError *error);

@interface MTFeed : NSObject

@property (nonatomic) NSNumber *feedID;
@property (nonatomic) NSNumber *retailerID;
@property (strong, nonatomic) NSString *retailerName;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *dateValid;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) BOOL hasLogo;
@property (nonatomic) BOOL isInMall;
@property (strong, nonatomic) NSString *mallIDName;
@property (nonatomic) BOOL approved;
@property (nonatomic) BOOL isSaved;
@property (nonatomic) BOOL isValid;

// Initializes the object from a json dictionary
- (id)initWithDictionary:(NSDictionary *)dictionary;

// Returns the UIImage of the logo in a block
- (void)getLogoWithCompletionHandler:(logoCompletionHandler)completionHandler;

@end