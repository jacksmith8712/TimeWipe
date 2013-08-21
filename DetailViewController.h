//
//  DetailViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/19/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic,retain) NSString *content;
- (IBAction)actBack:(id)sender;
@end
