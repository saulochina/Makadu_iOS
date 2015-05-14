//
//  RememberPasswordViewController.m
//  Makadu
//
//  Created by Marcio Habigzang Brufatto on 1/26/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "RememberPasswordViewController.h"
#import "Messages.h"
#import "Validations.h"
#import "Analitcs.h"
#import "Validations.h"

@interface RememberPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

-(IBAction)cancel:(id)sender;
-(IBAction)sendEmailToRememberPassword:(id)sender;

@end

@implementation RememberPasswordViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RememberPasswordViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.delegate = self;
    self.usernameTextField.returnKeyType = UIReturnKeyDefault;
    [self.usernameTextField addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)hideKeyboard {
    [self.usernameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)cancel:(id)sender {
    [Analitcs saveDataAnalitcsWithType:@"Clicou em cancelar" screenAccess:@"Relembrar senha" description:@"Usuário clicou no botão para fechar a tela para relembrar a senha"];
    [self.view removeFromSuperview];
}

-(IBAction)sendEmailToRememberPassword:(id)sender
{
    if ([Validations usernameEmpty:self.usernameTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Clicou em enviar" screenAccess:@"Relembrar senha" description:@"Ocorreu um erro: O campo e-mail é obrigatório!"];
        [Messages failMessageWithTitle:nil andMessage:@"O campo e-mail é obrigatório!"];
        return;
    }
    if (![Validations usernameValid:self.usernameTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Clicou em enviar" screenAccess:@"Relembrar senha" description:[NSString stringWithFormat: @"Ocorreu um erro: O e-mail %@ é inválido!", self.usernameTextField.text]];
        [Messages failMessageWithTitle:nil andMessage:@"O e-mail informado é inválido!"];
        return;
    }
    if (![Validations verifyExistUser:self.usernameTextField.text]) {
        [Analitcs saveDataAnalitcsWithType:@"Clicou em enviar" screenAccess:@"Remenbrar Senha" description:[NSString stringWithFormat:@"Ocorreu um erro: E-mail %@ informado não existe!", self.usernameTextField.text]];
        [Messages failMessageWithTitle:nil andMessage:@"E-mail informado não existe!"];
        return;
    } else {
        [Analitcs saveDataAnalitcsWithType:@"Clicou em enviar" screenAccess:@"Relembrar senha" description:[NSString stringWithFormat:@"E-mail enviado para que o usuário %@ possa recuperar a sua senha", self.usernameTextField.text]];
        [PFUser requestPasswordResetForEmail:self.usernameTextField.text];
        [self.view removeFromSuperview];
        [Messages successMessageWithTitle:nil andMessage:@"Em breve você receberá uma e-mail!"];
    }
}
@end