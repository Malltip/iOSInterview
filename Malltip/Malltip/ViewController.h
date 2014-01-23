//
//  ViewController.h
//  Malltip
//
//  Created by Zhang Ling on 1/23/14.
//  Copyright (c) 2014 Yuriy Plehanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface ViewController : UIViewController
{
    MBProgressHUD           *mProgress;
}
@property(strong, nonatomic) IBOutlet UITableView *m_tblMalltip;
@property(strong, nonatomic) NSMutableArray *m_aryMalltips;
@end
