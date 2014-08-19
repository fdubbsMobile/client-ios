//
//  RKObjectManager+XLC.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-19.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "RKObjectManager.h"

@interface RKObjectManager (XLC)

- (void) addRequestWithPathPattern:(NSString *)pathPattern
                          onMethod:(RKRequestMethod)method
                 forResponseClaass:(Class)responseClass;
@end
