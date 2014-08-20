//
//  XLCRESTfulClient.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "XLCRESTfulClient.h"

#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCContent.h"
#import "XLCImage.h"
#import "XLCPostDetail.h"
#import "XLCPostQoute.h"
#import "XLCPostReplies.h"
#import "XLCSectionMetaData.h"
#import "XLCSection.h"
#import "XLCBoardMetaData.h"
#import "XLCBoardDetail.h"
#import "XLCPostSummaryInBoard.h"
#import "XLCLoginResponse.h"
#import "XLCLogoutResponse.h"
#import "XLCMailSummaryInBox.h"
#import "XLCMailSummary.h"
#import "XLCMailDetail.h"
#import "XLCUserIntrodution.h"
#import "XLCUserSignature.h"
#import "XLCUserBaiscProfile.h"
#import "XLCUserInfo.h"
#import "XLCFriend.h"
#import "RKObjectManager+XLC.h"

@implementation XLCRESTfulClient

+ (void)initClient
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelError);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://fdubbsrestapi.duapp.com"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // HACK: Set User-Agent to Mac OS X so that Twitter will let us access the Timeline
    /*
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]]];
     */
    [client setDefaultHeader:@"User-Agent" value:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    // Setup post resource mapping and path mapping
    [self initPostResources:objectManager];
    
    
    NSLog(@"fxxk");
}

+ (void) initPostResources:(RKObjectManager *)objectManager
{
    [objectManager addRequestWithPathPattern:@"/api/v1/post/top10"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCPostSummary class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/post/detail/board/:boardName/:postId"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCPostDetail class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/post/reply/bid/:boardId/:mainPostId/:lastReplyId"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCPostReplies class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/section/all"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCSectionMetaData class]];

    [objectManager addRequestWithPathPattern:@"/api/v1/section/detail/:sectionId"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCSection class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/post/summary/board/:boardName/:listMode"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCPostSummaryInBoard class]];

    [objectManager addRequestWithPathPattern:@"/api/v1/post/summary/board/:boardName/:listMode/:startNumber"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCPostSummaryInBoard class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/board/favor"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCBoardDetail class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/user/login"
                                    onMethod:RKRequestMethodPOST forResponseClaass:[XLCLoginResponse class]];

    [objectManager addRequestWithPathPattern:@"/api/v1/user/logout"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCLogoutResponse class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/mail/all"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCMailSummaryInBox class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/mail/all/:startNumber"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCMailSummaryInBox class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/mail/new"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCMailSummary class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/mail/detail/:mailNumber/:mailLink"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCMailDetail class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/profile/basic"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCUserBaiscProfile class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/profile/introdution"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCUserIntrodution class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/profile/signature"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCUserSignature class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/user/info/:userId"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCUserInfo class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/profile/friend/all"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCFriend class]];
    
    [objectManager addRequestWithPathPattern:@"/api/v1/profile/friend/online"
                                    onMethod:RKRequestMethodGET forResponseClaass:[XLCFriend class]];
}

@end
