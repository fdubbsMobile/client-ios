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




@implementation XLCPostManager

SINGLETON_GCD(XLCPostManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}

- (NSArray *) doLoadTop10Posts
{
    NSArray __block *topPosts = [[NSMutableArray alloc] init];
    
    [ProgressHUD show:@"正在努力地登录中..."];
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager ];
    [objectManager getObjectsAtPath:@"/api/v1/post/top10"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                topPosts = [mappingResult array];
                                NSLog(@"Loaded post summaries: %@", topPosts);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
    
    return topPosts;
}
@end
