//
//  RequestHelper.m
//  ServeBoard
//
//  Created by Jin Bei on 12/24/12.
//  Copyright (c) 2012 Jin Bei. All rights reserved.
//

#import "RequestHelper.h"
#import "JBRequestPool.h"
#import "JBRequest.h"
#import "Constants.h"
//#import "UIImage-Extensions.h"
//#import "Utils.h"
#import "GlobalPool.h"

@implementation RequestHelper


/***********************************************************
 *
 * Authentication
 *
 ***********************************************************/

#pragma mark -
#pragma mark Authentication

//Register User

+ (JBRequest *)sendRequestOfRegister:(id)delegate
                                name:(NSString *)name
                            username:(NSString *)username
                            password:(NSString *)password
                               email:(NSString *)email
                               phone:(NSString *)phone
{
    
    NSString *url = [NSString stringWithFormat:@"%@/create_user", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:[GlobalPool sharedInstance].deviceToken forKey:@"deviceToken"];
    request.tag = TWRequestTagRegister;
    
    [request execute];
    return request;
}

//Login

+ (JBRequest *)sendRequestOfLogin:(id)delegate
                         username:(NSString *)username
                         password:(NSString *)password
{
    NSString *url = [NSString stringWithFormat:@"%@/login_user", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[GlobalPool sharedInstance].deviceToken forKey:@"deviceToken"];
    request.tag = TWRequestTagLogin;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfUploadBlob:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser blobType:(NSString *)blobType blobLink:(NSString *)blobLink{
    NSString *url = [NSString stringWithFormat:@"%@/upload_blob", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    [request setPostValue:blobType forKey:@"blobtype"];
    if ([blobType isEqualToString:@"Video"]) {
        [request setFile:blobLink withFileName:@"sample.mp4" andContentType:blobType forKey:@"blobdata"];
    }else{
        [request setFile:blobLink withFileName:@"sample" andContentType:blobType forKey:@"blobdata"];
    }
    [request setPostValue:[GlobalPool sharedInstance].deviceToken forKey:@"deviceToken"];
    
    request.tag = TWRequestTagUploadBlob;
    
    [request execute];
    return request;
}
+ (JBRequest *)sendRequestOfUploadText:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser blobType:(NSString *)blobType blobText:(NSString *)blobText{
    NSString *url = [NSString stringWithFormat:@"%@/upload_text", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    [request setPostValue:blobType forKey:@"blobtype"];
    [request setPostValue:blobText forKey:@"blobdata"];
    [request setPostValue:[GlobalPool sharedInstance].deviceToken forKey:@"deviceToken"];
    
    request.tag = TWRequestTagUploadText;
    
    [request execute];
    return request;
}
+ (JBRequest *)sendRequestOfSendMessage:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser blobID:(NSString *)blobID{
    NSString *url = [NSString stringWithFormat:@"%@/send_message", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"tousers"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    [request setPostValue:blobID forKey:@"blobid"];

    [request setPostValue:[GlobalPool sharedInstance].deviceToken forKey:@"deviceToken"];
    
    request.tag = TWRequestTagSendMessage;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfGetContacts:(id)delegate username:(NSString *)username{
    NSString *url = [NSString stringWithFormat:@"%@/get_contacts", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:username forKey:@"username"];
    request.tag = TWRequestTagGetContacts;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfSearchContacts:(id)delegate searchKey:(NSString *)searchKey username:(NSString *)username{
    NSString *url = [NSString stringWithFormat:@"%@/search_contacts", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:searchKey forKey:@"searchkey"];
    [request setPostValue:username forKey:@"username"];
    request.tag = TWRequestTagSearchContacts;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfBlockFriend:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser{
    NSString *url = [NSString stringWithFormat:@"%@/block_friend", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    request.tag = TWRequestTagBlockFriend;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfRequestFriend:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser{
    NSString *url = [NSString stringWithFormat:@"%@/request_friend", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    request.tag = TWRequestTagRequestFriend;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfGetInbox:(id)delegate username:(NSString *)username{
    NSString *url = [NSString stringWithFormat:@"%@/get_inbox", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:username forKey:@"username"];

    request.tag = TWRequestTagGetInbox;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfGetMessage:(id)delegate blobID:(NSString *)blobID{
    NSString *url = [NSString stringWithFormat:@"%@/get_message", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:blobID forKey:@"blobid"];
    
    request.tag = TWRequestTagGetMessage;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfAcceptFriend:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser{
    NSString *url = [NSString stringWithFormat:@"%@/accept_friend", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    
    request.tag = TWRequestTagAcceptFriend;
    
    [request execute];
    return request;
}

+ (JBRequest *)sendRequestOfDeclineFriend:(id)delegate toUser:(NSString *)toUser fromUser:(NSString *)fromUser{
    NSString *url = [NSString stringWithFormat:@"%@/decline_friend", BASE_URL];
    JBRequest *request = [JBRequestPool requestPOSTWithURL:url delegate:delegate];
    [request setPostValue:toUser forKey:@"touser"];
    [request setPostValue:fromUser forKey:@"fromuser"];
    
    request.tag = TWRequestTagDeclineFriend;
    
    [request execute];
    return request;
}
@end
