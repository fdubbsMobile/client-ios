//
//  XLCBoardMetaData.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCObjectMappingProtocol.H"

@interface XLCSectionMetaData : NSObject <XLCObjectMappingProtocol>

@property (strong, nonatomic) NSString *sectionId;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *category;

@end
