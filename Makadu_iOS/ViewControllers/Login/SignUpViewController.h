//
//  SignUpViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 5/4/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUpViewController;

@protocol SignUpViewControllerDelegate <NSObject>

@required

-(void)accessListEvents:(NSString *)email password:(NSString *)password;

@end

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id <SignUpViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
