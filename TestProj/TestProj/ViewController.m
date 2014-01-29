//
//  ViewController.m
//  TestProj
//
//  Created by Dan Kolov on 1/29/14.
//  Copyright (c) 2014 Dan Kolov. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
#import "Feed.h"
#import "AppData.h"

#import "MBProgressHUD.h"
#import "AsyncImageView.h"

@interface ViewController (){
    NSMutableArray * _feeds;
    int _offset;
    NSString *_strMallID;
}

@end

@implementation ViewController

#pragma mark - View Controller LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"Malltip", @"");
        
        _feeds = [NSMutableArray array];
        
        //Here we can change the offset and Mall ID
        _offset = 0;
        _strMallID = @"4170";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self callServiceForFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service Call
- (void)callServiceForFeed{
    [MBProgressHUD showHUDAddedTo:self.view text:NSLocalizedString(@"Loading Feeds...",@"") animated:YES];
    
    MalltipService * ssservice = [[MalltipService alloc] init];
    ssservice.delegate = self;
    [ssservice getFeedsWithMallID:_strMallID andOffset:_offset];
}

#pragma mark - MalltipService Delegate
-(void)MalltipServiceDIdGetFeeds:(NSArray *)feeds withOffset:(NSNumber *)offset{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [_feeds addObjectsFromArray:feeds];
    _offset = [offset intValue];
    NSLog(@"\nget feeds is success:");
    
    [self.tblFeed reloadData];
}


#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CustomTableCell";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Feed *feed = [_feeds objectAtIndex:indexPath.row];
    
    
    cell.lblTitle.text = feed.title;
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@.png", [AppData appData].getBaseImageUrl, feed.retailerId];
    [cell.imageIcon loadImageFromURL:[NSURL URLWithString:strURL]];
    
    cell.lblSubTitle.text = feed.dateValid;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _feeds.count - 1) {
        [self callServiceForFeed];
    }
    
}


@end
