//
//  XLCLoginSettingService.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-9-16.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCLoginSetting.h"

@interface XLCLoginSettingService : NSObject

+ (XLCLoginSettingService *) sharedXLCLoginSettingService;

- (NSString *) getLastLoginUser;
- (void) setLastLoginUser:(NSString *)userName;
- (XLCLoginSetting *) getLoginSettingByUserName:(NSString *)userName;
- (void) insertOrUpdateLoginSettingForUser:(NSString *)userName
                            withRememberPasswd:(BOOL)rememberMe autoLogin:(BOOL)autoLogin;

@end
