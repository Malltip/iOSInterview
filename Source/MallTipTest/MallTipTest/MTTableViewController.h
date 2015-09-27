//
//  MTTableViewController.h
//  MallTipTest
//
//  Created by Matthew Griffin on 2/5/14.
//  Copyright (c) 2014 Matthew Griffin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic,retain) RKResponseDescriptor *responseDescriptor;

@end
