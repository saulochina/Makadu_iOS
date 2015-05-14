//
//  DateFormatter.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/5/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject

+(NSString *)formateDateBrazilian:(NSString *)date withZone:(BOOL)zone;
+(NSString *)formateDateOther:(NSString *)date;

@end
