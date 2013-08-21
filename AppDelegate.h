//
//  AppDelegate.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class ViewController;
@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *internetReach;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (retain, nonatomic) Reachability *reachability;

@end
