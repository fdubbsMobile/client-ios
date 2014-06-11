//
//  XLCBoardMetaData.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCBoardMetaData : NSObject

@property NSUInteger boardId;
@property NSString *title;
@property NSString *boardDesc;
@property NSUInteger postNumber;
@property NSArray *managers;

@end
