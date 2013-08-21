//
//  VideoViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYCam.h"

@interface VideoViewController : UIViewController<DIYCamDelegate>

@property IBOutlet DIYCam *cam;
- (IBAction)actRecord:(id)sender;
- (IBAction)actPhoto:(id)sender;
- (IBAction)actBack:(id)sender;
@end
