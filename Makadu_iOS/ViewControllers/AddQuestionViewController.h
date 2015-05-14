//
//  AddQuestionViewController.h
//  Makadu_iOS
//
//  Created by Marcio Habigzang Brufatto on 3/31/15.
//  Copyright (c) 2015 Makadu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class AddQuestionViewController;

@protocol AddQuestionViewControllerDelegate <NSObject>

@required

-(void)updateShowQuestions;

@end


@interface AddQuestionViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id <AddQuestionViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray * object;
@property (strong, nonatomic) PFObject * event;

@end
