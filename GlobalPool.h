//
//  GlobalObject.h
//  ServeBoard
//
//  Created by Jin Bei on 12/24/12.
//  Copyright (c) 2012 Jin Bei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalPool : NSObject

+ (GlobalPool *)sharedInstance;

@property (retain, nonatomic) NSString *deviceToken;

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *phone;

@property (nonatomic, retain) NSMutableArray *contacts;

- (void)saveUserInfo;
- (void)saveContactsInfo;

@end
