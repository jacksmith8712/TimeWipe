//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
//

#import <UIKit/UIKit.h>

@protocol AsyncImageViewDelegate;

@interface AsyncImageView : UIImageView <NSURLConnectionDataDelegate> {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
}

@property (assign, nonatomic) float expectedBytes;
@property (retain, nonatomic) NSString *imageURL;
@property (assign, nonatomic) BOOL isLoading;

@property (assign, nonatomic) id<AsyncImageViewDelegate> delegate;

-(void)loadImageFromURL:(NSURL*)url;
-(void)loadImageFromURL:(NSURL*)url withSpinny:(BOOL)bShow;
-(void)loadImageFromURLWithProgressBar:(NSURL*)url;
-(void)showActiviyIndicator;
-(void)cancelLoading;
+ (void)removeImageFromCacheForName:(NSString *)imagePath;
@end


@protocol AsyncImageViewDelegate <NSObject>

- (void)asyncImageViewGetExpectedBytes:(float)bytes forView:(AsyncImageView *)v;
- (void)asyncImageViewDataReceivedBytes:(float)bytes forView:(AsyncImageView *)v;
- (void)asyncImageViewLoadingFinished:(AsyncImageView *)v;

@end