//
//  XLCActivityIndicator.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-2.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XLCActivityIndicator : NSObject

+ (void) showMessag:(NSString *)message onView:(UIView *)view;
+ (void) showLoadingOnView:(UIView *)view;
+ (void) showLoginOnView:(UIView *)view;
+ (void) showLogoutOnView:(UIView *)view;
+ (void) hideOnView:(UIView *)view;

@end
