//
//  XLCBoardDetail.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCBoardMetaData.h"
#import "XLCObjectMappingProtocol.h"

@interface XLCBoardDetail : NSObject <XLCObjectMappingProtocol>

@property XLCBoardMetaData *metaData;
@property NSString *category;
@property BOOL isDirectory;
@property BOOL hasUnreadPost;

@end
