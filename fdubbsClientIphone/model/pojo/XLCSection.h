//
//  XLCSection.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCSectionMetaData.h"
#import "XLCBoardDetail.h"
#import "XLCObjectMappingProtocol.h"

@interface XLCSection : NSObject <XLCObjectMappingProtocol>

@property XLCSectionMetaData *metaData;
@property NSArray *boards;

@end
