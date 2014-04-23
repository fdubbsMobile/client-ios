//
//  XLCParagraphContent.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-22.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCParagraphContent : NSObject

@property (strong, nonatomic) NSString *linkRef;
@property (strong, nonatomic) NSString *content;

@property BOOL isNewLine;
@property BOOL isLink;
@property BOOL isImage;

@end
