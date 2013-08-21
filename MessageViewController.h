//
//  MessageViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBRequest.h"
#import "AsyncImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MessageViewController : UIViewController<JBRequestDelegate,AVAudioPlayerDelegate>{
    AVAudioPlayer *aPlayer;
    MPMoviePlayerController *vPlayer;
}

@property (nonatomic, retain) NSDictionary *message;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (nonatomic, retain) UITextView *txtMessage;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) AsyncImageView *photoMessage;
- (IBAction)actBack:(id)sender;

@end
