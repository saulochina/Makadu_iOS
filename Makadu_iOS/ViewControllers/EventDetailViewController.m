//
//  EventDetailViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/2/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "EventDetailViewController.h"
#import "DateFormatter.h"
#import "Messages.h"
#import "Analitcs.h"
#import "Util.h"

@interface EventDetailViewController ()

@property (nonatomic, strong) PFObject *object;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showEventDetail = (ShowEventDetailViewController *)self.tabBarController;
    self.object = self.showEventDetail.object;
    
    self.eventName.text = [self.object objectForKey:@"event_name"];
    self.eventLocal.text = [NSString stringWithFormat:@"%@ - %@", [self.object objectForKey:@"local"], [self.object objectForKey:@"address"]];
    
    self.eventDate.text = [NSString stringWithFormat:@"%@ à %@", [DateFormatter formateDateBrazilian:[self.object objectForKey:@"start_date"] withZone:YES], [DateFormatter formateDateBrazilian:[self.object objectForKey:@"end_date"] withZone:YES]];
    
    self.eventDescription.text = [self.object objectForKey:@"event_description"];
    
    [self loadImageEvent:[self.object objectForKey:@"logo"]];
 }

-(void)viewWillAppear:(BOOL)animated {
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Detalhes do evento" description:@"Usuário acessou os detalhes do evento" event:self.object];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadImageEvent:(PFFile *)image
{
    [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.eventLogo.image = [UIImage imageWithData:data];
        }
        else {
            self.eventLogo.image = [UIImage imageNamed:@"makadu.png"];
        }
    }];
}

-(void)selectSchedule {
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Detalhes do evento" description:@"O usuário clicou em programação." event:self.object];
    [self.tabBarController setSelectedIndex:1];
}


@end
