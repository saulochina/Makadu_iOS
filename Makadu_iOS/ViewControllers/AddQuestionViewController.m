    //
//  AddQuestionViewController.m
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/31/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "Messages.h"
#import "Analitcs.h"
#import "Util.h"

@interface AddQuestionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

-(IBAction)cancel:(id)sender;
-(IBAction)sendQuestion:(id)sender;

@end

@implementation AddQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionTextView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    if (![Util existConnection]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)sendQuestion:(id)sender {
    
    PFObject *question = [PFObject objectWithClassName:@"Questions"];
    question[@"question"] = self.questionTextView.text;
    question[@"talk"] = self.object[6];
    question[@"questioning"] = [PFUser currentUser];
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Pergunta salva com sucesso");
            [Messages successMessageWithTitle:@"Sucesso" andMessage:@"Pergunta salva com sucesso"];
            [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Perguntou" screenAccess:@"Perguntas" description:@"O usuário realizou uma pergunta" event:self.event talk:self.object[6] question:question];
            [self.delegate updateShowQuestions];
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            NSLog(@"Ocorreu um erro ao salvar a pergunta = %@", error.localizedDescription);
            [Analitcs saveDataAnalitcsWithUser:[PFUser currentUser] typeOperation:@"Perguntou" screenAccess:@"Perguntas" description:[NSString stringWithFormat:@"Ocoreu um erro ao tentar realizar uma pergunta: %@", error.localizedDescription] event:self.event talk:self.object[6] question:question];
            [Messages failMessageWithTitle:@"Alerta" andMessage:@"Ocorreu um erro no envio de sua menssagem"];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}
@end
