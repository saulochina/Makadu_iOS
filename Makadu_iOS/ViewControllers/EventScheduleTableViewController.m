    //
//  EventScheduleTableViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/7/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "EventScheduleTableViewController.h"
#import "DateFormatter.h"
#import "TimeFormatter.h"
#import "EventScheduleDetailViewController.h"
#import "Util.h"
#import "AddQuestionViewController.h"
#import "Analitcs.h"
#import "Schedule.h"
#import "Messages.h"
#import "Talk.h"
#import "Cloud.h"

@interface EventScheduleTableViewController ()

@property (nonatomic, strong) NSArray * lectures;
@property (nonatomic) CGFloat resultHeight;
@property (nonatomic, strong) PFObject * object;
@property (nonatomic, strong) NSMutableArray *objectsLoad;
@property (nonatomic, strong) NSIndexPath *btnIndexPath;

@end

@implementation EventScheduleTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Talks";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
//        self.objectsPerPage = 15;
        self.showEventDetail = (ShowEventDetailViewController *)self.tabBarController;
        self.lectures = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showEventDetail.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    self.objectsLoad = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.topItem.title = @"Palestras";
}

-(void)viewWillAppear:(BOOL)animated {
    self.btnIndexPath = nil;
    
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Palestras" description:@"O usuário acessou a lista de palestras" event:self.showEventDetail.object];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Mark - Parse Query
-(PFQuery *)queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"event" equalTo:self.showEventDetail.object];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query setMaxCacheAge:1800];
    [query orderByAscending:@"start_hour"];
    return query;
}

