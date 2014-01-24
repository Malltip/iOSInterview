//
//  MallFeedItem.h
//  MallTip
//
//  Created by Li Feng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MallFeedItem : NSManagedObject

@property (nonatomic, retain) NSNumber * approved;
@property (nonatomic, retain) NSString * dateValid;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * feedId;
@property (nonatomic, retain) NSNumber * hasLogo;
@property (nonatomic, retain) NSNumber * isInMall;
@property (nonatomic, retain) NSNumber * isSaved;
@property (nonatomic, retain) NSNumber * isValid;
@property (nonatomic, retain) NSString * mallNameId;
@property (nonatomic, retain) NSNumber * retailerId;
@property (nonatomic, retain) NSString * retailerName;
@property (nonatomic, retain) NSString * title;

@end
