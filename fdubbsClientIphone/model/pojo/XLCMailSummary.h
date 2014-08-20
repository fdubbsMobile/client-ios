//
//  XLCMailSummary.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"
#import "XLCMailMetaData.h"

@interface XLCMailSummary : NSObject <XLCObjectMappingProtocol>

@property BOOL isNew;

@property (strong, nonatomic) XLCMailMetaData *mailMetaData;
@property (strong, nonatomic) NSString *markSign;

@end
