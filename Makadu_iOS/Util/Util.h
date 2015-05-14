//
//  Util.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/31/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>

@interface Util : NSObject

+(CGFloat)calculateLabelHeight:(UILabel *)label;
+(CGFloat)calculateLabelHeightWithTextView:(UITextView *)textView;
+(CGFloat)calculateLabelHeightWithCell:(UITableViewCell *)cell;
+(BOOL)existConnection;

@end
