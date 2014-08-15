//
//  XLCLoginResponse.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     SUCCESS             @"SUCCESS"
#define     USER_NOT_EXIST      @"USER_NOT_EXIST"
#define     PASSWD_INCORRECT    @"PASSWD_INCORRECT"
#define     USER_ID_EMPTY       @"USER_ID_EMPTY"
#define     PASSWD_EMPTY        @"PASSWD_EMPTY"
#define     INTERNAL_ERROR      @"INTERNAL_ERROR"

@interface XLCLoginResponse : NSObject

@property (strong, nonatomic) NSString *resultCode;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *authCode;

+ (NSDictionary*)elementToPropertyMappings;

@end
