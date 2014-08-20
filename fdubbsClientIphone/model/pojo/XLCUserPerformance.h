//
//  XLCUserPerformance.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.h"

@interface XLCUserPerformance : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *performance;
@property (strong, nonatomic) NSString *rank;

@property NSUInteger hp;
@property NSUInteger level;
@property NSUInteger repeat;
@property NSUInteger contrib;

@end
