//
//  SignUpViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 5/4/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "SignUpViewController.h"
#import "Messages.h"
#import "Validations.h"
#import "Analitcs.h"
#import "Cloud.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameUserTextField.delegate = self;
    self.nameUserTextField.returnKeyType = UIReturnKeyDefault;
    
    self.userTextField.delegate = self;
    self.userTextField.returnKeyType = UIReturnKeyDefault;
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.returnKeyType = UIReturnKeyDefault;
    
    [self.nameUserTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.userTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)hideKeyboard {
    [self.userTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signUpTouched:(id)sender {
    
    if ([Validations userEmailEmpty:self.userTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Efetuou" screenAccess:@"Cadastro" description:[NSString stringWithFormat:@"O usuário não preencheu o campo e-mail"]];
        [Messages failMessageWithTitle:nil andMessage:@"O campo E-Mail deve ser preenchido"];
        return;
    }
    else if ([Validations usernameEmpty:self.nameUserTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Efetuou" screenAccess:@"Cadastro" description:[NSString stringWithFormat:@"O usuário não preencheu o campo nome"]];
        [Messages failMessageWithTitle:nil andMessage:@"O campo Nome deve ser preenchido"];
        return;
    }
    else if ([Validations userPasswordEmpty:self.passwordTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Efetuou" screenAccess:@"Cadastro" description:[NSString stringWithFormat:@"O usuário não preencheu o campo password"]];
        [Messages failMessageWithTitle:nil andMessage:@"O campo Password deve ser preenchido"];
        return;
    }
    else {
        if (![Validations verifyExistUser:self.userTextField.text]) {
            [self signUp];
        } else {
            [Analitcs saveDataAnalitcsWithType:@"Efetuou" screenAccess:@"Login" description:[NSString stringWithFormat:@"O usuário %@ informou a senha errada", self.userTextField.text]];
            [Messages failMessageWithTitle:nil andMessage:@"Usuário ou senha incorreta!"];
        }
    }
}

-(void)signUp {
    
    PFUser *user = [PFUser user];
    user.username = self.nameUserTextField.text;
    user.email = self.userTextField.text;
    user.password = self.passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"%@", user);
            [Analitcs saveDataAnalitcsWithUser:user typeOperation:@"Cadastrou" screenAccess:@"Login" description:@"Usuário realizou o cadastro"];
            [self.delegate accessListEvents:self.nameUserTextField.text password:self.passwordTextField.text];
            [self.view removeFromSuperview];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            [Analitcs saveDataAnalitcsWithUser:user typeOperation:@"Cadastrou" screenAccess:@"Login" description:[NSString stringWithFormat:@"Ocorreu um erro: %@", errorString]];
            self.passwordTextField.text = @"";
            [Messages failMessageWithTitle:@"Alerta" andMessage:@"Usuário ou senha inválido"];
        }
    }];
}

- (IBAction)loginTouched:(id)sender {
    [self.view removeFromSuperview];
}
@end
