//
//  RequestHelper.h
//  TimeWipe
//
//  Created by Hu Lao on 12/24/12.
//  Copyright (c) 2012 Hu Lao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBRequest;

@interface RequestHelper : NSObject

+ (JBRequest *)sendRequestOfRegister:(id)delegate
                                name:(NSString *)name
                            username:(NSString *)username
                            password:(NSString *)password
                               email:(NSString *)email
                               phone:(NSString *)phone;

+ (JBRequest *)sendRequestOfLogin:(id)delegate
                         username:(NSString *)username
                         password:(NSString *)password;

+ (JBRequest *)sendRequestOfLogout:(id)delegate
                          username:(NSString*)username;

+ (JBRequest *)sendRequestOfUpdateUser:(id)delegate
                              username:(NSString*)username
                                 email:(NSString*)email
                                 phone:(NSString*)phone;
+ (JBRequest *)sendRequestOfGetContacts:(id)delegate
                               username:(NSString*)username;

+ (JBRequest *)sendRequestOfSearchContacts:(id)delegate
                                 searchKey:(NSString*)searchKey
                                  username:(NSString*)username;

+ (JBRequest *)sendRequestOfRequestFriend:(id)delegate
                                   toUser:(NSString*)toUser
                                 fromUser:(NSString*)fromUser;

+ (JBRequest *)sendRequestOfAcceptFriend:(id)delegate
                                  toUser:(NSString*)toUser
                                fromUser:(NSString*)fromUser;

+ (JBRequest *)sendRequestOfDeclineFriend:(id)delegate
                                   toUser:(NSString*)toUser
                                 fromUser:(NSString*)fromUser;

+ (JBRequest *)sendRequestOfBlockFriend:(id)delegate
                                 toUser:(NSString*)toUser
                               fromUser:(NSString*)fromUser;

+ (JBRequest *)sendRequestOfUnblockFriend:(id)delegate
                                   toUser:(NSString*)toUser
                                 fromUser:(NSString*)fromUser;

+ (JBRequest *)sendRequestOfUploadBlob:(id)delegate
                                toUser:(NSString*)toUser
                              fromUser:(NSString*)fromUser
                              blobType:(NSString*)blobType
                              blobLink:(NSString*)blobLink;

+ (JBRequest *)sendRequestOfUploadText:(id)delegate
                                toUser:(NSString*)toUser
                              fromUser:(NSString*)fromUser
                              blobType:(NSString*)blobType
                              blobText:(NSString*)blobText;

+ (JBRequest *)sendRequestOfSendMessage:(id)delegate
                                 toUser:(NSString*)toUser
                               fromUser:(NSString*)fromUser
                                 blobID:(NSString*)blobID;

+ (JBRequest *)sendRequestOfGetMessage:(id)delegate
                                blobID:(NSString*)blobID;

+ (JBRequest *)sendRequestOfGetInbox:(id)delegate
                            username:(NSString*)username;

@end
