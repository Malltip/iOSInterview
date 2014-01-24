//
//  MallFeedItemCell.h
//  MallTip
//
//  Created by Li Feng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallFeedItem;
@interface MallFeedItemCell : UITableViewCell

- (void) configureWithFeedItem:(MallFeedItem *)item;
@end
