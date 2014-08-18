//
//  XLCUserManager.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCLoginResponse.h"

@interface XLCUserManager : NSObject

+ (XLCUserManager *) sharedXLCUserManager;

- (void)doUserLoginWithUserName:(NSString *)userName
                       passWord:(NSString *)passwd
                   successBlock:(void (^)(XLCLoginResponse *))success
                      failBlock:(void (^)(NSError *))failure;

- (void)doUserLogoutWithSuccessBlock:(void (^)(void))success
                           failBlock:(void (^)(NSError *))failure;

- (BOOL) hasUserAlreadyLogin;
- (NSString *)getUserAuthCode;

@end
