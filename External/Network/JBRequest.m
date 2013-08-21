//
//  RequestsBase.m
//  Soffer Health
//
//  Created by Arthur on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSString+HTML.h"
#import "JBRequestPool.h"

@interface JBRequest (Private)

-(void) executeAsynchronousWithMethod:(NSString*) method;
-(void) executeSynchronousWithMethod:(NSString*) method;

@end

@implementation JBRequest

@synthesize requestURL;
@synthesize requestType;
@synthesize tag;
@synthesize delegate;
@synthesize requestHeaderValue;

@synthesize webCache;
@synthesize httpSynchronousFormDataRequest;
@synthesize responseString;
@synthesize userInfo;

@synthesize statusCode;
@synthesize statusMessage;

-(void) execute {
	switch(requestType) {
		case REQUEST_TYPE_GET_SYNCHRONOUS:
			[self executeSynchronousWithMethod:@"GET"];
			break;
		case REQUEST_TYPE_PUT_ASYNCHRONOUS:
			[self executeAsynchronousWithMethod:@"PUT"];
			break;
		case REQUEST_TYPE_POST_ASYNCHRONOUS:
			[self executeAsynchronousWithMethod:@"POST"];
			break;
            
        case REQUEST_TYPE_DELETE_ASYNCHRONOUS:
            [self executeAsynchronousWithMethod:@"DELETE"];
			break;
            
		default:
			break;
	}
}

+(id) requestGETWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate
{
    JBRequest *request = [[[JBRequest alloc] init] autorelease];
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_GET_SYNCHRONOUS;
    request.delegate = delegate;
    return request;
}

+(id) requestPOSTWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate
{
    JBRequest *request = [[[JBRequest alloc] init] autorelease];
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_POST_ASYNCHRONOUS;
    request.delegate = delegate;
    return request;
}

+(id) requestPUTWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate
{
    JBRequest *request = [[[JBRequest alloc] init] autorelease];
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_PUT_ASYNCHRONOUS;
    request.delegate = delegate;
    return request;
}

+(id) requestDELETEWithURL:(NSString *)url delegate:(id<JBRequestDelegate>)delegate
{
    JBRequest *request = [[[JBRequest alloc] init] autorelease];
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_DELETE_ASYNCHRONOUS;
    request.delegate = delegate;
    return request;
}

-(void) dealloc {
	self.requestHeaderValue = nil;
    [webCache release];
    [requestURL release];
    [requestHeaderValue release];
	[httpSynchronousFormDataRequest release];
    [responseString release];
    [userInfo release];
    [statusMessage release];
	[super dealloc];
}

#pragma mark Public API implementation

-(void)setGetValue:(NSString *) value forKey:(NSString *)key
{
    NSString *phrase = [[[NSString stringWithFormat:@"%@=%@",key, value] stringByEncodingHTMLEntities] stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
    
    if ([self.requestURL rangeOfString:@"?"].location == NSNotFound)
        self.requestURL = [self.requestURL stringByAppendingFormat:@"?%@", phrase];
    else
        self.requestURL = [self.requestURL stringByAppendingFormat:@"&%@", phrase];
}

-(void) setPostValue:(id<NSObject>) value forKey:(NSString *)key {
    if (value)
        [httpSynchronousFormDataRequest setPostValue:[(NSString *)value stringByEncodingHTMLEntities] forKey:key];
}

-(void)setFile:(id<NSObject>)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key {

	[httpSynchronousFormDataRequest setFile:(NSString *)data withFileName:fileName andContentType:contentType forKey:key];
}

-(void)setPostBody:(NSMutableData*)body {
	[httpSynchronousFormDataRequest setPostBody:body];
}


-(void) setRequestType:(enum RequestType)rt {
	requestType = rt;
    
	if(REQUEST_TYPE_PUT_ASYNCHRONOUS == requestType ||
	   REQUEST_TYPE_POST_ASYNCHRONOUS == requestType ||
       REQUEST_TYPE_DELETE_ASYNCHRONOUS == requestType) {
		NSURL* url = [NSURL URLWithString:requestURL];
        
		self.httpSynchronousFormDataRequest = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease]  ;
	}
}

#pragma mark Private API implementation

-(void) executeAsynchronousWithMethod:(NSString*) method {
    [httpSynchronousFormDataRequest buildPostBody];
    [httpSynchronousFormDataRequest setRequestMethod:method] ;
    [httpSynchronousFormDataRequest setTimeOutSeconds:15.0];
    
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (requestHeaderValue)
    {
        [httpSynchronousFormDataRequest addRequestHeader:@"Content-Type" value:requestHeaderValue];
        
    }
    //[httpSynchronousFormDataRequest addRequestHeader:@"Authorization" value:[userDefault objectForKey:@"Authentication"]];
	
	[httpSynchronousFormDataRequest setDelegate:self];
	[httpSynchronousFormDataRequest setDidFinishSelector:@selector(requestFinished:)];
    [httpSynchronousFormDataRequest setDidFailSelector:@selector(requestFailed:)];	
	
    [httpSynchronousFormDataRequest startAsynchronous];
    
    self.requestHeaderValue = nil;
}

- (void)requestFinished:(ASIHTTPRequest *)req {
    self.statusCode = req.responseStatusCode;
    self.statusMessage = req.responseStatusMessage;
	self.responseString = [[httpSynchronousFormDataRequest responseString] stringByDecodingHTMLEntities];
    NSLog(@"\n----------------   Response Received (%d:%@)  ---------------- \n %@\n  \n %@ \n---------------------------------------------\n",
          req.responseStatusCode, req.responseStatusMessage,
          self.requestURL, self.responseString);
	[delegate requestExecutionDidFinish:self];
    [JBRequestPool removeRequestToIdle:self];
}

- (void)requestFailed:(ASIHTTPRequest *)req {

    NSLog(@"%d", httpSynchronousFormDataRequest.responseStatusCode);
	[delegate requestExecutionDidFail:self];
    [JBRequestPool removeRequestToIdle:self];
}

-(void) executeSynchronousWithMethod:(NSString*) method {
    NSURL* url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //[r setValue:[userDefault objectForKey:@"Authentication"] forHTTPHeaderField:@"Authorization"];
    [r setHTTPMethod:method];
    [[[NSURLConnection alloc] initWithRequest:r delegate:self] autorelease];
}

#pragma mark NSURLConnectionDataDelegate methods implementation

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
	self.webCache = [NSMutableData data];
    failureRecoveryAttempts = 5;
    if ([response respondsToSelector:@selector(statusCode)])
    {
        self.statusCode = [((NSHTTPURLResponse *)response) statusCode];
        self.statusMessage = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.webCache appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [delegate requestExecutionDidFail:self];
    [JBRequestPool removeRequestToIdle:self];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    self.responseString = [[[[NSString alloc] initWithData:webCache encoding:NSUTF8StringEncoding] autorelease] stringByDecodingHTMLEntities];
    NSLog(@"\n----------------   Response Received  (%d:%@)   ---------------- \n %@\n  \n %@ \n---------------------------------------------\n",
    self.statusCode, self.statusMessage,
          self.requestURL, self.responseString);
    [delegate requestExecutionDidFinish:self];
    [JBRequestPool removeRequestToIdle:self];
}



@end
