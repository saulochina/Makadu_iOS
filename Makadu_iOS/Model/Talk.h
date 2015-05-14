//
//  Talk.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 4/15/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Talk : NSObject

+(BOOL)existFile:(PFObject *)talk;
+(NSString *)getUrlFile:(PFObject *)talk;

@end
