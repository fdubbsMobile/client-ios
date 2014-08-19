//
//  XLCImage.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-14.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCImage.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCImage

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCImage class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                           @"pos" : @"pos",
                                                           @"ref" : @"ref"
                                                           }];
    
    return objectMapping;
}

@end
