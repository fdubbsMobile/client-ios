//
//  XLCPostDetail.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-22.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCPostMetaData.h"

@interface XLCPostDetail : NSObject

@property (strong, nonatomic) XLCPostMetaData *metaData;

@property (strong, nonatomic) NSArray *body;
@property (strong, nonatomic) NSArray *qoute;
@property (strong, nonatomic) NSArray *sign;

@property (strong, nonatomic) NSArray *replies;

@end
