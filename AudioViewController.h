//
//  AudioViewController.h
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YLProgressBar.h"

@interface AudioViewController : UIViewController<AVAudioPlayerDelegate>{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    NSInteger countDown;
    NSTimer *countDownTimer;
}

@property (nonatomic) BOOL isRecording;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressView;

- (IBAction)playPause:(id)sender;
- (IBAction)startStopRecording:(id)sender;
- (IBAction)actBack:(id)sender;
- (IBAction)actSend:(id)sender;
@end
