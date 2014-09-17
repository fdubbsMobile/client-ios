//
//  XLCLoginSettingService.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-9-16.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginSettingService.h"

static NSString *LOGIN_SETTING_DICT_KEY = @"login_setting_dict";
static NSString *LAST_LOGIN_USER_KEY = @"last_login_user";

@implementation XLCLoginSettingService

SINGLETON_GCD(XLCLoginSettingService);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}


- (NSString *) getLastLoginUser
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    return (NSString *)[mySettingData objectForKey:LAST_LOGIN_USER_KEY];
}

- (void) setLastLoginUser:(NSString *)userName
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    [mySettingData setObject:userName forKey:LAST_LOGIN_USER_KEY];
}

- (XLCLoginSetting *) getLoginSettingByUserName:(NSString *)userName
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *loginSettingDict = [mySettingData objectForKey:LOGIN_SETTING_DICT_KEY];
    if (loginSettingDict == nil) {
        NSLog(@"NO login setting dict found");
    }
    
    NSDictionary *dict = [loginSettingDict objectForKey:userName];
    
    XLCLoginSetting *loginSetting = nil;
    if (dict != nil) {
        NSLog(@"Login setting found");
        loginSetting = [XLCLoginSetting createLoginSettingFromDict:dict];
    }
    
    return loginSetting;
}

- (void) insertOrUpdateLoginSettingForUser:(NSString *)userName
                            withRememberPasswd:(BOOL)rememberMe autoLogin:(BOOL)autoLogin
{
    NSLog(@"insertOrUpdateLoginSettingForUser");
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *loginSettingDict = [[mySettingData objectForKey:LOGIN_SETTING_DICT_KEY] mutableCopy];
    if (loginSettingDict == nil) {
        loginSettingDict = [[NSMutableDictionary alloc] init];
    }
    
    NSDictionary *dict = [loginSettingDict objectForKey:userName];
    
    XLCLoginSetting *loginSetting;
    if (dict == nil) {
        loginSetting = [[XLCLoginSetting alloc] init];
    } else {
        loginSetting = [XLCLoginSetting createLoginSettingFromDict:dict];
    }
    
    
    loginSetting.userName = userName;
    loginSetting.rememberPasswd = rememberMe;
    loginSetting.autoLogin = autoLogin;
    [loginSettingDict setObject:[loginSetting getPropertyListDescriptionDict] forKey:userName];
    
    [mySettingData setObject:loginSettingDict forKey:LOGIN_SETTING_DICT_KEY];
    
    [mySettingData synchronize];
    
}


@end
