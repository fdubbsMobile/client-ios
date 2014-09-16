//
//  XLCPasswordPersistService.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPasswordPersistService.h"
#import "XLCKeyChainService.h"

@implementation XLCPasswordPersistService

SINGLETON_GCD(XLCPasswordPersistService);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (NSString *) getPersistPasswordForUser:(NSString *)userName
{
    return [[XLCKeyChainService sharedXLCKeyChainService] searchKeychainCopyMatching:userName];
}

- (void) addOrUpdatePersistPassword:(NSString *)password forUser:(NSString *)userName
{
    [[XLCKeyChainService sharedXLCKeyChainService] createOrUpdateKeychainValue:password forIdentifier:userName];
}

@end
