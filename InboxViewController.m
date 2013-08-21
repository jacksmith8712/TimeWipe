//
//  InboxViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "InboxViewController.h"
#import "RequestHelper.h"
#import "Constants.h"
#import "GlobalPool.h"
#import "NSString+SBJSON.h"
#import "MessageViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

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
    
    self.title = @"Inbox";
//    [self.navigationController setNavigationBarHidden:NO];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tblView];
    [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshInbox];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshInbox{
    [RequestHelper sendRequestOfGetInbox:self username:[GlobalPool sharedInstance].username];
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    //    double delayInSeconds = 3.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        [refreshControl endRefreshing];
    //    });
    [self refreshInbox];
}
#pragma mark - UITableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_messages count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dict = [_messages objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dict objectForKey:@"fromUser"]];
    
    if ([[dict objectForKey:@"blobType"] isEqualToString:@"Text"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"text_icon"]];
    }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Audio"]){
        [cell.imageView setImage:[UIImage imageNamed:@"audio_icon"]];
    }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Photo"]){
        [cell.imageView setImage:[UIImage imageNamed:@"photo_icon"]];
    }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Video"]){
        [cell.imageView setImage:[UIImage imageNamed:@"video_icon"]];
    }
    
    NSDate *sentDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"timestamp"] doubleValue]];
    NSDate *now = [NSDate date];
    long diff = [now timeIntervalSinceDate:sentDate];
    
    NSLog(@"%ld",diff);
    if (diff < 60) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld seconds ago",diff]];
    }else if(diff < 3600){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld minutes ago",diff/60]];
    }else if(diff < 86400){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld hrs ago",diff/3600]];
    }else if(diff < 2592000){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld days ago",diff/864000]];
    }else{
        [cell.detailTextLabel setText:@"a few months ago"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_messages objectAtIndex:indexPath.row];
    
    MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [messageViewController setMessage:dict];
    
    [self.navigationController pushViewController:messageViewController animated:YES];
}
#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFail:(JBRequest *)req{
    [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Unable to connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
-(void)requestExecutionDidFinish:(JBRequest *)req{
    NSDictionary *dict = [req.responseString JSONValue];
    NSLog(@"%@",dict);
    if([[dict objectForKey:@"success"] isEqualToString:@"YES"]){
        if (req.tag == TWRequestTagGetInbox) {
            NSArray *result = [dict objectForKey:@"result"];
            NSLog(@"%@",result);
            if (self.messages != nil) {
                [_messages removeAllObjects];
                [self.messages addObjectsFromArray:result];
            }else{
                self.messages = [NSMutableArray arrayWithArray:result];
            }
            
            self.title = [NSString stringWithFormat:@"Inbox(%d)",[_messages count]];
            [self.tblView reloadData];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Database error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [self.refreshControl endRefreshing];
}
- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
