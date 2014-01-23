//
//  ViewController.m
//  iOSInterview
//
//  Created by MobileGenius on 1/23/14.
//
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "ItemDetail.h"
#import "UIImageView+AFNetworking.h"


#define SERVICEURL @"https://m.malltip.com/api/v1/mall/4168/feed/offset/0"

@interface ViewController () {
    NSMutableArray *m_arrayItems;
}

@property (weak, nonatomic) IBOutlet UITableView *tblViewMain;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [AppDelegate showWaitView:@"Loading"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    m_arrayItems = [[NSMutableArray alloc] init];
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:SERVICEURL]];
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray* arrayFeeds = [json objectForKey:@"feeds"];
    
    int count = [arrayFeeds count];
    for (int i=0; i<count; i++) {
        NSDictionary* feed = [arrayFeeds objectAtIndex:i];
        ItemDetail *item = [[ItemDetail alloc] init];
        item.n_feedId = [[feed valueForKey:@"feedId"] intValue];
        item.n_retailerId = [[feed valueForKey:@"retailerId"] intValue];
        item.str_title = [feed valueForKey:@"title"];
        item.str_dateValid = [feed valueForKey:@"dateValid"];
        
        [m_arrayItems addObject:item];
    }
    
    [AppDelegate hideWaitView];
    [_tblViewMain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (m_arrayItems != nil) {
        return [m_arrayItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    
    ItemDetail *item = [m_arrayItems objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.str_title;
    cell.lblDateValid.text = item.str_title;
    
    NSString *imgURL = [NSString stringWithFormat:@"https://d2yrj8lu79au2z.cloudfront.net/logos/%d.png", item.n_retailerId];
    [cell.imgViewLogo setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    return cell;
}
@end
