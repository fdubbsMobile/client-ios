//
//  XLCUserBirthDate.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCUserBirthDate : NSObject <XLCObjectMappingProtocol>

@property NSUInteger year;
@property NSUInteger month;
@property NSUInteger day;

@end
