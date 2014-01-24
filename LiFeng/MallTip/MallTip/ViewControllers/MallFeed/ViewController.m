//
//  ViewController.m
//  MallTip
//
//  Created by lifeng on 1/24/14.
//  Copyright (c) 2014 Li Feng. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "MallFeedItemCell.h"

#import <CoreData/CoreData.h>

@interface ViewController ()<NSFetchedResultsControllerDelegate>
{
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _isRefreshing = FALSE;
    _isLoadingMore = FALSE;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadFeedItems)];
    
    
    [self loadFeedItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Privates
- (void)loadFeedItems {
    
    if (_isRefreshing || _isLoadingMore)
        return;
    
    _isRefreshing = YES;
    
    [[DataManager manager] getFeedsforMallWithID:@(4168) withCompletionHandler:^(BOOL success, int offsetID, NSString *error) {
        _isRefreshing = NO;
        if (success)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:offsetID forKey:@"MallFeedOffset"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            
        }
    }];
}

- (void)loadMoreItems {
    
    if (_isLoadingMore || _isRefreshing)
        return;
    
    _isLoadingMore = YES;
    //[self.loadingView stopAnimating];
    
    int lastoffset = [[NSUserDefaults standardUserDefaults] integerForKey:@"MallFeedOffset"];
    
    [[DataManager manager] getFeedsforMallWithID:@(4168) withOffsetFeedID:@(lastoffset) withCompletionHandler:^(BOOL success, int offsetID, NSString *error) {
        _isLoadingMore = NO;
        if (success)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:offsetID forKey:@"MallFeedOffset"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            
        }
    }];
}

#pragma mark - Fetch Controller
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        
        NSManagedObjectContext *context = [[DataManager manager] managedObjectContext];
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MallFeedItem"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"feedId" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedResultsController = aFetchedResultsController;
        
        self.fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful
            // during development. If it is not possible to recover from the error, display an alert
            // panel that instructs the user to quit the application by pressing the Home button.
            //
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
	
	return _fetchedResultsController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
	
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kEarthquakeCellID = @"MallFeedItemCell";
  	MallFeedItemCell *cell = (MallFeedItemCell *)[tableView dequeueReusableCellWithIdentifier:kEarthquakeCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MallFeedItem *feedItem = (MallFeedItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithFeedItem:feedItem];
    
    int totoalRows = [self.tableView numberOfRowsInSection:0];
    
    if (totoalRows == indexPath.row + 2)
        [self loadMoreItems];
    
	return cell;
}

@end
