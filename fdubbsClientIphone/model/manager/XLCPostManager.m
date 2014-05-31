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
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:@"/api/v1/post/top10"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *topPosts = [mappingResult array];
                                success(topPosts);
                                NSLog(@"Loaded post summaries: %@", topPosts);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
    
}

- (void) doLoadPostDetailWithBoard:(NSString *)board postId:(NSString *)postId
                          successBlock:(void (^)(XLCPostDetail *))success
                             failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/detail/board/%@/%@", board, postId];
    NSLog(@"path is %@", path);
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostDetail *postDetail = [mappingResult firstObject];
                                success(postDetail);
                                NSLog(@"Loaded post detail: %@", postDetail);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];

}

- (void) doLoadMorePostRepliesWithBoardId:(NSString *)boardId
                               mainPostId:(NSString *)mainPostId
                              lastReplyId:(NSString *)lastReplyId
                             successBlock:(void (^)(XLCPostReplies *))success
                                failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"/api/v1/post/reply/bid/%@/%@/%@", boardId, mainPostId, lastReplyId];
    NSLog(@"path is %@", path);
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCPostReplies *postReplies = [mappingResult firstObject];
                                success(postReplies);
                                NSLog(@"Loaded post replies: %@", postReplies);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
