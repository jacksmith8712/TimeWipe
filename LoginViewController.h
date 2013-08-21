//
//  LoginViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,JBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnNotUser;
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
- (IBAction)actNotUser:(id)sender;
- (IBAction)actForgot:(id)sender;
@end
