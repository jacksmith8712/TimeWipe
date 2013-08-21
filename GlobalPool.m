//
//  GlobalObject.m
//  ServeBoard
//
//  Created by Jin Bei on 12/24/12.
//  Copyright (c) 2012 Jin Bei. All rights reserved.
//

#import "GlobalPool.h"
//#import "UserInfo.h"
//#import "PostInfo.h"
//#import "GroupInfo.h"

@interface GlobalPool ()

@property (assign, nonatomic) BOOL postOriginalConfigured;

@end
@implementation GlobalPool

+ (GlobalPool *)sharedInstance
{
    static GlobalPool *instance = nil;
    
    if (instance == nil)
    {
        instance = [[GlobalPool alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.username = [defaults objectForKey:@"username"];
        self.password = [defaults objectForKey:@"password"];
        self.email = [defaults objectForKey:@"email"];
        self.phone = [defaults objectForKey:@"phone"];
        self.contacts = [defaults objectForKey:@"contacts"];
        
        if (self.username.length == 0)
            self.username = nil;
    
    }
    
    return self;
}

- (void)saveUserInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.username forKey:@"username"];
    [defaults setObject:self.password forKey:@"password"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.phone forKey:@"phone"];
    
    [defaults synchronize];
}

- (void)saveContactsInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.contacts forKey:@"contacts"];
    
    [defaults synchronize];
}

- (void)dealloc
{
    [_username release];
    [_password release];
    [_deviceToken release];
    [super dealloc];
}

@end
