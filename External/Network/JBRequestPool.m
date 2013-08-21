//
//  JBRequestPool.m
//  MyFaves
//
//  Created by Jin Bei on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBRequestPool.h"
#import "JBRequest.h"

@implementation JBRequestPool
@synthesize lstRequests;
@synthesize lstIdleRequests;

- (void)dealloc
{
    [lstRequests release];
    [lstIdleRequests release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.lstRequests = [NSMutableArray array];
        self.lstIdleRequests = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 
#pragma mark Static Methods

+ (JBRequestPool *)sharedInstance
{
    static JBRequestPool *instance = nil;
    
    if (instance == nil)
    {
        instance = [[JBRequestPool alloc] init];
    }
    return instance;
}





#pragma mark Main methods

+ (void)addRequest:(JBRequest *)request
{
    [[self sharedInstance].lstRequests addObject:request];
    [[self sharedInstance].lstIdleRequests removeObject:request];
}

+ (void)removeRequestToIdle:(JBRequest *)request
{
    request.delegate = nil;
    if ([self sharedInstance].lstIdleRequests.count < 5)
        [[self sharedInstance].lstIdleRequests addObject:request];
    [[self sharedInstance].lstRequests removeObject:request];
}

+ (void)removeRequest:(JBRequest *)request
{
    request.delegate = nil;
    [[self sharedInstance].lstRequests removeObject:request];
    [[self sharedInstance].lstIdleRequests removeObject:request];
}

+ (void)removeDelegate:(id)delegate
{
    NSArray *lstRequests = [self sharedInstance].lstRequests;
    for (JBRequest *request in lstRequests)
        if (request.delegate == delegate)
            request.delegate = nil;
}


#pragma mark JBRequest call methods

+ (id)requestGETWithURL:(NSString *)url delegate:(id)delegate
{
    JBRequest *request;
    JBRequestPool *pool = [JBRequestPool sharedInstance];
    if (pool.lstIdleRequests.count > 0)
        request = [pool.lstIdleRequests objectAtIndex:0];
    else
        request = [[[JBRequest alloc] init] autorelease];
    
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_GET_SYNCHRONOUS;
    request.delegate = delegate;
    
    [self addRequest:request];
    return request;
}

+ (id)requestPOSTWithURL:(NSString *)url delegate:(id)delegate
{
    JBRequest *request;
    JBRequestPool *pool = [JBRequestPool sharedInstance];
    if (pool.lstIdleRequests.count > 0)
        request = [pool.lstIdleRequests objectAtIndex:0];
    else
        request = [[[JBRequest alloc] init] autorelease];
    
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_POST_ASYNCHRONOUS;
    request.delegate = delegate;
    
    [self addRequest:request];
    return request;
}

+ (id)requestPUTWithURL:(NSString *)url delegate:(id)delegate
{
    JBRequest *request;
    JBRequestPool *pool = [JBRequestPool sharedInstance];
    if (pool.lstIdleRequests.count > 0)
        request = [pool.lstIdleRequests objectAtIndex:0];
    else
        request = [[[JBRequest alloc] init] autorelease];
    
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_PUT_ASYNCHRONOUS;
    request.delegate = delegate;
    
    [self addRequest:request];
    return request;
}

+ (id)requestDELETEWithURL:(NSString *)url delegate:(id)delegate
{
    JBRequest *request;
    JBRequestPool *pool = [JBRequestPool sharedInstance];
    if (pool.lstIdleRequests.count > 0)
        request = [pool.lstIdleRequests objectAtIndex:0];
    else
        request = [[[JBRequest alloc] init] autorelease];
    
    request.requestURL = url;
    request.requestType = REQUEST_TYPE_DELETE_ASYNCHRONOUS;
    request.delegate = delegate;

    [self addRequest:request];
    return request;
}


@end
