//
//  FeedCell.h
//  Malltip
//
//  Created by Zhang Ling on 1/23/14.
//  Copyright (c) 2014 Yuriy Plehanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIButton *m_Icon;
@property(strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property(strong, nonatomic) IBOutlet UILabel *m_lblDateValid;


- (void) setUpWithTag:(int)tag Icon:(NSString *)_icon Title:(NSString *)_title
            DateValid:(NSString *)_dateValid;

@end
