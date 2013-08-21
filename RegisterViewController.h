//
//  RegisterViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,JBRequestDelegate>

- (IBAction)actAlreadyUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAlreadyUser;


@property (weak, nonatomic) IBOutlet UITextField *txtFirst;
@property (weak, nonatomic) IBOutlet UITextField *txtLast;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@end
