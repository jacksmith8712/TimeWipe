//
//  ViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CircleMenuViewController.h"
#import "TouchView.h"
#import "JBRequest.h"
#import "QBImagePickerController.h"

#pragma mark -
#pragma mark - View  - prefix: KY

// Button Size
#define kKYButtonInMiniSize   16.f
#define kKYButtonInSmallSize  32.f
#define kKYButtonInNormalSize 64.f

#pragma mark - KYCircleMenu Configuration

// Number of buttons around the circle menu
#define kKYCCircleMenuButtonsCount 4
// Circle Menu
// Basic constants
#define kKYCircleMenuSize             280.f
#define kKYCircleMenuButtonSize       kKYButtonInNormalSize
#define kKYCircleMenuCenterButtonSize kKYButtonInNormalSize
// Image
#define kKYICircleMenuCenterButton           @"KYICircleMenuCenterButton.png"
#define kKYICircleMenuCenterButtonBackground @"KYICircleMenuCenterButtonBackground.png"
#define kKYICircleMenuButtonImageNameFormat  @"KYICircleMenuButton%.2d.png" // %.2d: 1 - 6

@interface ViewController : UIViewController<TouchViewDelegate,CircleMenuViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,JBRequestDelegate, QBImagePickerControllerDelegate>{
    CircleMenuViewController * circleMenuViewController;
    UIImageView *addview;
	int  currenttag;
}
@property (weak, nonatomic) IBOutlet TouchView *bottomMenu;

-(void)Clickup:(NSInteger)tag;
-(NSInteger)getblank:(NSInteger)tag;
-(CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num;

@end
