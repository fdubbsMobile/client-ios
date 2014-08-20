//
//  XLCUserBaiscProfile.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"
#import "XLCUserMetaData.h"
#import "XLCUserBirthDate.h"

@interface XLCUserBaiscProfile : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) XLCUserMetaData *userMetaData;
@property (strong, nonatomic) XLCUserBirthDate *birthDate;

@property (strong, nonatomic) NSString *registerDate;

@property NSUInteger onlineTime;

@end
