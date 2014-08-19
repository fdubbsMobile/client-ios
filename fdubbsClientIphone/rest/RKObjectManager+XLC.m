//
//  RKObjectManager+XLC.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-19.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "RKObjectManager+XLC.h"

@implementation RKObjectManager (XLC)

- (void) addRequestWithPathPattern:(NSString *)pathPattern
                          onMethod:(RKRequestMethod)method
                 forResponseClaass:(Class)responseClass
{
    RKObjectMapping *responseMapping = [responseClass performSelector:@selector(objectMapping)];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:method
                                                                                       pathPattern:pathPattern
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [self addResponseDescriptor:responseDescriptor];
}

@end
