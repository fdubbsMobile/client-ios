//
//  XLCActivityIndicator.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-2.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCActivityIndicator.h"
#import "MBProgressHUD.h"

@implementation XLCActivityIndicator

+ (void) showMessag:(NSString *)message onView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}

+ (void) showLoadingOnView:(UIView *)view
{
    [self showMessag:@"加载中..." onView:view];
}

+ (void) showLoginOnView:(UIView *)view
{
    [self showMessag:@"登录中..." onView:view];
}

+ (void) showLogoutOnView:(UIView *)view
{
    [self showMessag:@"注销中..." onView:view];
}

+ (void) hideOnView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


@end
