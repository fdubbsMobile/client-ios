//
//  XLCUserInfo.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"
#import "XLCUserMetaData.h"
#import "XLCUserPerformance.h"
#import "XLCUserSignature.h"

@interface XLCUserInfo : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) XLCUserMetaData *userMetaData;
@property (strong, nonatomic) XLCUserPerformance *userPerformance;
@property (strong, nonatomic) XLCUserSignature *userSignature;

@property (strong, nonatomic) NSString *ident;
@property (strong, nonatomic) NSString *desc;

@property BOOL isVisible;
@property BOOL isWeb;

@property NSUInteger idleTime;

@end
