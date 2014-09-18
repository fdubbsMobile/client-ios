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
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/profile/friend/all"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *allFriends = [mappingResult array];
                                success(allFriends);
                                NSLog(@"Loaded all friends: %@", allFriends);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadOnlineFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                   failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/profile/friend/online"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *onlineFriends = [mappingResult array];
                                success(onlineFriends);
                                NSLog(@"Loaded online friends: %@", onlineFriends);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
