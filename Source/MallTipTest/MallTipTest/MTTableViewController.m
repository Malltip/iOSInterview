//
//  MTTableViewController.m
//  MallTipTest
//
//  Created by Matthew Griffin on 2/5/14.
//  Copyright (c) 2014 Matthew Griffin. All rights reserved.
//

#import "MTTableViewController.h"
#import "MTCell.h"
#import "MTFeed.h"

@interface MTTableViewController ()

@end

@implementation MTTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"feedId" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
    [self loadData];
}

- (void)loadData
{
    
    //Refresh Data If necessary
    //would be attached to reload button, etc
    
    
    
    
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Feed" inManagedObjectStore:managedObjectStore];

    [entityMapping addAttributeMappingsFromDictionary:@{
                                                        @"feedId":             @"feedId",
                                                        @"retailerId":            @"retailerId",
                                                        @"dateValid":    @"dateValid",
                                                        @"hasLogo":         @"hasLogo",
                                                        @"title":     @"title"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodGET pathPattern:nil  keyPath:@"feeds" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.malltip.com/api/v1/mall/4168/feed/offset/0"]];
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    managedObjectRequestOperation.managedObjectCache = [RKObjectManager sharedManager].managedObjectStore.managedObjectCache;
    managedObjectRequestOperation.managedObjectContext = self.managedObjectContext;
    [[NSOperationQueue currentQueue] addOperation:managedObjectRequestOperation];
    


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    MTCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *status = [[self.fetchedResultsController objectAtIndexPath:indexPath] title];
    cell.mainLabel.text = status;
    
    
    MTFeed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://d2yrj8lu79au2z.cloudfront.net/logos/%d.png",[feed.retailerId integerValue]]]];
    
    [cell.customImageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
    [cell.customImageView setClipsToBounds:YES];
    [cell.customImageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.detailLabel.text = feed.dateValid;
    
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


@end
