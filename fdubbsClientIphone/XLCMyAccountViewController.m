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
#import "FRDLivelyButton.h"

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
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self initialize];
}

- (void) initialize
{
    
    BOOL hasUserLogin = [[XLCUserManager sharedXLCUserManager] hasUserAlreadyLogin];
    NSLog(@"hasUserLogin : %d", hasUserLogin);
    if (!hasUserLogin) {
        NSLog(@"performSegueWithIdentifier:doLogin");
        [self performSegueWithIdentifier:@"doLogin" sender:self];
        
        return;
    }
    
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
    NSLog(@"do user login!");
    
    void (^successBlock)(void) = ^(void)
    {
        
        DebugLog(@"Success to login!");
        
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    
    [[XLCUserManager sharedXLCUserManager] doUserLogoutWithSuccessBlock:successBlock failBlock:failBlock];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showFavorBoard"])
    {
        NSLog(@"showFavorBoard");
	}
}

@end
