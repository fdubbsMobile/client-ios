//
//  XLCImage.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-14.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCImage : NSObject <XLCObjectMappingProtocol>

@property NSUInteger pos;
@property (strong, nonatomic) NSString *ref;

@end
