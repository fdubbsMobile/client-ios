//
//  XLCMailMetaData.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCMailMetaData : NSObject <XLCObjectMappingProtocol>

@property NSUInteger mailNumber;

@property (strong, nonatomic) NSString *mailLink;
@property (strong, nonatomic) NSString *sender;

@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *date;

@end
