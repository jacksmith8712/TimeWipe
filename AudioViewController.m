//
//  AudioViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "AudioViewController.h"
#import "SendViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Audio";
     self.isRecording = NO;
    [self.playButton setEnabled:NO];
    self.playButton.titleLabel.alpha = 0.5;
    recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    _progressView.progressTintColor = [UIColor purpleColor];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
}
#pragma mark - CountDown
- (void)startCountDown{
    countDown = 10;
//    [self.lblDuration setText:[NSString stringWithFormat:@"00:%d",countDown]];
    
    if (!countDownTimer) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
}
- (void)updateTime:(NSTimer*)timerParam{
    countDown --;
    
    float progressValue         = _progressView.progress;
    
    progressValue               += 0.1f;
    if (progressValue > 1)
    {
        progressValue = 0;
    }
    
    if (countDown == 0) {
        [self clearCountDownTimer];
    }
    
    _progressView.progress      = progressValue;
    
    [self.lblDuration setText:[NSString stringWithFormat:@"00:0%d",countDown]];
}
- (void)clearCountDownTimer{
    [countDownTimer invalidate];
    self.isRecording = NO;
    [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
    [self.playButton setEnabled:YES];
    [self.playButton.titleLabel setAlpha:1];
    [recorder stop];
    recorder = nil;
    
    NSError *playerError;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
    
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    player.delegate = self;
    countDownTimer = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playPause:(id)sender {
    //If the track is playing, pause and achange playButton text to "Play"
    if([player isPlaying])
    {
        [player pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    //If the track is not player, play the track and change the play button to "Pause"
    else
    {
        [player play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }

}

- (IBAction)startStopRecording:(id)sender {
    //If the app is not recording, we want to start recording, disable the play button, and make the record button say "STOP"
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        [self.playButton setEnabled:NO];
        [self.playButton.titleLabel setAlpha:0.5];
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];
        [self startCountDown];
        player = nil;
    }
    //If the app is recording, we want to stop recording, enable the play button, and make the record button say "REC"
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
        [self.playButton.titleLabel setAlpha:1];
        [recorder stop];
        recorder = nil;
        
        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actSend:(id)sender {
    SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
    [sendViewController setSourceType:@"Audio"];
    if ([recordedFile isFileURL]) {
        [sendViewController setMsgContent:[recordedFile path]];
    }
    [self.navigationController pushViewController:sendViewController animated:YES];
}
#pragma mark - AudioFundation Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}
@end
