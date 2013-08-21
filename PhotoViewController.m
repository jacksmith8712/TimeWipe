//
//  PhotoViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "PhotoViewController.h"
#import "SendViewController.h"
#import "GalleryViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

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
    self.title = _captureMode;
//    [self.navigationController setNavigationBarHidden:NO];
    
    // Setup cam
    self.cam.delegate       = self;
    [self.cam setupWithOptions:@{DIYAVSettingCameraPosition : [NSNumber numberWithInt:AVCaptureDevicePositionFront] }];
    if ([self.captureMode isEqualToString:@"Photo"]) {
        [self.cam setCamMode:DIYAVModePhoto];
        [self.btnTimer setHidden:NO];
        [self.btnSwitchMode setSelected:NO];
    }else{
        [self.cam setCamMode:DIYAVModeVideo];
        [self.btnTimer setHidden:YES];
        [self.btnSwitchMode setSelected:YES];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actCapture:(id)sender {
    if ([self.cam getCamMode] == DIYAVModePhoto) {
        [self.cam capturePhoto];
    }
    else {
        if ([self.cam getRecordingStatus]) {
            [self.cam captureVideoStop];
        }
        else {
            [self.cam captureVideoStart];
        }
    }
}

- (IBAction)actVideo:(id)sender {
    if (self.btnSwitchMode.selected) {
        [self.cam setCamMode:DIYAVModePhoto];
        [self.btnTimer setHidden:NO];
        [self.btnSwitchMode setSelected:NO];
    }else{
        [self.cam setCamMode:DIYAVModeVideo];
        [self.btnTimer setHidden:YES];
        [self.btnSwitchMode setSelected:YES];
    }
}

- (IBAction)actFlip:(id)sender {
    [self.cam flipCamera];
}

- (IBAction)actBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actGallery:(id)sender {
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)actTimer:(id)sender {
    if (defaultPickerView == nil) {
        defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"PickerGlass.png" title:@"AFPicker"];
        defaultPickerView.dataSource = self;
        defaultPickerView.delegate = self;
        [self.view addSubview:defaultPickerView];
    }
    [defaultPickerView showPicker];
    [defaultPickerView reloadData];
}

#pragma mark - DIYCamDelegate

- (void)camReady:(DIYCam *)cam
{
    NSLog(@"Ready");
}

- (void)camDidFail:(DIYCam *)cam withError:(NSError *)error
{
    NSLog(@"Fail");
}

- (void)camModeWillChange:(DIYCam *)cam mode:(DIYAVMode)mode
{
    NSLog(@"Mode will change");
}

- (void)camModeDidChange:(DIYCam *)cam mode:(DIYAVMode)mode
{
    NSLog(@"Mode did change");
}

- (void)camCaptureStarted:(DIYCam *)cam
{
    NSLog(@"Capture started");
}

- (void)camCaptureStopped:(DIYCam *)cam
{
    NSLog(@"Capture stopped");
}

- (void)camCaptureProcessing:(DIYCam *)cam
{
    NSLog(@"Capture processing");
}

- (void)camCaptureComplete:(DIYCam *)cam withAsset:(NSDictionary *)asset
{
//    NSLog(@"Capture complete. Asset: %@", asset);
    SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
    if (self.btnSwitchMode.selected){
        [sendViewController setSourceType:@"Video"];
    }else{
        [sendViewController setSourceType:@"Photo"];
    }
    [sendViewController setMsgAsset:asset];

    [self.navigationController pushViewController:sendViewController animated:YES];
}

- (void)camCaptureLibraryOperationComplete:(DIYCam *)cam
{
    NSLog(@"Library save complete");
}
#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        NSLog(@"Selected %d photos", mediaInfoArray.count);
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
        [sendViewController setSourceType:@"Photo"];
        [sendViewController setMsgAsset:mediaInfo];
        
        [self.navigationController pushViewController:sendViewController animated:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return 10;
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%i", row + 1];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
}

@end
