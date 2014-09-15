//
//  XLCKeyChainService.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCKeyChainService : NSObject

+ (XLCKeyChainService *) sharedXLCKeyChainService;

- (NSString *)searchKeychainCopyMatching:(NSString *)identifier;
- (BOOL)createOrUpdateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

@end