#pragma Mark - Load Objects

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSMutableArray *resultArray = [NSMutableArray new];
    NSArray *groups = [self.objects valueForKeyPath:@"@distinctUnionOfObjects.date"];
    
    for (NSString *groupId in groups) {
        NSMutableDictionary *entry = [NSMutableDictionary new];
        [entry setObject:groupId forKey:@"date"];

        NSArray *groupNames = [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date = %@", groupId]];
        
        for (int i = 0; i < groupNames.count; i++)
        {
            NSString *titulo = [[groupNames objectAtIndex:i] objectForKey:@"title"];
            NSString *startHour = [[groupNames objectAtIndex:i] objectForKey:@"start_hour"];
            NSString *endHour = [[groupNames objectAtIndex:i] objectForKey:@"end_hour"];
            NSString *local = [[groupNames objectAtIndex:i] objectForKey:@"local"];
            NSString *description = [[groupNames objectAtIndex:i] objectForKey:@"description"];
            PFObject * pfObject = [groupNames objectAtIndex:i];
            
            PFRelation *relation = [[groupNames objectAtIndex:i] relationForKey:@"speakers"];
            PFQuery *query = [relation query];
            
            
            [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
            [query setMaxCacheAge:1800];
            [query orderByAscending:@"date_talk"];
            
            NSArray * speakers = [query findObjects];
            
            NSString *duration;
            if (local != nil)
                duration = [NSString stringWithFormat:@"%@ - %@ às %@", local, startHour, endHour];
            else
                duration = [NSString stringWithFormat:@"%@ às %@", startHour, endHour];
            
            NSMutableArray *obj = [[NSMutableArray alloc] initWithObjects:titulo, startHour, endHour, duration, speakers, description, pfObject, nil];

            [entry setObject:obj forKey:[NSString stringWithFormat:@"obj%d", i]];
        }
        [resultArray addObject:entry];
    }

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    self.lectures = [resultArray sortedArrayUsingDescriptors:@[descriptor]];
    
    [self tableView:self.tableView viewForHeaderInSection:0];
    [self.tableView reloadData];
}

#pragma Mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger days = (long)[self calculateNumberOfDays];
    if ( days == 0) {
        return 1;
    }
    return days + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.lectures count] > 0) {
        return [self.lectures[section] count] -1;
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"scheduleTableCell";
    self.resultHeight = 0;
    
    id obj = [self.lectures[indexPath.section] objectForKey:[NSString stringWithFormat:@"obj%ld", (long)indexPath.row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    } else {
    
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:0.1];
        else
            cell.backgroundColor = [UIColor whiteColor];
    
        [(UILabel *)[cell viewWithTag:301] removeFromSuperview];
        [(UILabel *)[cell viewWithTag:302] removeFromSuperview];
        [(UILabel *)[cell viewWithTag:303] removeFromSuperview];
    
        UILabel *lblStartHourTalk = (UILabel *) [cell viewWithTag:300];
        lblStartHourTalk.numberOfLines = 0;
        lblStartHourTalk.lineBreakMode = NSLineBreakByWordWrapping;
        lblStartHourTalk.text = obj[1];
        [lblStartHourTalk sizeToFit];
    
        UILabel *lblTitleTalk = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 236, 21)];
        lblTitleTalk.text = obj[0];
        lblTitleTalk.numberOfLines = 0;
        lblTitleTalk.tag = 301;
        lblTitleTalk.lineBreakMode = NSLineBreakByWordWrapping;
        lblTitleTalk.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
        lblTitleTalk.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.70];
        [lblTitleTalk sizeToFit];
        [cell addSubview:lblTitleTalk];
    
        self.resultHeight = [Util calculateLabelHeight:lblTitleTalk];
    
        UILabel *lblLocalTalk = [[UILabel alloc] initWithFrame:CGRectMake(lblStartHourTalk.frame.origin.x, [Util calculateLabelHeight:lblTitleTalk] + 26, 290, 21)];
        if ([obj count] > 2){
            lblLocalTalk.text = obj[3];
            lblLocalTalk.numberOfLines = 0;
            lblLocalTalk.tag = 302;
            lblLocalTalk.lineBreakMode = NSLineBreakByWordWrapping;
            lblLocalTalk.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            lblLocalTalk.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.70];
            [lblLocalTalk sizeToFit];
            [cell addSubview:lblLocalTalk];
    
            self.resultHeight += [Util calculateLabelHeight:lblLocalTalk];
        
            if ([Util calculateLabelHeight:lblLocalTalk] / 13 < 2) {
                self.resultHeight += 26;
            }
        }
        if ([obj[4] count] > 0) {
        
            UILabel *lblSpeakerTalk = [[UILabel alloc] initWithFrame:CGRectMake(lblStartHourTalk.frame.origin.x, [Util calculateLabelHeight:lblLocalTalk] + lblLocalTalk.frame.origin.y + 10, 290, 21)];
            lblSpeakerTalk.text = [self showSpeakers:obj[4]];
            lblSpeakerTalk.numberOfLines = 0;
            lblSpeakerTalk.tag = 303;
            lblSpeakerTalk.lineBreakMode = NSLineBreakByWordWrapping;
            lblSpeakerTalk.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
            lblSpeakerTalk.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.70];
            [lblSpeakerTalk sizeToFit];
            self.resultHeight += [Util calculateLabelHeight:lblSpeakerTalk];
            [cell addSubview:lblSpeakerTalk];
        }
        
        UIButton * btnQuestion = (UIButton *)[cell viewWithTag:200];
        [btnQuestion setHidden:NO];
        
        UIButton * btnDownload = (UIButton *)[cell viewWithTag:100];
        [btnDownload setHidden:NO];
        
        if (![[obj[6] objectForKey:@"allow_question"] boolValue]) {
            [btnQuestion setHidden:YES];
        }
        
        if (![[obj[6] objectForKey:@"allow_file"] boolValue]) {
            [btnDownload setHidden:YES];
        }
        
        if (![[obj[6] objectForKey:@"allow_question"] boolValue] && ![[obj[6] objectForKey:@"allow_file"] boolValue]) {
            self.resultHeight -= 50;
        }
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] init];
    
    if ([self.lectures count] > 0) {
        
        UILabel * lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 20)];
        
        lblHeader.text = [DateFormatter formateDateBrazilian:[self.lectures[section] objectForKey:@"date"] withZone:NO];
        lblHeader.textColor = [UIColor whiteColor];
        lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
        lblHeader.textAlignment = NSTextAlignmentCenter;
        [header addSubview:lblHeader];
        
        header.backgroundColor = [UIColor colorWithRed:(33.0/255.0) green:(145.0/255.0) blue:(114.0/255.0) alpha:1];
    }
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.lectures[indexPath.section] objectForKey:[NSString stringWithFormat:@"obj%ld", (long)indexPath.row]];
    
    if ([obj[4] count] > 0) {
        if (![[obj[6] objectForKey:@"allow_question"] boolValue] && ![[obj[6] objectForKey:@"allow_file"] boolValue]) {
            return self.resultHeight;
        }
        return self.resultHeight + 50;
    } else if ([obj[4] count] == 0) {
        if (![[obj[6] objectForKey:@"allow_question"] boolValue] && ![[obj[6] objectForKey:@"allow_file"] boolValue]) {
            return self.resultHeight + 65;
        }
        return self.resultHeight + 40;
    }
    else
        return self.resultHeight + 65;
}

