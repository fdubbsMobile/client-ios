//
//  XLCMailManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailManager.h"
#import "XLCUserManager.h"

@implementation XLCMailManager

SINGLETON_GCD(XLCMailManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}


- (void) doLoadAllMailsInBoxWithStartNumber:(NSUInteger)startNumber
                               successBlock:(void (^)(XLCMailSummaryInBox *))success
                                  failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path;
    
    if (startNumber > 0 ) {
        path = [NSString stringWithFormat:@"/api/v1/mail/all/%lu", (unsigned long)startNumber];
    } else {
        path = [NSString stringWithFormat:@"/api/v1/mail/all"];
    }
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCUserManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCMailSummaryInBox *mailSummaryInBox = [mappingResult firstObject];
                                success(mailSummaryInBox);
                                NSLog(@"Loaded mail summaris: %@", mailSummaryInBox);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadAllMailsInBoxWithStartNumber:(NSUInteger)startNumber
                            mailCountInPage:(NSUInteger)mailCountInPage
                               successBlock:(void (^)(XLCMailSummaryInBox *))success
                                  failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/mail/all/%lu/%lu",
                (unsigned long)startNumber, (unsigned long)mailCountInPage];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCUserManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCMailSummaryInBox *mailSummaryInBox = [mappingResult firstObject];
                                success(mailSummaryInBox);
                                NSLog(@"Loaded mail summaris: %@", mailSummaryInBox);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadNewMailsWithSuccessBlock:(void (^)(NSArray *))success
                              failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/mail/new"];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCUserManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *mailSummary = [mappingResult array];
                                success(mailSummary);
                                NSLog(@"Loaded mail summaris: %@", mailSummary);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadMailDetailWithMailNumber:(NSUInteger)mailNumber
                               mailLink:(NSString *)mailLink
                           successBlock:(void (^)(XLCMailDetail *))success
                              failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/mail/detail/%lu/%@", mailNumber, mailLink];
    
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCUserManager sharedXLCUserManager] getUserAuthCode];
    [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCMailDetail *mailDetail = [mappingResult firstObject];
                                success(mailDetail);
                                NSLog(@"Loaded mail detail: %@", mailDetail);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
