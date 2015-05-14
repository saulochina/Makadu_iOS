//
//  EventScheduleDetailViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/24/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "EventScheduleDetailViewController.h"
#import "Util.h"
#import "Analitcs.h"
#import "Schedule.h"
#import "Cloud.h"
#import "Talk.h"

@interface EventScheduleDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray * questions;
@property (strong, nonatomic) NSArray * speakers;

@end

@implementation EventScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.questions = [self getQuestions:self.object[6]];
    self.speakers = [self getSpeakers];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.topItem.title = @"Palestras";
    self.navigationItem.title = [self.object objectAtIndex:0];
    
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Detalhes da palestra" description:@"O usuário acessou os detalhes da palestra." event:self.event talk:self.object[6]];
}

#pragma Mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if (section == 0) {
        BOOL existOptionFile = YES;
        BOOL existOptionQuestion = YES;
        
        if (![[self.object[6] objectForKey:@"allow_file"] boolValue]) {
            UIButton *btnDownload = (UIButton *)[self.view viewWithTag:100];
            [btnDownload removeFromSuperview];
            existOptionFile = NO;
        }
        
        if (![[self.object[6] objectForKey:@"allow_question"] boolValue]) {
            UIButton *btnQuestion = (UIButton *)[self.view viewWithTag:200];
            [btnQuestion removeFromSuperview];
            existOptionQuestion = NO;
        }
        
        if (existOptionQuestion || existOptionFile)
            return 1;
        return 0;
    }
    else if ( section == 1) {
        return 1;
    } else if (section == 2) {
        return [self.speakers count];
    } else {
        return self.questions.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * scheduleDetailTableCell = @"scheduleOptionTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleDetailTableCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scheduleDetailTableCell];
        }
        
        if (![[self.object[6] objectForKey:@"allow_file"] boolValue]) {
            UIButton *btnDownload = (UIButton *)[cell viewWithTag:100];
            [btnDownload removeFromSuperview];
        }
        
        if (![[self.object[6] objectForKey:@"allow_question"] boolValue]) {
            UIButton *btnQuestion = (UIButton *)[cell viewWithTag:200];
            [btnQuestion removeFromSuperview];
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString * scheduleDetailTableCell = @"scheduleDetailTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleDetailTableCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scheduleDetailTableCell];
        }
        
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:0.1];
        else
            cell.backgroundColor = [UIColor whiteColor];
            
        UITextView * textView = (UITextView *)[cell viewWithTag:600];
        textView.text = self.object[5];
        
        return cell;
    }
    if (indexPath.section == 2) {
        static NSString * scheduleDetailTableCell = @"speakerTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleDetailTableCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scheduleDetailTableCell];
        }
        
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:0.1];
        else
            cell.backgroundColor = [UIColor whiteColor];

        UITextView * aboutSpeaker = (UITextView *)[cell viewWithTag:2001];
        aboutSpeaker.text = [self.speakers[indexPath.row] objectForKey:@"about_speaker"];
        
        UILabel * speakerName = (UILabel *)[cell viewWithTag:2000];
        speakerName.text = [self.speakers[indexPath.row] objectForKey:@"full_name"];

        return cell;
    }
    if (indexPath.section == 3) {
        static NSString *scheduleDetailTableCell1 = @"scheduleQuestionTableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleDetailTableCell1];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:scheduleDetailTableCell1];
        } else {
            
            if(indexPath.row % 2 == 0)
                cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:0.1];
            else
                cell.backgroundColor = [UIColor whiteColor];
            
            cell.textLabel.text = [self.questions[indexPath.row] objectForKey:@"question"];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:13.0f];
        }
        return cell;
    }
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] init];
    UILabel * lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width, 20)];
    lblHeader.textColor = [UIColor whiteColor];
    
    if (section == 0) {
        if ([[self.object[6] objectForKey:@"allow_file"] boolValue] || [[self.object[6] objectForKey:@"allow_question"] boolValue]) {
            lblHeader.text = @"Opções";
        }
    } else if (section == 1) {
        lblHeader.text = @"Sobre a Palestra";
    } else if (section == 2) {
        lblHeader.text = @"Sobre os Palestrantes";
    } else {
        lblHeader.text = @"Perguntas";
    }
        
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    lblHeader.textAlignment = NSTextAlignmentCenter;
    [header addSubview:lblHeader];
    
    header.backgroundColor = [UIColor colorWithRed:(33.0/255.0) green:(145.0/255.0) blue:(114.0/255.0) alpha:1];
    
    [header addSubview:lblHeader];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (![[self.object[6] objectForKey:@"allow_file"] boolValue] && ![[self.object[6] objectForKey:@"allow_question"] boolValue]) {
            return 0;
        }
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        return 44;
    } else if(indexPath.section == 1) {
        UITextView * textView = (UITextView *)[cell viewWithTag:600];
        return [Util calculateLabelHeightWithTextView:textView] + 44;
    } else if (indexPath.section == 2) {
        return 139;
    } else {
        return [Util calculateLabelHeightWithCell:cell] + 44;
    }
}

#pragma Mark - Others Methods
-(NSArray *)getSpeakers {
    
    NSMutableArray * speakers = [NSMutableArray new];
    for (PFObject * speaker in self.object[4]) {
        [speakers addObject:speaker];
    }
    
    return speakers;
}

-(NSArray *)getQuestions:(PFObject *)talkId {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query setMaxCacheAge:1800];
    [query whereKey:@"talk" equalTo:talkId];
    return [query findObjects];
}

-(void)updateShowQuestions {
    self.questions = [self getQuestions:self.object[6]];
    [self.tableView reloadData];
}

- (IBAction)tapDownload:(id)sender {
    
    if ([Util existConnection]) {
    
        [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Detalhes da palestra" description:@"O usuário clicou em download" event:self.event talk:self.object[6]];
    
        if ([Talk existFile:self.object[6]]) {
            NSString * urlFile = [Talk getUrlFile:self.object[6]];
            [Cloud sendMail:[[PFUser currentUser] email] url:urlFile talkName:self.object[6]];
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Em breve você receberá um e-mail com o link para realizar o dowload do material." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
            [Schedule saveDataScheduleWithUser:[PFUser currentUser] talk:self.object[6]];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Sem internet no momento, tente novamente mais tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([Util existConnection]) {
        if ([segue.identifier isEqualToString:@"questionSegue"]) {
            AddQuestionViewController *addQuestionViewController = [segue destinationViewController];
            addQuestionViewController.delegate = self;
            [addQuestionViewController setObject:self.object];
            [addQuestionViewController setEvent:self.event];
        
            [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Clicou" screenAccess:@"Detalhes da palestra" description:@"O usuário clicou em perguntar" event:self.event talk:self.object[6]];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Sem internet no momento, tente novamente mais tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
