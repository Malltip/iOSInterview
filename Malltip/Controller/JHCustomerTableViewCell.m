//
//  JHCustomerTableViewCell.m
//  Malltip
//
//  Created by Jin Ming on 1/23/14.
//  Copyright (c) 2014 Jin Ming. All rights reserved.
//

#import "JHCustomerTableViewCell.h"

@implementation JHCustomerTableViewCell

@synthesize mainImageView;
@synthesize titleLabel;
@synthesize smallLabel;

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

@end
