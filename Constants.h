//
//  Constants.h
//  TimeWipe
//
//  Created by JangWu on 7/16/13.
//  Copyright (c) 2013 HuLao. All rights reserved.
//

#ifndef TimeWipe_Constants_h
#define TimeWipe_Constants_h


typedef enum {
    TWRequestTagRegister,
    TWRequestTagLogin,
    TWRequestTagLogout,
    TWRequestTagUpdateUser,
    TWRequestTagGetContacts,
    TWRequestTagSearchContacts,
    TWRequestTagRequestFriend,
    TWRequestTagAcceptFriend,
    TWRequestTagDeclineFriend,
    TWRequestTagBlockFriend,
    TWRequestTagUnblockFriend,
    TWRequestTagUploadBlob,
    TWRequestTagUploadText,
    TWRequestTagSendMessage,
    TWRequestTagGetMessage,
    TWRequestTagGetInbox
} TWRequestTag;

//#define BASE_URL @"http://192.168.180.91/timewipe/index.php/api"
#define BASE_URL @"http://timewipe.com/timewipe/index.php/api"

#endif
