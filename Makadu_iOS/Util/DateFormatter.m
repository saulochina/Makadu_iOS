//
//  DateFormatter.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/5/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+(NSString *)formateDateBrazilian:(NSString *)date withZone:(BOOL)zone
{
    NSString *dateStr = [NSString stringWithFormat:@"%@", date];

    // Convert string to date object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = zone ? @"yyyy-MM-dd HH:mm:ss +0000" : @"yyyy-MM-dd";
    
    [dateFormatter setDateFormat:dateFormat];
    NSDate *aDate = [dateFormatter dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    dateStr = [dateFormatter stringFromDate:aDate];
    
    return dateStr;
}

+(NSString *)formateDateOther:(NSString *)date
{
    NSString *dateStr = date;
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy"];
    NSDate *aDate = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    dateStr = [dateFormat stringFromDate:aDate];
    
    return dateStr;
}

@end
