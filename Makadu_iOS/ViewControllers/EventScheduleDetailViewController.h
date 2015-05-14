//
//  EventScheduleDetailViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/24/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Reachability/Reachability.h>
#import "AddQuestionViewController.h"

@interface EventScheduleDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AddQuestionViewControllerDelegate>

@property (weak, nonatomic) NSArray * object;
@property (weak, nonatomic) PFObject * event;

@end
