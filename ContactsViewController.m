//
//  ContactsViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "ContactsViewController.h"
#import "NSString+SBJSON.h"
#import "RequestHelper.h"
#import "MBProgressHUD.h"
#import "GlobalPool.h"
#import "Constants.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    self.title = @"Contacts";
//    [self.navigationController setNavigationBarHidden:NO];
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(actSync:)];
    self.navigationItem.rightBarButtonItem = sendBtn;

    if ([GlobalPool sharedInstance].contacts != NULL) {
        self.contacts = [NSMutableArray arrayWithArray:[GlobalPool sharedInstance].contacts];
    }else{
        self.contacts = [NSMutableArray array];
    }
    
    [self actSync:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions
-(void)actAcceptRequst:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSDictionary *dict = [_contacts objectAtIndex:(btn.tag - 600)];
    [RequestHelper sendRequestOfAcceptFriend:self toUser:[dict objectForKey:@"fromUserID"] fromUser:[GlobalPool sharedInstance].username];
}
-(void)actDeclineRequest:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSDictionary *dict = [_contacts objectAtIndex:(btn.tag - 700)];
    [RequestHelper sendRequestOfDeclineFriend:self toUser:[dict objectForKey:@"fromUserID"] fromUser:[GlobalPool sharedInstance].username];
}
#pragma mark - UITableViewDelegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tblView) {
        return 1;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tblView) {
        return [_contacts count];
    }else{
        return [self.filteredListContent count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 44)];
    
    if (tableView == self.tblView) {
        NSDictionary *dict = [_contacts objectAtIndex:indexPath.row];
        NSLog(@"%@",dict);
        if ([[dict objectForKey:@"username"] isEqualToString:[GlobalPool sharedInstance].username]) {
            if([[dict objectForKey:@"status"] isEqualToString:@"pending"]){
                [cell.textLabel setText:[dict objectForKey:@"fromUserID"]];
                
                UIButton *btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 30, 44)];
                [btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
                [btnAccept setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
                [btnAccept addTarget:self action:@selector(actAcceptRequst:) forControlEvents:UIControlEventTouchUpInside];
                [btnAccept setTag:(600 + indexPath.row)];
                
                UIButton *btnDecline = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 30, 44)];
                [btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
                [btnDecline setImage:[UIImage imageNamed:@"block"] forState:UIControlStateNormal];
                [btnDecline addTarget:self action:@selector(actDeclineRequest:) forControlEvents:UIControlEventTouchUpInside];
                [btnDecline setTag:(700 + indexPath.row)];
                
                [cell.contentView addSubview:btnAccept];
                [cell.contentView addSubview:btnDecline];
            }else{
                [cell.textLabel setText:[dict objectForKey:@"fromUserID"]];
                [lblStatus setText:[dict objectForKey:@"status"]];
            }
        }else{
            [cell.textLabel setText:[dict objectForKey:@"username"]];
            [lblStatus setText:[dict objectForKey:@"status"]];
        }
    }else{
        NSDictionary *dict = [_filteredListContent objectAtIndex:indexPath.row];
        [cell.textLabel setText:[dict objectForKey:@"username"]];
        [lblStatus setText:[dict objectForKey:@"status"]];
    }
    
    [cell.contentView addSubview:lblStatus];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet;
    if (tableView == self.tblView) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Manage Contacts" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to Favourite",@"Block Friend", nil];
        [actionSheet setTag:2001];
        self.currentContact = [_contacts objectAtIndex:indexPath.row];
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Manage Contacts" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Request Friend",@"Block Contact", nil] ;
        [actionSheet setTag:2002];
        self.currentContact = [_filteredListContent objectAtIndex:indexPath.row];
    }
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 2001) {
        if (buttonIndex == 0) {
            
        }else if(buttonIndex == 1){
            [RequestHelper sendRequestOfBlockFriend:self toUser:[_currentContact objectForKey:@"username"]  fromUser:[GlobalPool sharedInstance].username];
        }
    }else if(actionSheet.tag == 2002){
        if (buttonIndex == 0) {
            [RequestHelper sendRequestOfRequestFriend:self toUser:[_currentContact objectForKey:@"username"] fromUser:[GlobalPool sharedInstance].username];
        }else if(buttonIndex == 1){
            [RequestHelper sendRequestOfBlockFriend:self toUser:[_currentContact objectForKey:@"username"] fromUser:[GlobalPool sharedInstance].username];
        }
    }
}
#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[_filteredListContent removeAllObjects];
    for (NSDictionary *dict in self.contacts) {
        {
            NSComparisonResult result = [[dict objectForKey:@"username"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];

            if (result == NSOrderedSame)
            {
                [_filteredListContent addObject:dict];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
#pragma mark - UISearchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [RequestHelper sendRequestOfSearchContacts:self searchKey:searchBar.text username:[GlobalPool sharedInstance].username];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchedResult removeAllObjects];
    
    [self.tblView reloadData];
}
#pragma mark - Actions
-(void)actSync:(id)sender{
    NSLog(@"%@",[GlobalPool sharedInstance].username);
    [RequestHelper sendRequestOfGetContacts:self username:[GlobalPool sharedInstance].username];
    [MBProgressHUD showHUDAddedTo:self.view text:@"Synchronizing contacts" animated:YES];
}
#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFinish:(JBRequest *)req{
    NSDictionary *dict = [req.responseString JSONValue];
    NSLog(@"%@",dict);
    if ([[dict objectForKey:@"success"] isEqualToString:@"YES"]) {
        if (req.tag == TWRequestTagGetContacts) {
            NSArray *result = [dict objectForKey:@"result"];
            if (result != NULL) {
                if (self.contacts != NULL) {
                    [self.contacts removeAllObjects];
                    [self.contacts addObjectsFromArray:result];
                }else{
                    self.contacts = [NSMutableArray arrayWithArray:result];
                }
                if ([GlobalPool sharedInstance].contacts != NULL) {
                    [[GlobalPool sharedInstance].contacts removeAllObjects];
                }else{
                    [GlobalPool sharedInstance].contacts = [NSMutableArray array];
                }
                [[GlobalPool sharedInstance].contacts addObjectsFromArray:_contacts];
                
                [[GlobalPool sharedInstance] saveContactsInfo];
                
                [self.tblView reloadData];
                
            }else{
                [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"You have no contacts, search or invite your friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }else if(req.tag == TWRequestTagSearchContacts){
            NSArray *contacts = [dict objectForKey:@"result"];
//            if (self.searchedResult != nil) {
//                [self.searchedResult removeAllObjects];
//                [self.searchedResult addObjectsFromArray:contacts];
//            }else{
//                self.searchedResult = [NSMutableArray arrayWithArray:contacts];
//            }
            if (self.filteredListContent != nil) {
                [self.filteredListContent removeAllObjects];
                [self.filteredListContent addObjectsFromArray:contacts];
            }else{
                self.filteredListContent = [NSMutableArray arrayWithArray:contacts];
            }
            [self.searchController.searchResultsTableView reloadData];
        }else if(req.tag == TWRequestTagRequestFriend){
            NSString *username = [dict objectForKey:@"username"];
            NSString *fromuser = [dict objectForKey:@"fromUserID"];
            NSDictionary *newContact = [NSDictionary dictionaryWithObjectsAndKeys:fromuser,@"fromuser",username,@"username",@"pending",@"status", nil];
            [_contacts addObject:newContact];
            if ([GlobalPool sharedInstance].contacts != NULL) {
                [[GlobalPool sharedInstance].contacts removeAllObjects];
            }else{
                [GlobalPool sharedInstance].contacts = [NSMutableArray array];
            }
            [[GlobalPool sharedInstance].contacts addObjectsFromArray:_contacts];
            
            [[GlobalPool sharedInstance] saveContactsInfo];
            
        }else if(req.tag == TWRequestTagBlockFriend){
            [self actSync:nil];
        }else if(req.tag == TWRequestTagAcceptFriend){
            [self actSync:nil];
        }else if(req.tag == TWRequestTagDeclineFriend){
            [self actSync:nil];
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Unable to connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)requestExecutionDidFail:(JBRequest *)req{
    [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Unable to connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
