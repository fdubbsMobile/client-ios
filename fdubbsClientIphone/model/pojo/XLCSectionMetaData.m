//
//  XLCBoardMetaData.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCSectionMetaData.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCSectionMetaData

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCSectionMetaData class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                                 @"section_id" : @"sectionId",
                                                                 @"section_desc" : @"desc",
                                                                 @"category" : @"category"
                                                                 }];
    
    return objectMapping;
}
@end
