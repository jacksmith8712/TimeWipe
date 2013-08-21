//
//  ContactsViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"

@interface ContactsViewController : UIViewController<JBRequestDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UISearchBar *txtSearch;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

@property (nonatomic, retain) NSMutableArray *searchedResult;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *contacts;
@property (nonatomic, retain) NSDictionary *currentContact;
- (IBAction)actBack:(id)sender;

@end
