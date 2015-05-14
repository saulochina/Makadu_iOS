//
//  NoticesTableViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/4/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "NoticesTableViewController.h"
#import "Util.h"
#import "Analitcs.h"

@interface NoticesTableViewController ()

@property (nonatomic) CGFloat resultHeight;

@end

@implementation NoticesTableViewController

@synthesize resultHeight;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Notices";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 15;
        _showEventDetail = (ShowEventDetailViewController *)self.tabBarController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showEventDetail.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Avisos" description:@"O usuário acessou os avisos"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"event" equalTo:_showEventDetail.object];
    [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    [query setMaxCacheAge:1800];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"eventTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    } else {
    
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        else
            cell.backgroundColor = [UIColor whiteColor];
    
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:200];
        nameLabel.text = [object objectForKey:@"notice"];
    
        resultHeight = [Util calculateLabelHeight:nameLabel];
    
        UILabel *descriptionLabel = (UILabel*) [cell viewWithTag:201];
        descriptionLabel.text = [object objectForKey:@"detail"];
    
        resultHeight += [Util calculateLabelHeight:descriptionLabel];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return resultHeight + 50;
}

@end
