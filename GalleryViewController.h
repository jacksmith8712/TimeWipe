//
//  GalleryViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCoverView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GalleryViewController : UIViewController<FlowCoverViewDelegate>

@property (nonatomic, retain) NSArray *imageArray;
@property (nonatomic, retain) NSMutableArray *mutableArray;
@property (nonatomic, retain) ALAssetsLibrary *library;

@property (nonatomic, retain) NSMutableArray *resultArray;
@property (weak, nonatomic) IBOutlet FlowCoverView *galleryView;
- (IBAction)actBack:(id)sender;
@end
