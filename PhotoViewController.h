//
//  PhotoViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYCam.h"
#import "QBImagePickerController.h"
#import "AFPickerView.h"

@interface PhotoViewController : UIViewController<DIYCamDelegate, QBImagePickerControllerDelegate, AFPickerViewDataSource, AFPickerViewDelegate>{
    AFPickerView *defaultPickerView;
}

@property (nonatomic, retain) NSString* captureMode;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitchMode;
@property IBOutlet DIYCam *cam;
@property (weak, nonatomic) IBOutlet UIButton *btnTimer;

- (IBAction)actCapture:(id)sender;
- (IBAction)actVideo:(id)sender;
- (IBAction)actFlip:(id)sender;
- (IBAction)actBack:(id)sender;
- (IBAction)actGallery:(id)sender;
- (IBAction)actTimer:(id)sender;
@end
