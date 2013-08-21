//
//  ProgressBar.h
//  ServeBoard
//
//  Created by Jin Bei on 3/13/13.
//  Copyright (c) 2013 Jin Bei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBar : UIView {
}

@property (assign, nonatomic) float minValue, maxValue, currentValue;
@property (retain, nonatomic) UIColor *lineColor, *progressRemainingColor, *progressColor, *textColor;

-(void)setNewRect:(CGRect)newFrame;

@end