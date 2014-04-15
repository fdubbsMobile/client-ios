//
//  XLCFlatSettings.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCFlatSettings : NSObject

@property (strong, readwrite) UIColor *mainColor;
@property (strong, readwrite) UIColor *secondColor;
@property (strong, readwrite) UIColor *backgroundColor;

@property (strong, readwrite) UIColor *iconImageColor;
@property (strong, readwrite) UIColor *textFieldPlaceHolderColor;
@property (strong, readwrite) UIFont *font;

+ (XLCFlatSettings *)sharedInstance;

@end
