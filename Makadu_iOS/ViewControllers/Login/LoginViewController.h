//
//  LoginViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/1/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SignUpViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, SignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

