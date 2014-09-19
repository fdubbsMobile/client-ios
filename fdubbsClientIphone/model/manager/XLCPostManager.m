//
//  XLCPostManager.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//


#import <RestKit/RestKit.h>
#import "ProgressHUD.h"

#import "XLCPostManager.h"
#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCPostDetail.h"
#import "XLCPostSummaryInBoard.h"
#import "XLCLoginManager.h"

@implementation XLCPostManager

SINGLETON_GCD(XLCPostManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (void) doLoadTop10PostsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure
{
    [self doLoadTop10PostsWithSuccessBlock:success failBlock:failure retry:YES];
}


- (void) doLoadTop10PostsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure
                                    retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:@"/api/v1/post/top10"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *topPosts = [mappingResult array];
                                success(topPosts);
                                NSLog(@"Loaded post summaries: %@", topPosts);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadTop10PostsWithSuccessBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
    
}

- (void) doLoadPostDetailWithBoard:(NSString *)board postId:(NSString *)postId
                      successBlock:(void (^)(XLCPostDetail *))success
                         failBlock:(void (^)(NSError *))failure
{
    [self doLoadPostDetailWithBoard:board postId:postId successBlock:success failBlock:failure retry:YES];
}

- (void) doLoadPostDetailWithBoard:(NSString *)board postId:(NSString *)postId
                          successBlock:(void (^)(XLCPostDetail *))success
                         failBlock:(void (^)(NSError *))failure
                             retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/detail/board/%@/%@", board, postId];
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostDetail *postDetail = [mappingResult firstObject];
                                NSLog(@"Loaded post detail: %@", postDetail);
                                success(postDetail);
                                
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadPostDetailWithBoard:board postId:postId successBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];

}

- (void) doLoadMorePostRepliesWithBoardId:(NSString *)boardId
                               mainPostId:(NSString *)mainPostId
                              lastReplyId:(NSString *)lastReplyId
                             successBlock:(void (^)(XLCPostReplies *))success
                                failBlock:(void (^)(NSError *))failure
{
    [self doLoadMorePostRepliesWithBoardId:boardId mainPostId:mainPostId lastReplyId:lastReplyId successBlock:success failBlock:failure retry:YES];
}

- (void) doLoadMorePostRepliesWithBoardId:(NSString *)boardId
                               mainPostId:(NSString *)mainPostId
                              lastReplyId:(NSString *)lastReplyId
                             successBlock:(void (^)(XLCPostReplies *))success
                                failBlock:(void (^)(NSError *))failure
                                    retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/reply/bid/%@/%@/%@", boardId, mainPostId, lastReplyId];
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostReplies *postReplies = [mappingResult firstObject];
                                success(postReplies);
                                NSLog(@"Loaded post replies: %@", postReplies);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadMorePostRepliesWithBoardId:boardId mainPostId:mainPostId lastReplyId:lastReplyId successBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure
{
    [self doLoadPostSummaryInBoardWithBoardName:boardName mode:mode successBlock:success failBlock:failure retry:YES];
}

- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure
                                         retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/summary/board/%@/%@", boardName, mode];
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostSummaryInBoard *postSummaryInBoard = [mappingResult firstObject];
                                success(postSummaryInBoard);
                                NSLog(@"Loaded post summaris: %@", postSummaryInBoard);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadPostSummaryInBoardWithBoardName:boardName mode:mode successBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}


- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                               startPostNumber:(NSUInteger)startPostNumber
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure
{
    [self doLoadPostSummaryInBoardWithBoardName:boardName mode:mode startPostNumber:startPostNumber successBlock:success failBlock:failure retry:YES];
}

- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                                  startPostNumber:(NSUInteger)startPostNumber
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure
                                         retry:(BOOL)retry
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/summary/board/%@/%@/%lu", boardName, mode, (unsigned long)startPostNumber];
    NSLog(@"path is %@", path);
    
    NSString *authCode = [[XLCLoginManager sharedXLCLoginManager] getUserAuthCode];
    if (authCode != nil) {
        [[objectManager HTTPClient] setDefaultHeader:@"Cookie" value:[NSString stringWithFormat:@"auth_code=%@", authCode]];
    }
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostSummaryInBoard *postSummaryInBoard = [mappingResult firstObject];
                                success(postSummaryInBoard);
                                NSLog(@"Loaded post summaris: %@", postSummaryInBoard);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (retry && (error.code == 603 || error.code == 604)) {
                                    NSLog(@"retry");
                                    [self doLoadPostSummaryInBoardWithBoardName:boardName mode:mode startPostNumber:startPostNumber successBlock:success failBlock:failure retry:NO];
                                } else {
                                    failure(error);
                                }
                            }];
}

@end
