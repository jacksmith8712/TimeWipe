//
//  CircleMenuViewController.h
//  KYCircleMenuDemo
//
//  Created by Kjuly on 7/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYCircleMenu.h"

@protocol CircleMenuViewControllerDelegate <NSObject>

-(void)tapCircleButton:(id)sender;

@end
@interface CircleMenuViewController : KYCircleMenu

@property (nonatomic, retain) id<CircleMenuViewControllerDelegate> delegate;
@end
