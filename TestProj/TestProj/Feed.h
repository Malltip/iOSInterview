//
//  Feed.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property NSString *feedId;
@property NSString *retailerId;
@property NSString *retailerName;
@property NSString *title;
@property NSString *dateValid;
@property NSString *EndDate;
@property BOOL     hasLogo;
@property BOOL     isInMall;
@property NSString *MallNameId;
@property BOOL     approved;
@property BOOL     isSaved;
@property BOOL     isValid;

@end
