//
//  TouchView.h
//  MacOsLikeMenuAnnimation
//
//  Created by Слава on 18.11.09.
//  Copyright 2009 Slava Bushtruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchViewDelegate <NSObject>

-(void)tapOnView:(UIView*)view;

@end

@interface TouchView : UIView 
{
    
}

@property (nonatomic,retain) id<TouchViewDelegate> delegate;

@end
