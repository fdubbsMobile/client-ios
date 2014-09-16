//
//  XLCLoginSetting.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-9-16.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCLoginSetting : NSObject

@property (strong, nonatomic) NSString *userName;
@property BOOL rememberPasswd;
@property BOOL autoLogin;

+ (XLCLoginSetting *) createLoginSettingFromDict:(NSDictionary *)dict;
- (NSDictionary *) getPropertyListDescriptionDict;
@end
