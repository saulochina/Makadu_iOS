//
//  ShowEventDetailViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/2/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ShowEventDetailViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) PFObject * object;

@end
