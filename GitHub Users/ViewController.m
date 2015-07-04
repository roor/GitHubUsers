//
//  ViewController.m
//  GitHub Users
//
//  Created by Artem Podustov on 3/21/14.
//  Copyright (c) 2014 OLEArt. All rights reserved.
//

#import "ViewController.h"
#import "GHUsersFetcher.h"
#import "User.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ViewController

- (id)init
{
    if (self = [super init]) {
        [self setupData];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataCatcher:) name:kFetcherDoneNotification object:nil];
        
        [self setupData];
    }
    
    return self;
}

- (void)dataCatcher:(NSNotification *)notification
{
    self.dataSource = (NSArray *)[notification object];
    
    [self.tableView reloadData];
}

- (void)setupData
{
    //load data from network
    [[GHUsersFetcher sharedInstance] loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark table delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    User *user = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:user.login];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", user.userId]];
    
    return cell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
