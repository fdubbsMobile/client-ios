//
//  XLCSection.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCSection.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCSection

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCSection class]];
    
    RKRelationshipMapping* boardDetailRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"boards"
                                                                                              toKeyPath:@"boards"
                                                                                            withMapping:[XLCBoardDetail objectMapping]];
    
    RKRelationshipMapping* sectionMetaDataRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"section_meta_data"
                                                                                                  toKeyPath:@"metaData"
                                                                                                withMapping:[XLCSectionMetaData objectMapping]];
    
    [objectMapping addPropertyMapping:sectionMetaDataRSMapping];
    [objectMapping addPropertyMapping:boardDetailRSMapping];
    
    return objectMapping;
}

@end
