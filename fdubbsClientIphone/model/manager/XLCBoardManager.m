//
//  XLCBoardManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardManager.h"
#import "XLCLoginManager.h"

@implementation XLCBoardManager

SINGLETON_GCD(XLCBoardManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (void) doLoadAllSectionsWithSuccessBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(NSError *))failure
{
    [self doLoadAllSectionsWithSuccessBlock:success failBlock:failure retry:YES];
}


- (void) doLoadAllSectionsWithSuccessBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(NSError *))failure
                                     retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:@"/api/v1/section/all"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *allSections = [mappingResult array];
                                success(allSections);
                                NSLog(@"Loaded all sections : %@", allSections);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadAllSectionsWithSuccessBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}


- (void) doLoadAllBoardsInSection:(NSString *)sectionId
                     successBlock:(void (^)(XLCSection *))success
                        failBlock:(void (^)(NSError *))failure
{
    [self doLoadAllBoardsInSection:sectionId successBlock:success failBlock:failure retry:YES];
}


- (void) doLoadAllBoardsInSection:(NSString *)sectionId
                     successBlock:(void (^)(XLCSection *))success
                        failBlock:(void (^)(NSError *))failure
                            retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/section/detail/%@", sectionId];
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCSection *section = [mappingResult firstObject];
                                success(section);
                                NSLog(@"Loaded section %@ : %@", sectionId, section);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadAllBoardsInSection:sectionId successBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

- (void) doLoadFavorBoardsWithSuccessBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(NSError *))failure
{
    [self doLoadFavorBoardsWithSuccessBlock:success failBlock:failure retry:YES];
}


- (void) doLoadFavorBoardsWithSuccessBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(NSError *))failure
                                     retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:@"/api/v1/board/favor"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *favorBoards = [mappingResult array];
                                success(favorBoards);
                                NSLog(@"Loaded favor boards : %@", favorBoards);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadFavorBoardsWithSuccessBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

@end
