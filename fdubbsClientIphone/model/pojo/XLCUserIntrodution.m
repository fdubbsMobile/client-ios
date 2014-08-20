//
//  XLCUserIntrodution.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserIntrodution.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserIntrodution

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserIntrodution class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"introdution" : @"introdution"
                                                        }];
    
    return objectMapping;
}

@end
