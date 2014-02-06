//
//  MTCell.h
//  
//
//  Created by Matthew Griffin on 2/6/14.
//
//

#import <UIKit/UIKit.h>

@interface MTCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *customImageView;

@property (nonatomic,retain) IBOutlet UILabel *mainLabel;

@property (nonatomic,retain) IBOutlet UILabel *detailLabel;

@end
