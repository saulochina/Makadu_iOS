//
//  NoticesTableViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/4/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ShowEventDetailViewController.h"

@interface NoticesTableViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ShowEventDetailViewController * showEventDetail;

@end
