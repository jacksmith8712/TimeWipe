//
//  ViewController.m
//  TimeWipe
//
//  Created by JangWu on 7/12/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#import "ViewController.h"
#import "InboxViewController.h"
#import "GalleryViewController.h"
#import "ContactsViewController.h"
#import "SettingsViewController.h"
#import "AudioViewController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"
#import "TextViewController.h"
#import "SendViewController.h"
#import "RequestHelper.h"
#import "MBProgressHUD.h"
#import "NSString+SBJSON.h"
#import "myimgeview.h"
#import "SendViewController.h"


#define RADIUS 90.0
#define PHOTONUM 4
#define PHOTOSTRING @"icon"
#define TAGSTART 1000
#define TIME 1.2
#define SCALENUMBER 1.25
int array [PHOTONUM][PHOTONUM] ={
	{0,1,2,3},
	{3,0,1,2},
	{2,3,0,1},
	{1,2,3,0}
};
CATransform3D rotationTransform1[PHOTONUM];

@interface ViewController ()

@end
#define CONST_button_size 60
#define CONST_dist_between_buttons 20
#define CONST_butons_count 4
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Setup circle menu with basic configuration
//    circleMenuViewController = [CircleMenuViewController alloc];
//    (void)[circleMenuViewController initWithButtonCount:kKYCCircleMenuButtonsCount
//                                               menuSize:kKYCircleMenuSize
//                                             buttonSize:kKYCircleMenuButtonSize
//                                  buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
//                                       centerButtonSize:kKYCircleMenuCenterButtonSize
//                                  centerButtonImageName:kKYICircleMenuCenterButton
//                        centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground];
//    
//    [self.view addSubview:circleMenuViewController.view];
//    
//    [circleMenuViewController setDelegate:self];
    [self.bottomMenu setDelegate:self];
    
    //Dial Animation
    
    NSArray *textArray = [NSArray arrayWithObjects:@"Photo",@"Audio",@"Text",@"Video",nil];
    
	float centery = self.view.center.y - 50;
	float centerx = self.view.center.x;
    
	for (int i = 0;i<PHOTONUM;i++ )
	{
		float tmpy =  centery + RADIUS*cos(2.0*M_PI *i/PHOTONUM);
		float tmpx =	centerx - RADIUS*sin(2.0*M_PI *i/PHOTONUM);
		myimgeview *addview1 =	[[myimgeview alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",PHOTOSTRING,i]] text:[textArray objectAtIndex:i]];
        addview1.frame = CGRectMake(0.0, 0.0,120,140);
		[addview1 setdege:self];
		addview1.tag = TAGSTART + i;
		addview1.center = CGPointMake(tmpx,tmpy);
		rotationTransform1[i] = CATransform3DIdentity;
		
		//float Scalenumber =atan2f(sin(2.0*M_PI *i/PHOTONUM));
		float Scalenumber = fabs(i - PHOTONUM)/(PHOTONUM);
//		if (Scalenumber<0.3)
//		{
//			Scalenumber = 0.4;
//		}
        if ((Scalenumber > 0.1f) && (Scalenumber < 0.2f) ) {
            Scalenumber = 0.275f;
        }else if((Scalenumber > 0.2f) && (Scalenumber < 0.3f)){
            Scalenumber = 0.575f;
        }
        
		CATransform3D rotationTransform = CATransform3DIdentity;
		rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*SCALENUMBER,Scalenumber*SCALENUMBER, 1);
		addview1.layer.transform=rotationTransform;
		[self.view addSubview:addview1];
		
	}
	currenttag = TAGSTART;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Circular Animation View
-(void)Clickup:(NSInteger)tag
{
	NSLog(@"Tap TAG%d:",tag);
    //	int = currenttag - tag;
	if(currenttag == tag)
     {
         if (currenttag == 1000) {
             PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
             [photoViewController setCaptureMode:@"Photo"];
             [self.navigationController pushViewController:photoViewController animated:YES];

         }else if(currenttag == 1001){
             AudioViewController *audioViewController = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
             [self.navigationController pushViewController:audioViewController animated:YES];

         }else if(currenttag == 1002){
             TextViewController *textViewController = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
             [self.navigationController pushViewController:textViewController animated:YES];
         }else if(currenttag == 1003){
             PhotoViewController *photoViewController= [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
             [photoViewController setCaptureMode:@"Video"];
             [self.navigationController pushViewController:photoViewController animated:YES];

         }
         return;
     }
	int t = [self getblank:tag];
	//NSLog(@"%d",t);
	int i = 0;
	for (i = 0;i<PHOTONUM;i++ )
	{
		
		UIImageView *imgview = (UIImageView*)[self.view viewWithTag:TAGSTART+i];
		[imgview.layer addAnimation:[self moveanimation:TAGSTART+i number:t] forKey:@"position"];
		[imgview.layer addAnimation:[self setscale:TAGSTART+i clicktag:tag] forKey:@"transform"];
		
		int j = array[tag - TAGSTART][i];
		float Scalenumber = fabs(j - PHOTONUM)/(PHOTONUM);
//		if (Scalenumber<0.3)
//		{
//			Scalenumber = 0.4;
//		}
        if ((Scalenumber > 0.1f) && (Scalenumber < 0.2f) ) {
            Scalenumber = 0.275f;
        }else if((Scalenumber > 0.2f) && (Scalenumber < 0.3f)){
            Scalenumber = 0.575f;
        }
        
		CATransform3D dtmp = CATransform3DScale(rotationTransform1[i],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
		//imgview.layer.transform=dtmp;
		
        //	imgview.layer.needsDisplayOnBoundsChange = YES;
	}
	currenttag = tag;
    //	[self performSelector:@selector(setcurrenttag) withObject:nil afterDelay:TIME];
}
-(void)setcurrenttag
{
	int i = 0;
	for (i = 0;i<PHOTONUM;i++ )
	{
		
		UIImageView *imgview = (UIImageView*)[self.view viewWithTag:TAGSTART+i];
		int j = array[currenttag - TAGSTART][i];
		float Scalenumber = fabs(j - PHOTONUM)/(PHOTONUM);
//		if (Scalenumber<0.3)
//		{
//			Scalenumber = 0.4;
//		}
        if ((Scalenumber > 0.1f) && (Scalenumber < 0.2f) ) {
            Scalenumber = 0.275f;
        }else if((Scalenumber > 0.2f) && (Scalenumber < 0.3f)){
            Scalenumber = 0.575f;
        }
        
		CATransform3D dtmp = CATransform3DScale(rotationTransform1[i],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
		imgview.layer.transform=dtmp;
		
		//	imgview.layer.needsDisplayOnBoundsChange = YES;
	}
}

-(CAAnimation*)setscale:(NSInteger)tag clicktag:(NSInteger)clicktag
{
	int i = array[clicktag - TAGSTART][tag - TAGSTART];
	int i1 = array[currenttag - TAGSTART][tag - TAGSTART];
    NSLog(@"%d %d",i,i1);
	float Scalenumber = fabs(i - PHOTONUM/1.7)/(PHOTONUM/1.7);
	float Scalenumber1 = fabs(i1 - PHOTONUM/1.7)/(PHOTONUM/1.7);
    
    NSLog(@"%f %f",Scalenumber,Scalenumber1);
//	if (Scalenumber == 0.1)
//	{
//		Scalenumber = 0.4;
//	}
    if ((Scalenumber > 0.1f) && (Scalenumber < 0.2f) ) {
        Scalenumber = 0.275f;
    }else if((Scalenumber > 0.2f) && (Scalenumber < 0.3f)){
        Scalenumber = 0.575f;
    }
    
    if ((Scalenumber1 > 0.1f) && (Scalenumber1 < 0.2f)) {
        Scalenumber1 = 0.275f;
    }else if((Scalenumber1 > 0.2f) && (Scalenumber1 < 0.3f)){
        Scalenumber1 = 0.575f;
    }
    
	UIImageView *imgview = (UIImageView*)[self.view viewWithTag:tag];
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration = TIME;
	animation.repeatCount =1;
	
    CATransform3D dtmp = CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber*SCALENUMBER, Scalenumber*SCALENUMBER, 1.0);
//	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber1*SCALENUMBER,Scalenumber1*SCALENUMBER, 1.0)];
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART],Scalenumber1*SCALENUMBER,Scalenumber1*SCALENUMBER, 1.0)];
	animation.toValue = [NSValue valueWithCATransform3D:dtmp ];
	animation.autoreverses = NO;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	imgview.layer.transform=dtmp;
	
	return animation;
}

