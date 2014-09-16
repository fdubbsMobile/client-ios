//
//  XLCLoginSetting.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-9-16.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginSetting.h"

@implementation XLCLoginSetting

- (id) init
{
    self = [super init];
    
    if (self) {
        _userName = nil;
        _rememberPasswd = NO;
        _autoLogin = NO;
    }
    
    return self;
}

+ (XLCLoginSetting *) createLoginSettingFromDict:(NSDictionary *)dict
{
    XLCLoginSetting *loginSetting = [[XLCLoginSetting alloc] init];
    loginSetting.userName = [dict objectForKey:@"UserName"];
    loginSetting.rememberPasswd = [[dict objectForKey:@"RememberPasswd"] boolValue];
    loginSetting.autoLogin = [[dict objectForKey:@"AutoLogin"] boolValue];
    
    return loginSetting;
}

- (NSDictionary *) getPropertyListDescriptionDict
{
    NSLog(@"getPropertyListDescriptionDict");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:_userName forKey:@"UserName"];
    [dict setValue:[NSNumber numberWithBool:_rememberPasswd] forKey:@"RememberPasswd"];
    [dict setValue:[NSNumber numberWithBool:_autoLogin] forKey:@"AutoLogin"];
    
    return dict;
}

@end
