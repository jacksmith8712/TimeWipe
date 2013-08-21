//
//  RegisterViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "RegisterViewController.h"
#import "ViewController.h"
#import "RequestHelper.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    if ([_txtEmail.text isEqualToString:@""] || [_txtFirst.text isEqualToString:@""]
        ||[_txtLast.text isEqualToString:@""] || [_txtPassword.text isEqualToString:@""]
        ||[_txtPhone.text isEqualToString:@""] || [_txtUsername.text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}
#pragma mark - Swipe Gesture
-(void)actSwipe:(id)sender{
    if ([self validateInput]) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",_txtFirst.text,_txtLast.text];
        [RequestHelper sendRequestOfRegister:self name:fullName username:_txtUsername.text password:_txtPassword.text email:_txtEmail.text phone:_txtPhone.text];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Please fill all required fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
- (IBAction)actAlreadyUser:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFinish:(JBRequest *)req{
    NSDictionary *dict = [req.responseString JSONValue];
    NSLog(@"%@",dict);
    if ([[dict objectForKey:@"success"] isEqualToString:@"YES"]) {
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