-(CAAnimation*)moveanimation:(NSInteger)tag number:(NSInteger)num
{
	// CALayer
	UIImageView *imgview = (UIImageView*)[self.view viewWithTag:tag];
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
	CGMutablePathRef path = CGPathCreateMutable();
//	NSLog(@"Origin %f Origin %f",imgview.layer.position.x,imgview.layer.position.y);
	CGPathMoveToPoint(path, NULL,imgview.layer.position.x,imgview.layer.position.y);
	
	int p =  [self getblank:tag];
//	NSLog(@"round %d",p);
	float f = 2.0*M_PI  - 2.0*M_PI *p/PHOTONUM;
	float h = f + 2.0*M_PI *num/PHOTONUM;
	float centery = self.view.center.y - 50;
	float centerx = self.view.center.x;
	float tmpy =  centery + RADIUS*cos(h);
	float tmpx =	centerx - RADIUS*sin(h);
	imgview.center = CGPointMake(tmpx,tmpy);
	
	CGPathAddArc(path,nil,self.view.center.x, self.view.center.y - 50,RADIUS,f+ M_PI/2,f+ M_PI/2 + 2.0*M_PI *num/PHOTONUM,0);
	animation.path = path;
	CGPathRelease(path);
	animation.duration = TIME;
	animation.repeatCount = 1;
 	animation.calculationMode = @"paced";
	return animation;
}


