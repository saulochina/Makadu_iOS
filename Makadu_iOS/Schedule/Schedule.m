//
//  Schedule.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 4/13/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

+(void)saveDataScheduleWithUser:(PFUser *)user talk:(PFObject *)talk {
    
    PFObject * schedule = [PFObject objectWithClassName:@"Schedule"];
    schedule[@"user"] = user;
    schedule[@"talk"] = talk;
    [schedule saveInBackground];
}

@end
