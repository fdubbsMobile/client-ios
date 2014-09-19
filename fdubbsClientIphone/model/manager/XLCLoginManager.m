//
//  XLCUserManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginManager.h"
#import "XLCLoginResponse.h"
#import "XLCLogoutResponse.h"

static NSTimeInterval const authKeepAliveRange = 3600 * 1000;

#define TIME_NOW_IN_SECOND ([[NSDate date] timeIntervalSince1970])

@interface XLCLoginManager()
{
    __block NSString *_userName;
    __block NSString *_password;
    
    __block BOOL _isLoginSuccess;
    __block NSString *_authCode;
    __block NSTimeInterval _loginExpiredTime;
    
    BOOL _persistLogin;
}
@end


@implementation XLCLoginManager

SINGLETON_GCD(XLCLoginManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
        [self reset];
    }
    return self;
}

- (void) reset
{
    _isLoginSuccess = FALSE;
    _authCode = nil;
    _loginExpiredTime = TIME_NOW_IN_SECOND;
    _persistLogin = TRUE;
}

-(void) makePersistLoginForCurrentUser
{
    _persistLogin = TRUE;
}

- (BOOL) hasUserAlreadyLogin
{
    // No user login before
    if (!_isLoginSuccess) {
        NSLog(@"No login!");
        return FALSE;
    }
    
    // Has Login before but session expired
    if (_loginExpiredTime < TIME_NOW_IN_SECOND) {
        if (!_persistLogin) {
            // no user implict login again
            NSLog(@"login expired and not persist");
            return FALSE;
        }
        
        //do auto login for current user
        return [self doAutoLoginForCurrentUser];
    }

    
    
    return TRUE;
}



- (NSString *)getUserAuthCode
{
    if ([self hasUserAlreadyLogin]) {
        return _authCode;
    }
    
    return nil;
}

/* This is a block call */
- (BOOL) doAutoLoginForCurrentUser
{
    __block NSLock *waitLock = [[NSLock alloc] init];
    __block BOOL loginSuccess = FALSE;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys :
                                _userName, @"user_id",
                                _password, @"passwd", nil];
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [waitLock lock];
    NSLog(@"Lock");
    [objectManager postObject:nil path:@"/api/v1/user/login"
                   parameters:parameters
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          XLCLoginResponse *loginResponse = [mappingResult firstObject];
                          NSLog(@"Login response : {authCode : %@, resultCode : %@}", [loginResponse resultCode], loginResponse.authCode);
                          if ([[loginResponse resultCode] isEqualToString:SUCCESS]) {
                              _authCode = loginResponse.authCode;
                              _isLoginSuccess = TRUE;
                              _loginExpiredTime = TIME_NOW_IN_SECOND + authKeepAliveRange;
                              
                              loginSuccess = TRUE;
                          } else {
                              _isLoginSuccess = FALSE;
                          }
                          
                          NSLog(@"Success to auto login for user : %@", _userName);
                          [waitLock unlock];
                          NSLog(@"Unlock");
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          _isLoginSuccess = FALSE;
                          [waitLock unlock];
                          NSLog(@"Unlock");
                      }];
    [waitLock lock];
    NSLog(@"Success to lock");
    [waitLock unlock];
    NSLog(@"Success to unlock");
    
    return loginSuccess;
}

- (void)doUserLoginWithUserName:(NSString *)userName
                       passWord:(NSString *)passwd
                   successBlock:(void (^)(XLCLoginResponse *))success
                      failBlock:(void (^)(NSError *))failure
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys :
                                userName, @"user_id",
                                passwd, @"passwd", nil];
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager postObject:nil path:@"/api/v1/user/login"
                         parameters:parameters
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCLoginResponse *loginResponse = [mappingResult firstObject];
                                NSLog(@"Login response : {authCode : %@, resultCode : %@}", [loginResponse resultCode], loginResponse.authCode);
                                if ([[loginResponse resultCode] isEqualToString:SUCCESS]) {
                                    _authCode = loginResponse.authCode;
                                    _isLoginSuccess = TRUE;
                                    _loginExpiredTime = TIME_NOW_IN_SECOND + authKeepAliveRange;
                                    
                                    _userName = userName;
                                    _password = passwd;
                                }
                                success(loginResponse);
                                NSLog(@"Success to login for user : %@", userName);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void)doUserLogoutWithSuccessBlock:(void (^)(void))success
                      failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", _authCode]];
    
    [objectManager getObjectsAtPath:@"/api/v1/user/logout"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCLogoutResponse *logoutResponse = [mappingResult firstObject];
                                NSLog(@"Login response : {resultCode : %@}", [logoutResponse resultCode]);
                                
                                [self reset];
                                success();
                                NSLog(@"Success to logout for user : %@", _userName);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
