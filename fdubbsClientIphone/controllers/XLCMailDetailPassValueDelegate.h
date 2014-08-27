//
//  XLCMailDetailPassValueDelegate.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-27.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLCMailDetailPassValueDelegate <NSObject>

-(void) passValueWithMailNumber:(NSString *)mailNumber
                       mailLink:(NSString *)mailLink;

@end
