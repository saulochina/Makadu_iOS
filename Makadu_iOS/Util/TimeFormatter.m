//
//  TimeFormatter.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/8/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "TimeFormatter.h"

@implementation TimeFormatter

+(NSString *)timeFormatterWithoutSeconds:(NSString *)time
{
    NSString *timeStr = time;
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSDate *aTime = [dateFormat dateFromString:timeStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"HH:mm"];
    timeStr = [dateFormat stringFromDate:aTime];
    
    return timeStr;
}

@end
