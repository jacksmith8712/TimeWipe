//
//  SendViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "SendViewController.h"
#import "RequestHelper.h"
#import "NSString+SBJSON.h"
#import "Constants.h"
#import "GlobalPool.h"

@interface SendViewController ()

@end

@implementation SendViewController

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
    
//    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"%@",[GlobalPool sharedInstance].contacts);
    self.contacts = [GlobalPool sharedInstance].contacts;
    self.receivers = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)generateReceiverString{
    if (_recvStr != nil) {
        [_recvStr setString:@""];
    }else{
        _recvStr = [NSMutableString string];
    }
    for (NSDictionary *dict in _receivers){
        [_recvStr appendFormat:@"%@-",[dict objectForKey:@"username"]];
    }
}
- (IBAction)actSend:(id)sender {
    if ([_receivers count] > 0) {
        [self generateReceiverString];
        if ([self.sourceType isEqualToString:@"Text"]) {
            [RequestHelper sendRequestOfUploadText:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobType:_sourceType blobText:_msgContent];
        }else if([self.sourceType isEqualToString:@"Photo"] || [self.sourceType isEqualToString:@"Video"] ){
            NSURL *path = [self.msgAsset objectForKey:@"path"];
            if ([path isFileURL]) {
                [RequestHelper sendRequestOfUploadBlob:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobType:self.sourceType blobLink:[path path]];
            }
        }else if([self.sourceType isEqualToString:@"Audio"]){
            [RequestHelper sendRequestOfUploadBlob:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobType:self.sourceType blobLink:self.msgContent];
        }else if([self.sourceType isEqualToString:@"Gallery"]){
            NSURL *path = [self.msgAsset objectForKey:@"path"];
            [RequestHelper sendRequestOfUploadBlob:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobType:self.sourceType blobLink:[path absoluteString]];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"No contact selected to send" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dict = [_contacts objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dict objectForKey:@"username"]];
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
    [lblStatus setText:[dict objectForKey:@"status"]];
    [cell.contentView addSubview:lblStatus];
    
    UIImageView *checkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 17)];
    [checkView setImage:[UIImage imageNamed:@"checkmark"]];
    cell.accessoryView = checkView;
    cell.accessoryView.hidden = YES;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = [_contacts objectAtIndex:indexPath.row];
    [_receivers addObject:dict];
    
    cell.accessoryView.hidden = NO;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = [_contacts objectAtIndex:indexPath.row];
    [_receivers removeObjectIdenticalTo:dict];
    
    cell.accessoryView.hidden = YES;
}
/***********************************************************
 *
 * JBRequest Delegate
 *
 ***********************************************************/

#pragma mark -
#pragma mark JBRequestDelegate

- (void)requestExecutionDidFinish:(JBRequest *)req
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//
    NSDictionary *dict = [req.responseString JSONValue];
    NSLog(@"%@",dict);
    if ([[dict objectForKey:@"success"] isEqualToString:@"YES"]) {
        if (req.tag == TWRequestTagUploadText)
        {
            [RequestHelper sendRequestOfSendMessage:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobID:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"blobID"] integerValue]]];
        }else if(req.tag == TWRequestTagSendMessage){
            [self.navigationController popViewControllerAnimated:YES];
        }else if(req.tag == TWRequestTagUploadBlob){
            [RequestHelper sendRequestOfSendMessage:self toUser:_recvStr fromUser:[GlobalPool sharedInstance].username blobID:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"blobID"] integerValue]]];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Connection Error!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)requestExecutionDidFail:(JBRequest *)req
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
