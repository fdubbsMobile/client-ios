//
//  XLCBoardManager.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLCSection.h"

@interface XLCBoardManager : NSObject

+ (XLCBoardManager *) sharedXLCBoardManager;

- (void) doLoadAllSectionsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure;

- (void) doLoadAllBoardsInSection:(NSString *)sectionId successBlock:(void (^)(XLCSection *))success
                                 failBlock:(void (^)(NSError *))failure;

- (void) doLoadFavorBoardsWithAuthCode:(NSString *)authCode successBlock:(void (^)(NSArray *))success
                             failBlock:(void (^)(NSError *))failure;
@end
