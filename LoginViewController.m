//
//  LoginViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "RequestHelper.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"
#import "GlobalPool.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actSwipe:)];
    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - General
-(BOOL)validateInput{
    if ([_txtUsername.text isEqualToString:@""] || [_txtPassword.text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

#pragma mark - Swipe Gesture Action
-(void)actSwipe:(id)sender{
    if ([self validateInput]) {
        [RequestHelper sendRequestOfLogin:self username:_txtUsername.text password:_txtPassword.text];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Please fill all required fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)actNotUser:(id)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (IBAction)actForgot:(id)sender {
    
}

#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFinish:(JBRequest *)req{
    NSDictionary *dict = [req.responseString JSONValue];
    NSLog(@"%@",dict);
    
    if ([[dict objectForKey:@"success"] isEqualToString:@"YES"]) {
        
        [GlobalPool sharedInstance].username = _txtUsername.text;
        [GlobalPool sharedInstance].password = _txtPassword.text;
        [GlobalPool sharedInstance].email = [dict objectForKey:@"email"];
        [GlobalPool sharedInstance].phone = [dict objectForKey:@"phone"];
        
        [[GlobalPool sharedInstance] saveUserInfo];
        
        ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)requestExecutionDidFail:(JBRequest *)req{
    [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Unable to connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
