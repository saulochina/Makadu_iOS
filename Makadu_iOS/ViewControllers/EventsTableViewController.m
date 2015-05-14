//
//  EventsTableViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/1/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "EventsTableViewController.h"
#import "ShowEventDetailViewController.h"
#import "EventTableViewCell.h"
#import "DateFormatter.h"
#import "Util.h"
#import "Analitcs.h"

@interface EventsTableViewController ()

@property (strong,nonatomic) NSMutableArray *filteredEventArray;
@property IBOutlet UISearchBar *eventSearchBar;

@end

@implementation EventsTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Events";
        self.textKey = @"event_name";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
//        self.objectsPerPage = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.filteredEventArray = [NSMutableArray arrayWithCapacity:[self.objects count]];
}

-(void)viewWillAppear:(BOOL)animated {
    if ([[PFUser currentUser] isAuthenticated]) {
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Eventos" description:@"O usuário acessou a tela de lista de evento"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)queryAlternative
//{
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            [self.tableView reloadData];
//        }
//        else {
//            NSLog(@"Ocorreu erro %@", error.localizedDescription);
//        }
//    }];
//    
//    [query orderByAscending:@"start_date"];
//}

#pragma mark - Table view data source
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"active" equalTo:[NSNumber numberWithBool:YES]];
    [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    [query setMaxCacheAge:1800];
    [query orderByAscending:@"start_date"];
    return query;
}

#pragma Mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredEventArray count];
    } else {
        return [self.objects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"eventTableCell";
    EventTableViewCell *cell = (EventTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    else
        cell.backgroundColor = [UIColor whiteColor];
    
    PFObject *obj = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        obj = [self.filteredEventArray objectAtIndex:indexPath.row];
    } else {
        obj = [self.objects objectAtIndex:indexPath.row];
    }
    
    NSString *startDate = [DateFormatter formateDateBrazilian:[obj objectForKey:@"start_date"] withZone:YES];
    NSString *endDate = [DateFormatter formateDateBrazilian:[obj objectForKey:@"end_date"] withZone:YES];
    
    cell.eventName.text = [obj objectForKey:@"event_name"];
    cell.eventCity.text = [obj objectForKey:@"city"];
    cell.eventDate.text = [NSString stringWithFormat:@"%@ a %@",startDate, endDate];
    
    PFFile *patronage = [obj objectForKey:@"patronage"];
    cell.eventPatronage.image = [UIImage imageNamed:@"makadu.png"];
    cell.eventPatronage.file = patronage;
    [cell.eventPatronage loadInBackground];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *currentObject = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentObject = [self.filteredEventArray objectAtIndex:indexPath.row];
    } else {
        currentObject = [self.objects objectAtIndex:indexPath.row];
    }
    
    NSString *startDate = [DateFormatter formateDateBrazilian:[currentObject objectForKey:@"start_date"] withZone:YES];
    NSString *endDate = [DateFormatter formateDateBrazilian:[currentObject objectForKey:@"end_date"] withZone:YES];
    NSString *date = [NSString stringWithFormat:@"%@ a %@",startDate, endDate];
    
    CGFloat height = [EventTableViewCell calculateCellHeightWithName:[currentObject objectForKey:@"event_name"] city:[currentObject objectForKey:@"city"] date:date width:290];
    
    return height + 52;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        NSIndexPath *indexPath = nil;
        PFObject *obj = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            obj = [self.filteredEventArray objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            obj = [self.objects objectAtIndex:indexPath.row];
        }
        
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Eventos" description:@"O usuário clicou no evento" event:obj];
        
        ShowEventDetailViewController *destViewController = [segue destinationViewController];
        [destViewController setObject:obj];
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {

    [self.filteredEventArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.event_name contains[c] %@",searchText];
    self.filteredEventArray = [NSMutableArray arrayWithArray:[self.objects filteredArrayUsingPredicate:predicate]];
    
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Buscou" screenAccess:@"Eventos" description:[NSString stringWithFormat:@"Busca ralizada pela palavra ou letra: %@", searchText]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


#pragma Mark - other methods

- (IBAction)logout:(id)sender {
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Efetuou" screenAccess:@"Eventos" description:@"O usuário saiu do sistema"];
    [PFUser logOut];
    [self dismissModalViewControllerAnimated:YES];
}

@end
