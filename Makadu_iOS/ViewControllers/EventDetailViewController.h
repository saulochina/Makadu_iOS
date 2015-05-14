//
//  EventDetailViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/2/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

#import "ShowEventDetailViewController.h"

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *eventDate;
@property (strong, nonatomic) IBOutlet UILabel *eventLocal;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;

@property (strong, nonatomic) NSString * startDate;
@property (strong, nonatomic) NSString * endDate;

@property (strong, nonatomic) IBOutlet PFImageView *eventLogo;
@property (strong, nonatomic) ShowEventDetailViewController * showEventDetail;

@end
