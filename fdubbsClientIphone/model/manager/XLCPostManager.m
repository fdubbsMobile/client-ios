//
//  XLCPostManager.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//


#import <RestKit/RestKit.h>
#import "ProgressHUD.h"

#import "XLCGCDSingleton.h"
#import "XLCPostManager.h"


#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"

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
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *topPosts = [[NSMutableArray alloc] init];
        XLCPostMetaData *metaData = [[XLCPostMetaData alloc] init];
        metaData.title = @"test";
        metaData.board = @"test1";
        metaData.owner = @"fxxk";
        
        
        
        for (int i = 0; i < 10; i++) {
            XLCPostSummary *post = [[XLCPostSummary alloc] init];
            post.metaData = metaData;
            post.count = @"1";
            [topPosts addObject:post];
        }
        
        [NSThread sleepForTimeInterval:3.0f];
        
        success(topPosts);
    }];
    
    [queue addOperation:op];
    */
    
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

@end
