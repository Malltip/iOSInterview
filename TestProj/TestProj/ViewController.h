//
//  ViewController.h
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MalltipService.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MalltipServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblFeed;

@end
