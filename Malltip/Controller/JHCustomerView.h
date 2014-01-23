//
//  JHCustomerView.h
//  Malltip
//
//  Created by Jin Ming on 1/23/14.
//  Copyright (c) 2013 Jin Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCustomerView : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* tableMalltip;
    NSMutableArray* arrMain;
}

@end
