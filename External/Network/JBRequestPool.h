//
//  JBRequestPool.h
//  MyFaves
//
//  Created by Jin Bei on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBRequest;
@interface JBRequestPool : NSObject

@property (nonatomic, retain) NSMutableArray *lstRequests;
@property (nonatomic, retain) NSMutableArray *lstIdleRequests;

+ (JBRequestPool *)sharedInstance;

+ (void)addRequest:(JBRequest *)request;
+ (void)removeRequest:(JBRequest *)request;
+ (void)removeRequestToIdle:(JBRequest *)request;
+ (void)removeDelegate:(id)delegate;

+ (id)requestGETWithURL:(NSString *)url delegate:(id)delegate;
+ (id)requestPOSTWithURL:(NSString *)url delegate:(id)delegate;
+ (id)requestPUTWithURL:(NSString *)url delegate:(id)delegate;
+ (id)requestDELETEWithURL:(NSString *)url delegate:(id)delegate;

@end
