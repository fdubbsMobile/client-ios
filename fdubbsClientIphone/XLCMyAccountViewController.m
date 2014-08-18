//
//  XLCMyAccountViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-17.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMyAccountViewController.h"
#import "PAImageView.h"
#import "XLCUserManager.h"

@interface XLCMyAccountViewController ()
{
    BOOL hasInitialized;
}

@property (strong, nonatomic) IBOutlet UIView *avatarView;
@property (strong, nonatomic) IBOutlet PAImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation XLCMyAccountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        hasInitialized = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL hasUserLogin = [[XLCUserManager sharedXLCUserManager] hasUserAlreadyLogin];
    NSLog(@"hasUserLogin : %d", hasUserLogin);
    if (!hasUserLogin) {
        [self performSegueWithIdentifier:@"doLogin" sender:self];
        return;
    }
    
    [self initialize];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initialize];
}

- (void) initialize
{
    if (hasInitialized) {
        NSLog(@"XLCMyAccountViewController has been initialized!");
        return;
    }
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = @"我的账号";
    self.titleColor = [UIColor whiteColor];
    
    PAImageView *avaterImageView = [[PAImageView alloc]initWithFrame:_avatarImgView.frame
                                             backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    
    [avaterImageView setImage:[UIImage imageNamed:@"defaultAvatar"]];
    [_avatarView addSubview:avaterImageView];
    [_avatarImgView removeFromSuperview];
    
    UIImage *bgImage = [[_logoutButton backgroundImageForState:UIControlStateNormal]
                        imageWithOverlayColor:[UIColor colorWithRed:212/255.0 green:63/255.0 blue:58/255.0 alpha:1]];
    [_logoutButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    hasInitialized = TRUE;
    
    DebugLog(@"init XLCMyAccountViewController");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogout:(id)sender {
}

@end
