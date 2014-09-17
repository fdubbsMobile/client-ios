//
//  XLCKeyChainService.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCKeyChainService.h"
#import <Security/Security.h>

static NSString *serviceName = @"cn.edu.fudan.ss.xulvcai.fdubbsclient";

@implementation XLCKeyChainService


SINGLETON_GCD(XLCKeyChainService);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSString *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&data);
    
    NSString *result = nil;
    if (status == noErr) {
        if (data != nil) {
            result = [[NSString alloc] initWithData:(__bridge_transfer NSData *)data encoding:NSUTF8StringEncoding];
        }
        
    } else if (status == errSecItemNotFound) {
        NSLog(@"No data found");
    } else {
        NSLog(@"error!");
    }
    
    return result;
    
}

- (BOOL)createOrUpdateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, NULL);
    
    if (status == errSecSuccess) {
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
        NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
        [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
        
        status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                        (__bridge CFDictionaryRef)updateDictionary);

    } else if (status == errSecItemNotFound) {
        NSLog(@"No data found");
        
        NSMutableDictionary *newDictionary = [self newSearchDictionary:identifier];
        NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
        [newDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
        
        status = SecItemAdd((__bridge CFDictionaryRef)newDictionary, NULL);
        
    } else {
        NSLog(@"error!");
    }
    
    if (status == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

- (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

@end