-(NSInteger)getblank:(NSInteger)tag
{
	if (currenttag>tag)
	{
		return currenttag - tag;
	}
	else
	{
		return PHOTONUM  - tag + currenttag;
	}
    
}

-(void)Scale
{
	[UIView beginAnimations:nil context:(__bridge void *)(self)];
	[UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:1];
	
	/*
	 + (void)setAnimationWillStartSelector:(SEL)selector;                // default = NULL. -animationWillStart:(NSString *)animationID context:(void *)context
	 + (void)setAnimationDidStopSelector:(SEL)selector;                  // default = NULL. -animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
	 + (void)setAnimationDuration:(NSTimeInterval)duration;              // default = 0.2
	 + (void)setAnimationDelay:(NSTimeInterval)delay;                    // default = 0.0
	 + (void)setAnimationStartDate:(NSDate *)startDate;                  // default = now ([NSDate date])
	 + (void)setAnimationCurve:(UIViewAnimationCurve)curve;              // default = UIViewAnimationCurveEaseInOut
	 + (void)setAnimationRepeatCount:(float)repeatCount;                 // default = 0.0.  May be fractional
	 + (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;
	 */
	
	CATransform3D rotationTransform = CATransform3DIdentity;
    
    rotationTransform = CATransform3DRotate(rotationTransform,3.14, 1.0, 0.0, 0.0);
//	rotationTransform = CATransform3DScale (rotationTransform, 0.1,0.1, 2);
    //self.view.transform=CGAffineTransformMakeScale(2,2);
	
	self.view.layer.transform=rotationTransform;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
#pragma mark - TouchView Delegate
-(void)tapOnView:(UIView *)vwMenu{
    if (vwMenu.tag == 101) {
        InboxViewController *inboxViewController = [[InboxViewController alloc] initWithNibName:@"InboxViewController" bundle:nil];
        [self.navigationController pushViewController:inboxViewController animated:YES];
    }else if(vwMenu.tag == 102){
//        GalleryViewController *galleryViewController = [[GalleryViewController alloc] initWithNibName:@"GalleryViewController" bundle:nil];
//        [self.navigationController pushViewController:galleryViewController animated:YES];
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }else if(vwMenu.tag == 103){
        ContactsViewController *contactsViewController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
        [self.navigationController pushViewController:contactsViewController animated:YES];
    }else if(vwMenu.tag == 104){
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }
}
#pragma mark - CircleMenuDelegate
-(void)tapCircleButton:(id)sender{
    if ([sender tag]==1) {
        AudioViewController *audioViewController = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
        [self.navigationController pushViewController:audioViewController animated:YES];
    }else if([sender tag] == 2){
        PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
        [photoViewController setCaptureMode:@"Photo"];
        [self.navigationController pushViewController:photoViewController animated:YES];
    }else if([sender tag] == 3){
        TextViewController *textViewController = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
        [self.navigationController pushViewController:textViewController animated:YES];
    }else if([sender tag] == 4){
        PhotoViewController *photoViewController= [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
        [photoViewController setCaptureMode:@"Video"];
        [self.navigationController pushViewController:photoViewController animated:YES];
    }
}
#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
//        SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
//        [sendViewController setSourceType:@"Photo"];
//        [sendViewController setMsgAsset:info];
//        [self.navigationController pushViewController:sendViewController animated:YES];
    }else if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]){
//        NSString *videoURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
    }else if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"ALAssetTypePhoto"]){
        NSLog(@"asset photo");
    }
    [self dismissViewControllerAnimated:YES completion:^{
        SendViewController *sendViewController = [[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil];
        [sendViewController setSourceType:@"Photo"];
        [sendViewController setMsgAsset:info];
        [self.navigationController pushViewController:sendViewController animated:YES];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - JBRequestDelegate
-(void)requestExecutionDidFinish:(JBRequest *)req{
    
}
-(void)requestExecutionDidFail:(JBRequest *)req{
    
}
@end
