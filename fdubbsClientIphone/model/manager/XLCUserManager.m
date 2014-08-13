//
//  XLCUserManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserManager.h"

static NSTimeInterval const cookieLiveRange = 3600 * 1000;

#define TIME_NOW_IN_SECOND ([[NSDate date] timeIntervalSince1970])

@interface XLCUserManager()
{
    
    BOOL isLoginSuccess;
    NSString *authCode;
    NSTimeInterval loginExpiredTime;
}
@end


@implementation XLCUserManager

SINGLETON_GCD(XLCUserManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}


- (BOOL) hasUserAlreadyLogin
{
    if (!isLoginSuccess) {
        NSLog(@"No login!");
        return FALSE;
    }
    
    if (loginExpiredTime < TIME_NOW_IN_SECOND) {
        NSLog(@"Time expired");
        return FALSE;
    }
    
    return TRUE;
}


- (NSString *)getUserAuthCode
{
    if ([self hasUserAlreadyLogin]) {
        return authCode;
    }
    
    return nil;
}

- (void)doUserLoginWithUserName:(NSString *)userName
                       passWord:(NSString *)passwd
                   successBlock:(void (^)(void))success
                      failBlock:(void (^)(NSError *))failure
{
    
}

@end
