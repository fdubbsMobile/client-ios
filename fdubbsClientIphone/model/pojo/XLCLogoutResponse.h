//
//  XLCLogoutResponse.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-19.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

#define     SUCCESS             @"SUCCESS"
#define     ALREADY_LOGOUT      @"ALREADY_LOGOUT"
#define     INTERNAL_ERROR      @"INTERNAL_ERROR"

@interface XLCLogoutResponse : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *resultCode;
@property (strong, nonatomic) NSString *errorMessage;

@end
