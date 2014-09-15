//
//  XLCPasswordPersistService.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCPasswordPersistService : NSObject

+ (XLCPasswordPersistService *) sharedXLCPasswordPersistService;

- (NSString *) getPersistPasswordForUser:(NSString *)userName;
- (void) addOrUpdatePersistPassword:(NSString *)password forUser:(NSString *)userName;

@end
