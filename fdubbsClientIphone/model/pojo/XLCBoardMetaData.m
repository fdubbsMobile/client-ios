//
//  XLCBoardMetaData.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardMetaData.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCBoardMetaData

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCBoardMetaData class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                               @"board_id" : @"boardId",
                                                               @"title" : @"title",
                                                               @"board_desc" : @"boardDesc",
                                                               @"post_number" : @"postNumber",
                                                               @"managers" : @"managers"
                                                               }];
    
    return objectMapping;
}

@end
