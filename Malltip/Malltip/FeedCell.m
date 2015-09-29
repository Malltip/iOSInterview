//
//  FeedCell.m
//  Malltip
//
//  Created by Zhang Ling on 1/23/14.
//  Copyright (c) 2014 Yuriy Plehanov. All rights reserved.
//

#import "FeedCell.h"
#import "UIButton+WebCache.h"

@implementation FeedCell

@synthesize m_Icon;
@synthesize m_lblDateValid;
@synthesize m_lblTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setUpWithTag:(int)tag Icon:(NSString *)_icon Title:(NSString *)_title
            DateValid:(NSString *)_dateValid {
    
    NSURL *_url = [NSURL URLWithString:_icon];
    [m_Icon setImageWithURL:_url forState:UIControlStateNormal placeholderImage:nil];

    [m_lblTitle setText:_title];
    [m_lblDateValid setText:_dateValid];
    
    [m_Icon setTag:tag];
    [self setTag:tag];
}

@end
