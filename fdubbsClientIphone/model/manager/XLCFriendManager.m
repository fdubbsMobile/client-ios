//
//  XLCFriendManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCFriendManager.h"
#import "XLCLoginManager.h"

@implementation XLCFriendManager

SINGLETON_GCD(XLCFriendManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (void) doLoadAllFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure
{
    [self doLoadAllFriendsWithSuccessBlock:success failBlock:failure retry:YES];
}

- (void) doLoadAllFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/profile/friend/all"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *allFriends = [mappingResult array];
                                success(allFriends);
                                NSLog(@"Loaded all friends: %@", allFriends);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    [self doLoadAllFriendsWithSuccessBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

- (void) doLoadOnlineFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                   failBlock:(void (^)(NSError *))failure
{
    [self doLoadOnlineFriendsWithSuccessBlock:success failBlock:failure retry:YES];
}

- (void) doLoadOnlineFriendsWithSuccessBlock:(void (^)(NSArray *))success failBlock:(void (^)(NSError *))failure retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/profile/friend/online"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *onlineFriends = [mappingResult array];
                                success(onlineFriends);
                                NSLog(@"Loaded online friends: %@", onlineFriends);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    [self doLoadOnlineFriendsWithSuccessBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

@end
