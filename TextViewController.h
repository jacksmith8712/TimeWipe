//
//  TextViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPickerView.h"

@interface TextViewController : UIViewController<UITextViewDelegate, AFPickerViewDataSource, AFPickerViewDelegate>{
    AFPickerView *defaultPickerView;
}

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnTimer;

- (IBAction)actCancel:(id)sender;
- (IBAction)actBack:(id)sender;
- (IBAction)actSend:(id)sender;
- (IBAction)actTimer:(id)sender;
@end
