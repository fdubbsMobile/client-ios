//
//  XLCPostManager.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLCPostDetail;
@class XLCPostReplies;
@class XLCPostSummaryInBoard;

@interface XLCPostManager : NSObject

+ (XLCPostManager *) sharedXLCPostManager;

- (void) doLoadTop10PostsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure;

- (void) doLoadPostDetailWithBoard:(NSString *)board postId:(NSString *)postId
                          successBlock:(void (^)(XLCPostDetail *))success
                             failBlock:(void (^)(NSError *))failure;

- (void) doLoadMorePostRepliesWithBoardId:(NSString *)boardId
                               mainPostId:(NSString *)mainPostId
                              lastReplyId:(NSString *)lastReplyId
                             successBlock:(void (^)(XLCPostReplies *))success
                                failBlock:(void (^)(NSError *))failure;

- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure;

- (void) doLoadPostSummaryInBoardWithBoardName:(NSString *)boardName
                                          mode:(NSString *)mode
                                  startPostNumber:(NSUInteger)startPostNumber
                                  successBlock:(void (^)(XLCPostSummaryInBoard *))success
                                     failBlock:(void (^)(NSError *))failure;
@end
