//
//  XLCPostMetaData.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLCPostMetaData : NSObject

@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *board;

- (id) init;
- (XLCPostMetaData *) withPostId:(NSString *)postId;
- (XLCPostMetaData *) withTitle:(NSString *)title;
- (XLCPostMetaData *) withOwner:(NSString *)owner;
- (XLCPostMetaData *) withNick:(NSString *)nick;
- (XLCPostMetaData *) withDate:(NSString *)date;
- (XLCPostMetaData *) withBoard:(NSString *)board;

@end