#pragma Mark - Others Methods

-(NSString *)showSpeakers:(NSArray *)aSpeakers
{
    NSMutableString *speakers = [NSMutableString new];
    
    for (PFObject * speaker in aSpeakers) {
        [speakers appendString:[NSString stringWithFormat:@" - %@", speaker[@"full_name"]]];
    }
    return speakers;
}

-(NSInteger)calculateNumberOfDays
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:[_showEventDetail.object objectForKey:@"start_date"]
                                                          toDate:[_showEventDetail.object objectForKey:@"end_date"]
                                                         options:0];
    
    if ([self.lectures count] >= [components day]) {
        return [components day];
    } else {
        return 1;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"talkDetail"]) {
        NSIndexPath *indexPath;
        if (self.btnIndexPath != nil) {
            indexPath = self.btnIndexPath;
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        
        EventScheduleDetailViewController *eventDetail = [segue destinationViewController];
        
        NSArray * object = [self.lectures[indexPath.section] objectForKey:[NSString stringWithFormat:@"obj%ld", (long)indexPath.row]];
        [eventDetail setObject:object];
        [eventDetail setEvent:self.showEventDetail.object];
        
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Lista de Palestras" description:@"O usuário clicou em uma palestra" event:self.showEventDetail.object talk:object[6]];
        
    } else if ([segue.identifier isEqualToString:@"questionSegue"]) {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        AddQuestionViewController *addQuestionViewController = [segue destinationViewController];
        self.btnIndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        NSArray * object = [self.lectures[self.btnIndexPath.section] objectForKey:[NSString stringWithFormat:@"obj%ld", (long)self.btnIndexPath.row]];
        [addQuestionViewController setObject:object];
        [addQuestionViewController setEvent:self.showEventDetail.object];
        
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Lista de Palestras" description:@"O usuário clicou em Perguntar" event:self.showEventDetail.object talk:object[6]];
    }
}

- (IBAction)tapQuestion:(id)sender {
    if ([Util existConnection]) {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        self.btnIndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
        [self performSegueWithIdentifier:@"questionSegue" sender:sender];
        [self performSegueWithIdentifier:@"talkDetail" sender:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Sem internet no momento, tente novamente mais tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)tapDownload:(id)sender {
    
    if([Util existConnection]) {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        self.btnIndexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        NSArray * object = [self.lectures[self.btnIndexPath.section] objectForKey:[NSString stringWithFormat:@"obj%ld", (long)self.btnIndexPath.row]];
    
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Lista de Palestras" description:@"O usuário clicou em Download" event:self.showEventDetail.object talk:object[6]];
    
        if ([Talk existFile:object[6]]) {
            NSString * urlFile = [Talk getUrlFile:object[6]];
            [Cloud sendMail:[[PFUser currentUser] email] url:urlFile talkName:object[0]];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Em breve você receberá um e-mail com o link para realizar o dowload do material." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [Schedule saveDataScheduleWithUser:[PFUser currentUser] talk:object[6]];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Sem internet no momento, tente novamente mais tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
