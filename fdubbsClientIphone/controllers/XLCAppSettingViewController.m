//
//  XLCAppSettingViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-17.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCAppSettingViewController.h"

@interface XLCAppSettingViewController ()

@end

@implementation XLCAppSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = @"应用设置";
    self.titleColor = [UIColor whiteColor];
    
    DebugLog(@"init XLCAppSettingViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
