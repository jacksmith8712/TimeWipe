//
//  MessageViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "MessageViewController.h"
#import "Constants.h"
#import "RequestHelper.h"
#import "NSString+SBJSON.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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
    NSLog(@"%@",_message);
    
    NSDate *sentDate = [NSDate dateWithTimeIntervalSince1970:[[_message objectForKey:@"timestamp"] doubleValue]];
    NSDate *now = [NSDate date];
    long diff = [now timeIntervalSinceDate:sentDate];
    
    NSLog(@"%ld",diff);
    if (diff < 60) {
        [_lblDescription setText:[NSString stringWithFormat:@"%ld seconds ago by %@",diff,[_message objectForKey:@"fromUser"]]];
    }else if(diff < 3600){
        [_lblDescription setText:[NSString stringWithFormat:@"%ld minutes ago by %@",diff/60,[_message objectForKey:@"fromUser"]]];
    }else if(diff < 86400){
        [_lblDescription setText:[NSString stringWithFormat:@"%ld hrs ago by %@",diff/3600,[_message objectForKey:@"fromUser"]]];
    }else if(diff < 2592000){
        [_lblDescription setText:[NSString stringWithFormat:@"%ld days ago by %@",diff/864000,[_message objectForKey:@"fromUser"]]];
    }else{
        [_lblDescription setText:[NSString stringWithFormat:@"a few months ago by %@",[_message objectForKey:@"fromUser"]]];
    }
    
    [RequestHelper sendRequestOfGetMessage:self blobID:[_message objectForKey:@"blobID"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)playPause:(id)sender {
    //If the track is playing, pause and achange playButton text to "Play"
    if([aPlayer isPlaying])
    {
        [aPlayer pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    //If the track is not player, play the track and change the play button to "Pause"
    else
    {
        [aPlayer play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
}

#pragma mark - AudioFundation Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFail:(JBRequest *)req{
    [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Unable to connect server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
-(void)requestExecutionDidFinish:(JBRequest *)req{
    NSDictionary *dict = [req.responseString JSONValue];
    if ([[dict objectForKey:@"success"] isEqualToString:@"YES"]) {
        if (req.tag == TWRequestTagGetMessage) {
            if ([[dict objectForKey:@"blobType"] isEqualToString:@"Text"]) {
                _txtMessage = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
                [self.vwContent addSubview:_txtMessage];
                [_txtMessage setText:[dict objectForKey:@"blobData"]];
            }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Photo"]){
                _photoMessage = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
                [self.vwContent addSubview:_photoMessage];
                [_photoMessage loadImageFromURLWithProgressBar:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict objectForKey:@"blobData"]]]];
            }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Audio"]){
                _playButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 140, 44, 44)];
                [_playButton setImage:[UIImage imageNamed:@"audio_icon"] forState:UIControlStateNormal];
                [_playButton addTarget:self action:@selector(playPause:) forControlEvents:UIControlEventTouchUpInside];
                [self.vwContent addSubview:_playButton];
                
                NSError *playerError;
                
                NSData *soundData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict objectForKey:@"blobData"]]]];
                
                aPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&playerError];
                
                if (aPlayer == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                aPlayer.delegate = self;
            }else if([[dict objectForKey:@"blobType"] isEqualToString:@"Video"]){
                
                vPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.mp4",[dict objectForKey:@"blobData"]]]];
                if (vPlayer != nil) {
                    [vPlayer prepareToPlay];
                    [vPlayer.view setFrame:CGRectMake(10, 10, 300, 300)];
                    [vPlayer setShouldAutoplay:YES];
                    [vPlayer setMovieSourceType:MPMovieSourceTypeStreaming];
                    [self.vwContent addSubview:vPlayer.view];
//                    [vPlayer play];
                }
            }
        }
    }else{
        [[[UIAlertView alloc] initWithTitle:@"TimeWipe" message:@"Database error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
