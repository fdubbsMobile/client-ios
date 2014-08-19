//
//  XLCPostQoute.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-5-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCPostQoute : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *content;

@end
