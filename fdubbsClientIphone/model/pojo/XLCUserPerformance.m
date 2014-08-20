//
//  XLCUserPerformance.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCUserPerformance.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCUserPerformance

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCUserPerformance class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                        @"performance" : @"performance",
                                                        @"hp" : @"hp",
                                                        @"level" : @"level",
                                                        @"repeat" : @"repeat",
                                                        @"contrib" : @"contrib",
                                                        @"rank" : @"rank"
                                                        }];
    
    return objectMapping;
}

@end
