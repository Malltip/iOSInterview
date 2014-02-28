//
//  MTTableViewCell.h
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTFeed;

@interface MTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateValidLabel;

// Configure a cell for a given MTFeed object
- (void)configureCellForFeed:(MTFeed *)feed;

@end
