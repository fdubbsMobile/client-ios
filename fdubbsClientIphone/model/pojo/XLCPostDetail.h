//
//  XLCPostDetail.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-22.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCPostMetaData.h"
#import "XLCContent.h"

@interface XLCPostDetail : NSObject

@property (strong, nonatomic) XLCPostMetaData *metaData;

@property (strong, nonatomic) XLCContent *body;
@property (strong, nonatomic) XLCContent *qoute;
@property (strong, nonatomic) XLCContent *sign;

@property (strong, nonatomic) NSArray *replies;

@end
