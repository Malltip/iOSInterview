//
//  MTTableViewController.m
//  Malltip Interview
//
//  Created by Adam Cumiskey on 2/28/14.
//  Copyright (c) 2014 adamcumiskey. All rights reserved.
//

#import "MTTableViewController.h"
#import "MTFeed.h"
#import "MTTableViewCell.h"
#import "MTFeedDownloader.h"

@interface MTTableViewController ()
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) NSNumber *currentOffset;
@end

@implementation MTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the ivars
    _feeds = [NSMutableArray array];
    _currentOffset = @0;
    
    [MTFeedDownloader downloadFeedForMallID:@4170
                                 withOffset:_currentOffset
                       andCompletionHandler:^(BOOL success, NSArray *feeds, NSNumber *nextOffset, NSError *error) {
                           if (success) {
                               [_feeds addObjectsFromArray:feeds];
                               [self setCurrentOffset:nextOffset];
                               [self.tableView reloadData];
                           }
                       }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MTFeed *feed = [_feeds objectAtIndex:indexPath.row];
    [cell configureCellForFeed:feed];
    
    return cell;
}

@end
