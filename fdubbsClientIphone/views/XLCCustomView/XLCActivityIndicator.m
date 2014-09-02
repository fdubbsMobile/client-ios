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


+ (void) showLoadingOnView:(UIView *)view;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
}

+ (void) hideOnView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}


@end
