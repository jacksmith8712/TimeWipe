//
//  TextViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "TextViewController.h"
#import "SendViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

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
    self.title = @"Text";
    
//    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(actSend:)];
//    self.navigationItem.rightBarButtonItem = sendBtn;
    
//    [self.navigationController setNavigationBarHidden:NO];
    
    [self.txtView becomeFirstResponder];
    [self.txtView setText:@""];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.txtView setText:@""];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self.lblDescription setText:[NSString stringWithFormat:@"%d characters left",140-[textView.text length]]];
    return YES;
}
- (IBAction)actCancel:(id)sender {
    [self.txtView setText:@""];
    [self.txtView resignFirstResponder];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actSend:(id)sender {
    if ([self.txtView.text length] > 0) {
        SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
        [sendViewController setSourceType:@"Text"];
        [sendViewController setMsgContent:self.txtView.text];
        [self.navigationController pushViewController:sendViewController animated:YES];
    }else{
        [self.txtView resignFirstResponder];
    }

}
- (IBAction)actTimer:(id)sender {
    if (defaultPickerView == nil) {
        defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"PickerGlass.png" title:@"AFPicker"];
        defaultPickerView.dataSource = self;
        defaultPickerView.delegate = self;
        [self.view addSubview:defaultPickerView];
    }
    [defaultPickerView showPicker];
    [defaultPickerView reloadData];
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return 10;
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%i", row + 1];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
}

@end
