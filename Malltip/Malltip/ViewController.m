//
//  ViewController.m
//  Malltip
//
//  Created by Zhang Ling on 1/23/14.
//  Copyright (c) 2014 Yuriy Plehanov. All rights reserved.
//

#import "ViewController.h"
#import "FeedCell.h"

#import "IBGlobal.h"
#import "MBProgressHUD.h"

#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize m_tblMalltip;
@synthesize m_aryMalltips;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark
#pragma mark - infrastructure
//======================================================================================================================================
- (void) initModel {
    m_aryMalltips = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void) setUpView {
    
    mProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mProgress.mode = MBProgressHUDModeIndeterminate;
    [mProgress hide: NO];
    
    [self Feed];
}

- (void) refresh {
    
}


#pragma mark
#pragma mark - Web connections
//======================================================================================================================================
- (void) Feed {
    
    [mProgress show:YES];
    
    NSURL *url = [[NSURL alloc] initWithString: URL_FEED];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL: url];
    
    [form_request setRequestMethod: @"GET"];
    
    [form_request setDidFailSelector: @selector(requestRefreshFail:)];
    [form_request setDidFinishSelector: @selector(requestRefreshFinish:)];
    
    [form_request setDelegate: self];
    [form_request startAsynchronous];
}

- (void) requestRefreshFinish: (ASIHTTPRequest *)request {
    
    NSLog(@"%@", [request responseString]);
    
    [mProgress hide:YES];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *dict = [parser objectWithString: [request responseString]];
    
    m_aryMalltips = [dict objectForKey:@"feeds"];
    [m_tblMalltip reloadData];
}

- (void) requestRefreshFail: (ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);
    
    [mProgress hide:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message: @"Service unavailable" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alertView show];
}


#pragma mark
#pragma mark - TableViewDelegate
//======================================================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_aryMalltips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil)
    {
        // Use the default cell style.
        NSArray *arrayOfViews;
        
        arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1){
            return nil;
        }
        
        FeedCell *_cell = [arrayOfViews objectAtIndex:0];
        cell = _cell;
        _cell = nil;
    }
    
    NSDictionary *_celldata = (NSDictionary *)[m_aryMalltips objectAtIndex:indexPath.row];
    
    int _id = indexPath.row;
    NSString *title = [_celldata objectForKey:@"title"];
    NSString *dateValid = [_celldata objectForKey:@"dateValid"];
    int retailerID = [[_celldata objectForKey:@"retailerId"] integerValue];
    NSString *icon = [NSString stringWithFormat:URL_ICON, retailerID];
    
    [cell setUpWithTag:_id Icon:icon Title:title DateValid:dateValid];
    
    return cell;
}

@end
