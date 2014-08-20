//
//  XLCProfileManager.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCUserInfo.h"
#import "XLCUserBaiscProfile.h"
#import "XLCUserIntrodution.h"
#import "XLCUserSignature.h"

@interface XLCProfileManager : NSObject

+ (XLCProfileManager *) sharedXLCProfileManager;

- (void) doLoadUserInfoWithUserId:(NSString *)userId
                     successBlock:(void (^)(XLCUserInfo *))success
                        failBlock:(void (^)(NSError *))failure;

- (void) doLoadUserBasicProfileWithsuccessBlock:(void (^)(XLCUserBaiscProfile *))success
                                      failBlock:(void (^)(NSError *))failure;

- (void) doLoadUserIntrodutionWithsuccessBlock:(void (^)(XLCUserIntrodution *))success
                                      failBlock:(void (^)(NSError *))failure;

- (void) doLoadUserSignatureWithsuccessBlock:(void (^)(XLCUserSignature *))success
                                      failBlock:(void (^)(NSError *))failure;
@end
