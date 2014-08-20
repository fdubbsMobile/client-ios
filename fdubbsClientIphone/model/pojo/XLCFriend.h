//
//  XLCFriend.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCFriend : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *nick;

@property (strong, nonatomic) NSString *lastLoginIp;
@property (strong, nonatomic) NSString *lastAction;

@property NSUInteger idleTime;
@property (strong, nonatomic) NSString *desc;

@end
