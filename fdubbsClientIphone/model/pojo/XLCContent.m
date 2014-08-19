//
//  XLCContent.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-14.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCContent.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCContent

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCContent class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                             @"text" : @"text"
                                                             }];
    RKRelationshipMapping* contentImageRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"images"
                                                                                               toKeyPath:@"images"
                                                                                             withMapping:[XLCImage objectMapping]];
    [objectMapping addPropertyMapping:contentImageRSMapping];
    
    return objectMapping;
}

@end
