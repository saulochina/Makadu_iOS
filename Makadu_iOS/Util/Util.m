//
//  Util.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/31/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "Util.h"

@implementation Util

+(CGFloat)calculateLabelHeight:(UILabel *)label {
    
    NSString *text = label.text;
    CGFloat width = label.frame.size.width;
    UIFont *font = label.font;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    return size.height;
}

+(CGFloat)calculateLabelHeightWithTextView:(UITextView *)textView {
    
    NSString *text = textView.text;
    CGFloat width = textView.frame.size.width;
    UIFont *font = textView.font;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    return size.height;
}

+(CGFloat)calculateLabelHeightWithCell:(UITableViewCell *)cell {
    
    NSString *text = cell.textLabel.text;
    CGFloat width = cell.textLabel.frame.size.width;
    UIFont *font = cell.textLabel.font;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    return size.height;
}

+(BOOL)existConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

@end
