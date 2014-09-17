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
#import "XLCActivityIndicator.h"
#import "XLCActivityIndicator.h"
#import "IBActionSheet.h"
#import "XLCLoginSettingService.h"
#import "XLCLoginSetting.h"
#import "XLCPasswordPersistService.h"

@interface XLCMyAccountViewController () <IBActionSheetDelegate>
{
    BOOL _hasInitialized;
    dispatch_queue_t _queue;
}

@property (strong, nonatomic) IBOutlet UIView *avatarView;
@property (strong, nonatomic) IBOutlet PAImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UISwitch *rememberPasswdSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@end

@implementation XLCMyAccountViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _hasInitialized = FALSE;
        _queue = nil;
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
    
    if (_hasInitialized) {
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
    
    
    
    NSString *lastLoginUser = [[XLCLoginSettingService sharedXLCLoginSettingService] getLastLoginUser];
    if (lastLoginUser != nil) {
        XLCLoginSetting *loginSetting = [[XLCLoginSettingService sharedXLCLoginSettingService] getLoginSettingByUserName:lastLoginUser];
        if (loginSetting == nil) {
            NSLog(@"No loginSetting found for user : %@", lastLoginUser);
        }
        
        if (loginSetting.rememberPasswd) {
            _rememberPasswdSwitch.on = YES;
        } else {
            _rememberPasswdSwitch.on = NO;
        }
        
        if (loginSetting.autoLogin) {
            _autoLoginSwitch.on = YES;
        } else {
            _autoLoginSwitch.on = NO;
        }
    }
    
    if (_queue == nil) {
        _queue = dispatch_queue_create("updateLoginSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    _hasInitialized = TRUE;
    
    DebugLog(@"init XLCMyAccountViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rememberPasswdValueChange{
    NSLog(@"rememberPasswdValueChange");
    [self updateUserLoginSetting];
}

- (IBAction)autoLoginValueChange{
    NSLog(@"autoLoginValueChange");
    [self updateUserLoginSetting];
}

- (void) updateUserLoginSetting
{
    dispatch_async(_queue, ^{
        NSString *lastLoginUser = [[XLCLoginSettingService sharedXLCLoginSettingService] getLastLoginUser];
        if (lastLoginUser != nil) {
            [[XLCLoginSettingService sharedXLCLoginSettingService] insertOrUpdateLoginSettingForUser:lastLoginUser withRememberPasswd:_rememberPasswdSwitch.on autoLogin:_autoLoginSwitch.on];
        }
        
    });
}


- (IBAction)doLogout {
    IBActionSheet *ibaActionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销登录" otherButtonTitles:nil];
    [ibaActionSheet showInView:self.tabBarController.view];
}

#pragma mark - IBActionSheet/UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %ld clicked\nIt's title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    if (buttonIndex == 0) {
        [self doLogoutUser];
    }
}

- (void) doLogoutUser
{
    NSLog(@"do user logout!");
    
    void (^successBlock)(void) = ^(void)
    {
        
        DebugLog(@"Success to logout!");
        [XLCActivityIndicator hideOnView:self.view];
        [self performSelector:@selector(doVisitorBrowse) withObject:nil afterDelay:0.4];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        [XLCActivityIndicator hideOnView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    
    [[XLCUserManager sharedXLCUserManager] doUserLogoutWithSuccessBlock:successBlock failBlock:failBlock];
    [XLCActivityIndicator showLogoutOnView:self.view];
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

- (void) doVisitorBrowse
{
    for (UIViewController *parent = self.parentViewController; parent != nil;
         parent = parent.parentViewController) {
        NSLog(@"the class is %@", [[parent class] description]);
        if ([parent isKindOfClass:[UITabBarController class]]) {
            // jump to the tabbar
            //[self presentModalViewController:parent animated:YES];
            [(UITabBarController *)parent setSelectedIndex:0];
            break;
        }
    }
}

@end
