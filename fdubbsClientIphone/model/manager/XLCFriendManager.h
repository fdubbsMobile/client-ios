//
//  XLCFriendManager.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCFriendManager : NSObject

+ (XLCFriendManager *) sharedXLCFriendManager;

- (void) doLoadAllFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure;

- (void) doLoadOnlineFriendsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure;

@end
