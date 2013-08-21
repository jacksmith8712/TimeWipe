//
//  InboxViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"
#import "ODRefreshControl.h"

@interface InboxViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JBRequestDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
- (IBAction)actBack:(id)sender;
@end
