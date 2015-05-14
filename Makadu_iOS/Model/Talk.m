//
//  Talk.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 4/15/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "Talk.h"

@implementation Talk

+(BOOL)existFile:(PFObject *)talk {
    
    if ([talk objectForKey:@"file"]) {
        return YES;
    }
    return NO;
}

+(NSString *)getUrlFile:(PFObject *)talk {
    
    PFFile * file = [talk objectForKey:@"file"];
    return file.url;
}

@end
