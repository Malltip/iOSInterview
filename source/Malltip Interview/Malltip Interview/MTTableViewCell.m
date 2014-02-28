//
//  MTTableViewCell.m
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import "MTTableViewCell.h"
#import "MTFeed.h"

@implementation MTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForFeed:(MTFeed *)feed
{
    [_titleLabel setText:feed.title];
    [_dateValidLabel setText:feed.dateValid];
    
    // Asynchronously grab the image and set it when it gets downloaded
    [feed getLogoWithCompletionHandler:^(BOOL success, UIImage *logo, NSError *error) {
        if (success) {
            [_logoImageView setImage:logo];
            [self setNeedsDisplay];
        }
    }];
}

@end
