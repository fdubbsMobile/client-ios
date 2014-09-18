//
//  XLCProfileManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCProfileManager.h"
#import "XLCLoginManager.h"

@implementation XLCProfileManager

SINGLETON_GCD(XLCProfileManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (void) doLoadUserInfoWithUserId:(NSString *)userId
                     successBlock:(void (^)(XLCUserInfo *))success
                        failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/user/info/%@", userId];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCUserInfo *userInfo = [mappingResult firstObject];
                                success(userInfo);
                                NSLog(@"Loaded user info: %@", userInfo);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadUserBasicProfileWithsuccessBlock:(void (^)(XLCUserBaiscProfile *))success
                                      failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/basicProfile/basicProfile"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCUserBaiscProfile *basicProfile = [mappingResult firstObject];
                                success(basicProfile);
                                NSLog(@"Loaded user basic profile: %@", basicProfile);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadUserIntrodutionWithsuccessBlock:(void (^)(XLCUserIntrodution *))success
                                     failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/basicProfile/introdution"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCUserIntrodution *introdution = [mappingResult firstObject];
                                success(introdution);
                                NSLog(@"Loaded user introdution: %@", introdution);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadUserSignatureWithsuccessBlock:(void (^)(XLCUserSignature *))success
                                   failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/basicProfile/signature"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCUserSignature *signature = [mappingResult firstObject];
                                success(signature);
                                NSLog(@"Loaded user signature: %@", signature);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
