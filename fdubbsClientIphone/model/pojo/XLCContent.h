//
//  XLCContent.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-14.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCImage.h"
#import "XLCObjectMappingProtocol.h"

@interface XLCContent : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *images;

@end
