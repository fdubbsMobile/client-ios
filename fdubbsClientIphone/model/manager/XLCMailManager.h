//
//  XLCMailManager.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCMailSummaryInBox.h"
#import "XLCMailSummary.h"
#import "XLCMailDetail.h"

@interface XLCMailManager : NSObject

+ (XLCMailManager *) sharedXLCMailManager;

- (void) doLoadAllMailsInBoxWithStartNumber:(NSUInteger)startNumber
                               successBlock:(void (^)(XLCMailSummaryInBox *))success
                                  failBlock:(void (^)(NSError *))failure;

- (void) doLoadAllMailsInBoxWithStartNumber:(NSUInteger)startNumber
                            mailCountInPage:(NSUInteger)mailCountInPage
                               successBlock:(void (^)(XLCMailSummaryInBox *))success
                                  failBlock:(void (^)(NSError *))failure;

- (void) doLoadNewMailsWithSuccessBlock:(void (^)(NSArray *))success
                                   failBlock:(void (^)(NSError *))failure;

- (void) doLoadMailDetailWithMailNumber:(NSUInteger)mailNumber
                               mailLink:(NSString *)mailLink
                           successBlock:(void (^)(XLCMailDetail *))success
                              failBlock:(void (^)(NSError *))failure;

@end
