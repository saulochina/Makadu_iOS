//
//  LoginViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 2/1/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "LoginViewController.h"
#import "RememberPasswordViewController.h"
#import "Messages.h"
#import "Validations.h"
#import "Analitcs.h"
#import "Cloud.h"

@interface LoginViewController ()

-(IBAction)rememberPassword:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userTextField.delegate = self;
    self.userTextField.returnKeyType = UIReturnKeyDefault;
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.returnKeyType = UIReturnKeyDefault;
    
    [self.passwordTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.userTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)hideKeyboard {
    [self.userTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[PFUser currentUser] isAuthenticated])
        [self eventAcess];
}


#pragma Mark - methods of the remember password
- (IBAction)loginTouched:(id)sender {
    
    [self executeLogin:self.userTextField.text password:self.passwordTextField.text];
    
}

-(void)executeLogin:(NSString *)userName password:(NSString *)password {
    
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"%@", user);
                                            [Analitcs saveDataAnalitcsWithUser:user typeOperation:@"Efetou" screenAccess:@"Login" description:@"O usuário efetuou login"];
                                            [self eventAcess];
                                        } else {
                                            NSLog(@"%@", error);
                                            if ([Validations usernameEmpty:self.userTextField.text]) {
                                                [Analitcs saveDataAnalitcsWithType:@"Efetou" screenAccess:@"Login" description:@"Ocorreu um erro:O campo e-mail é obrigatório!"];
                                                [Messages failMessageWithTitle:nil andMessage:@"O campo e-mail é obrigatório!"];
                                                return;
                                            }
                                            if (![Validations usernameValid:self.userTextField.text]) {
                                                [Analitcs saveDataAnalitcsWithType:@"Efetou" screenAccess:@"Login" description:@"Ocorreu um erro:E-mail é invalido"];
                                                [Messages failMessageWithTitle:nil andMessage:@"E-mail é invalido"];
                                                return;
                                            }
                                            
                                            if (![Validations verifyExistUser:self.userTextField.text]) {
                                                [Analitcs saveDataAnalitcsWithType:@"Efetou" screenAccess:@"Login" description:@"Ocorreu um erro:Usuário é inválido"];
                                                [Messages failMessageWithTitle:nil andMessage:@"Usuário ou senha não conferem."];
                                            }
                                            else {
                                                [Analitcs saveDataAnalitcsWithType:@"Efetou" screenAccess:@"Login" description:@"Ocorreu um erro:Usuário é inválido"];
                                                [Messages failMessageWithTitle:nil andMessage:@"Usuário ou senha não conferem."];
                                            }
                                        }
                                    }];
}


-(void)eventAcess {
    [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Acessou" screenAccess:@"Login" description:@"Usuário efetuou login"];
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    self.passwordTextField.text = @"";
}


-(IBAction)rememberPassword:(id)sender
{
    [Analitcs saveDataAnalitcsWithType:@"Clicou" screenAccess:@"Login" description:@"Usuário clicou em esqueci minha sanha"];
    RememberPasswordViewController * remember = [[RememberPasswordViewController alloc] initWithNibName:nil bundle:nil];
    remember.view.frame = CGRectMake(0,  0 , self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:remember];
    [self.view addSubview:remember.view];
    [remember didMoveToParentViewController:self];
}

- (IBAction)signUpTouched:(id)sender {
    
    [Analitcs saveDataAnalitcsWithType:@"Clicou" screenAccess:@"Login" description:@"Usuário clicou em esqueci minha sanha"];
    SignUpViewController * signUp = [[SignUpViewController alloc] initWithNibName:nil bundle:nil];
    signUp.delegate = self;
    signUp.view.frame = CGRectMake(0,  0 , self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:signUp];
    [self.view addSubview:signUp.view];
    [signUp didMoveToParentViewController:self];
}


-(void)accessListEvents:(NSString *)userName password:(NSString *)password {
    [self executeLogin:userName password:password];
}
@end
