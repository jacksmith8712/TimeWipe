//
//  AsyncImageView.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"
#import "ProgressBar.h"
#import <QuartzCore/QuartzCore.h>

#define SPINNY_TAG 5555   

static ImageCache *imageCache = nil;

@interface AsyncImageView ()

@property (retain, nonatomic) ProgressBar *progressBar;

@end

@implementation AsyncImageView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [_progressBar release];
    [_imageURL release];
    [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (url == nil || url.path.length == 0)
    {
        self.image = nil;
        return;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        self.image = cachedImage;
        return;
    }else {
	}
    
    self.imageURL = urlString;
    
    

    UIView *oldSpinny = [self viewWithTag:SPINNY_TAG];
    [oldSpinny removeFromSuperview];
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
    //spinny.center = self.center;
	spinny.frame = CGRectMake(self.frame.size.width/2-spinny.frame.size.width/2, self.frame.size.height/2-spinny.frame.size.height/2, spinny.frame.size.width, spinny.frame.size.height);
    
    
	[spinny startAnimating];
    [self addSubview:spinny];
    spinny.alpha = 0;
    [spinny release];
   
    [self cancelLoading];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


+ (void)removeImageFromCacheForName:(NSString *)imagePath
{
    if (imagePath.length > 0)
        [imageCache removeImageForKey:imagePath];
}

-(void)cancelLoading
{
    if (connection)
    {
        [connection cancel];
        [connection release];
        connection = nil;
    }
}

-(void)loadImageFromURL:(NSURL*)url withSpinny:(BOOL)bShow
{
    [self loadImageFromURL:url];
    if (bShow)
        [self showActiviyIndicator];
}

-(void)loadImageFromURLWithProgressBar:(NSURL*)url
{
    [self loadImageFromURL:url];
    
    //Create Progress Bar
    
    if (self.progressBar == nil)
    {
        ProgressBar *objProgressBar= [[ProgressBar alloc] initWithFrame:CGRectMake(10, self.bounds.size.height / 2 - 30 / 2, self.bounds.size.width - 20 , 30)];
        objProgressBar.maxValue=100.0;
        objProgressBar.minValue=0.0;
        objProgressBar.lineColor=[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
        objProgressBar.textColor=[UIColor magentaColor];
        objProgressBar.progressColor=[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
        objProgressBar.progressRemainingColor=[UIColor clearColor];
        objProgressBar.currentValue=10.0;
        [self addSubview:objProgressBar];
        self.progressBar = objProgressBar;
        [objProgressBar release];
    }
    

}

- (void)showActiviyIndicator
{
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    spinny.alpha = 1;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSNumber *filesize = [NSNumber numberWithLongLong:[response expectedContentLength]];
    
    if ([filesize longLongValue] == NSURLResponseUnknownLength)
    {
        NSLog(@"Wrong Value");
        self.expectedBytes = 0;
    }
    else
    {
        NSLog(@"content-length: %f bytes", [filesize floatValue]);
        self.expectedBytes = [filesize floatValue];
        if (self.progressBar)
            [self.progressBar setHidden:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(asyncImageViewGetExpectedBytes:forView:)])
        [self.delegate asyncImageViewGetExpectedBytes:self.expectedBytes forView:self];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
    
    if (self.progressBar && self.expectedBytes > 0)
    {
        [self.progressBar setCurrentValue:((float)[data length]) / self.expectedBytes * 100.0];
    }
    
    if ([self.delegate respondsToSelector:@selector(asyncImageViewDataReceivedBytes:forView:)])
        [self.delegate asyncImageViewDataReceivedBytes:[data length] forView:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    
    self.image = [UIImage imageWithData:data];
    [imageCache insertImage:self.image withSize:[data length] forKey:urlString];
    
    CATransition *transition = [[[CATransition alloc] init] autorelease];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:transition forKey:@"image transition"];
    
    [data release];
    data = nil;
    
    [self.progressBar setHidden:YES];
    
    if ([self.delegate respondsToSelector:@selector(asyncImageViewLoadingFinished:)])
        [self.delegate asyncImageViewLoadingFinished:self];
    
    self.isLoading = NO;
    
    NSLog(@"################# Loading for image \n %@", self.imageURL);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.progressBar setHidden:YES];
    
    if ([self.delegate respondsToSelector:@selector(asyncImageViewLoadingFinished:)])
        [self.delegate asyncImageViewLoadingFinished:self];
    self.isLoading = NO;
}

@end
