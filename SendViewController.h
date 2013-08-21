//
//  SendViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"

@interface SendViewController : UIViewController<JBRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *sourceType;
@property (nonatomic, strong) NSString *msgContent;
@property (nonatomic, strong) NSDictionary *msgAsset;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *receivers;
@property (nonatomic, strong) NSMutableString *recvStr;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)actSend:(id)sender;
- (IBAction)actBack:(id)sender;
@end
