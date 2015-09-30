//
//  JHCustomerView.m
//  Malltip
//
//  Created by Jin Ming on 1/23/14.
//  Copyright (c) 2013 Jin Ming. All rights reserved.
//

#import "JHCustomerView.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AppEngine.h"
#import "JHCustomerTableViewCell.h"

@interface JHCustomerView ()

@end

@implementation JHCustomerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrMain = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void (^successed)(id _responseObject) = ^(id _responseObject) {
        // Hide ;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@", _responseObject);
        NSArray* responseArray = [_responseObject objectForKey:@"feeds"];
        for (int i = 0 ; i < [responseArray count] ; i++)
        {
            NSDictionary* dict = [responseArray objectAtIndex:i];
            [arrMain addObject:dict];
        }
        
        [tableMalltip reloadData];
    };
    
    void (^failure)(NSError * _error) = ^(NSError * _error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // Error ;
        [GlobalAppEngine showAlertView:ALERT_TIPS message:@"Internet Connection Error!"];
    };
    
    [GlobalAppEngine sendToService:successed failure:failure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMain count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"JHCustomerTableViewCell";
    
    JHCustomerTableViewCell * cell = (JHCustomerTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JHCustomerTableViewCell" owner:self options:nil];
        id firstObject =[topLevelObjects objectAtIndex:0];
        if ( [ firstObject isKindOfClass:[UITableViewCell class]] )
            cell = (JHCustomerTableViewCell*)firstObject;
    }
    NSDictionary * dict = [arrMain objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dict objectForKey:@"title"];
    cell.smallLabel.text = [dict objectForKey:@"dateValid"];
    NSString * retailerId = [dict objectForKey:@"retailerId"];
    NSString * strURL = [NSString stringWithFormat:@"https://d2yrj8lu79au2z.cloudfront.net/logos/%@.png", retailerId];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]];
    [cell.imageView setImage: image];
    NSLog(@"%f", cell.imageView.frame.size.width);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
