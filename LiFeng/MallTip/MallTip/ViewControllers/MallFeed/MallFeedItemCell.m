//
//  MallFeedItemCell.m
//  MallTip
//
//  Created by Li Feng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "MallFeedItemCell.h"
#import "MallFeedItem.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MallFeedItemCell()

@property (nonatomic, strong) IBOutlet UIImageView *retailerImage;
@property (nonatomic, strong) IBOutlet UILabel     *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel     *dateValidLabel;
@property (nonatomic, weak) MallFeedItem *item;
@end

@implementation MallFeedItemCell

- (void) configureWithFeedItem:(MallFeedItem *)aItem
{
    if (self.item == aItem)
        return;
    
    self.item = aItem;
    self.retailerImage.image = nil;
    
    self.titleLabel.text = aItem.title;
    self.dateValidLabel.text = aItem.dateValid;
    
    [self.retailerImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://d2yrj8lu79au2z.cloudfront.net/logos/%@.png", aItem.retailerId]]
                       placeholderImage:nil];
}

@end
