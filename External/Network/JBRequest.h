//
//  RequestsBase.h
//  Soffer Health
//
//  Created by Arthur on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import <Foundation/Foundation.h>

@class JBRequest;

@protocol JBRequestDelegate

@required
/// Must be invoked by the subclasses of the RequestsBase class whenever the request execution is successfully finished
-(void) requestExecutionDidFinish:(JBRequest*) req;

/// Must be invoked by the subclasses of the RequestsBase class whenever the request execution is failed
-(void) requestExecutionDidFail:(JBRequest*) req;

@optional
-(void) progressValue:(float) value forRequest:(JBRequest*) r;

@end

/// Enumeration of the available request types
enum RequestType {
    REQUEST_TYPE_GET_SYNCHRONOUS,
	REQUEST_TYPE_PUT_ASYNCHRONOUS,
	REQUEST_TYPE_POST_ASYNCHRONOUS,
    REQUEST_TYPE_DELETE_ASYNCHRONOUS,
    REQUEST_TYPE_UNKNOWN
};

/// Base class for all types of requests
@interface JBRequest : NSObject<NSURLConnectionDataDelegate> {
    NSString* requestURL;
    enum RequestType requestType;
    int tag;
    NSObject *userInfo;
    id<JBRequestDelegate> delegate;
    NSMutableData* webCache;
	NSString* requestHeaderValue;
    NSString* responseString;
    int failureRecoveryAttempts;
	ASIFormDataRequest* httpSynchronousFormDataRequest;
}

@property (nonatomic, retain) NSString* requestURL;
@property (nonatomic, assign) enum RequestType requestType;
@property (nonatomic, assign) int tag;
@property (nonatomic, retain) NSObject *userInfo;
@property (nonatomic, assign) id<JBRequestDelegate> delegate;
@property (nonatomic, retain) NSString* requestHeaderValue;
@property (nonatomic, retain) NSString* encType;

@property (nonatomic, retain) NSMutableData* webCache;
@property (nonatomic, retain) ASIFormDataRequest* httpSynchronousFormDataRequest;
@property (nonatomic, retain) NSString* responseString;

@property (nonatomic, assign) int statusCode;
@property (nonatomic, retain) NSString *statusMessage;



/// Sets the get value for the given key
-(void)setGetValue:(NSString *) value forKey:(NSString *)key;

/// Sets the post value for the given key
-(void) setPostValue:(id<NSObject>) value forKey:(NSString *)key;

/// Sets the file for sending with post method
-(void)setFile:(id<NSObject>)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

/// Sets the post body for sending with post method
-(void)setPostBody:(NSMutableData*)body;

/**
 Public API
 */

/// Executes the request
-(void) execute;

+(id) requestGETWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate;
+(id) requestPOSTWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate;
+(id) requestPUTWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate;
+(id) requestDELETEWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate;
@end
