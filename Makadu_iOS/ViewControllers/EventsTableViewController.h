//
//  EventsTableViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/1/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface EventsTableViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@end
