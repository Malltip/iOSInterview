//
//  CustomTableCell.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface CustomTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet AsyncImageView *imageIcon;
@property (nonatomic, weak) IBOutlet UILabel        *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel        *lblSubTitle;

@end
