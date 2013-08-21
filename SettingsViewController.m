//
//  SettingsViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "SettingsViewController.h"
#import "GlobalPool.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.title = @"Settings";
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 4;
    }else if(section == 3){
        return 1;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Account";
    }else if(section == 1){
        return @"Contacts";
    }else if(section == 2){
        return @"General";
    }else if(section == 3){
        return @"Privacy Policy & Terms";
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        for (UIView *vw in [cell.contentView subviews]){
            [vw removeFromSuperview];
        }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Username"];
            
            UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [lblDetail setBackgroundColor:[UIColor clearColor]];
            [lblDetail setText:[GlobalPool sharedInstance].username];
            [cell.contentView addSubview:lblDetail];
            
        }else if(indexPath.row == 1){
            [cell.textLabel setText:@"Email"];
            
            UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [lblDetail setBackgroundColor:[UIColor clearColor]];
            [lblDetail setText:[GlobalPool sharedInstance].email];
            [cell.contentView addSubview:lblDetail];
            
        }else if(indexPath.row == 2){
            [cell.textLabel setText:@"Phone Number"];
            
            UILabel *lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [lblDetail setBackgroundColor:[UIColor clearColor]];
            [lblDetail setText:[GlobalPool sharedInstance].phone];
            [cell.contentView addSubview:lblDetail];
            
        }else if(indexPath.row == 3){
            
        }else if(indexPath.row == 4){
            [cell.textLabel setText:@"Log Out"];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Manage Blocks"];
            
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else if(indexPath.row == 1){
            [cell.textLabel setText:@"Can send files"];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Notifications"];
            
            UISwitch *btnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [cell.contentView addSubview:btnSwitch];
            
        }else if(indexPath.row == 1){
            [cell.textLabel setText:@"Vibration"];
            
            UISwitch *btnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [cell.contentView addSubview:btnSwitch];
        }else if(indexPath.row == 2){
            [cell.textLabel setText:@"Sounds"];
            
            UISwitch *btnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
            [cell.contentView addSubview:btnSwitch];

        }else if(indexPath.row == 3){
            [cell.textLabel setText:@"Remove Ads"];
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Privacy policy & Terms"];
        }
    }

    return cell;
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
