//
//  XLCPostDetailViewCell.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-18.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLCPostDetail.h"
#import "NIAttributedLabel.h"
#import "XLCImage.h"
#import "XLCContent.h"
#import "XLCCustomLinkView.h"

#define INITIAL_HEIGHT 30

@interface XLCPostDetailViewCell : UITableViewCell
{
    BOOL hasInitialied;
    BOOL hasQuote;
    CGFloat heightOfCell;
    
    NSInteger section;
    NSInteger row;
    
    NSMutableArray *bottomBorderLayers;
    
    
}

- (void)setup;
- (void)setupWithInitialization;
- (void) initCell;
- (void) removeBottomBorderLayers;
- (void) addBottomBorderForView:(UIView *)theView;
- (void) adjustViewHeight;

- (void)setupWithPostDetail:(XLCPostDetail *)postDetail PostOwner:(NSString *)postOwner AtIndexPath:(NSIndexPath *)index;
- (CGFloat)getHeight;
- (BOOL) isForIndexPath:(NSIndexPath *)index;

@end
