//
//  XLCUserSignature.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserSignature.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserSignature

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserSignature class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"signature" : @"signature"
                                                        }];
    
    return objectMapping;
}

@end
