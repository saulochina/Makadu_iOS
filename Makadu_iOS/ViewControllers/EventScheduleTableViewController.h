//
//  EventScheduleTableViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/7/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import "ShowEventDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Bolts/Bolts.h>

@interface EventScheduleTableViewController : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ShowEventDetailViewController * showEventDetail;

@end