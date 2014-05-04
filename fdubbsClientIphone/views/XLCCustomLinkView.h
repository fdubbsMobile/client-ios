//
//  XLCCustomLinkView.h
//  DWTagList
//
//  Created by dennis on 14-5-4.
//  Copyright (c) 2014年 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCCustomLinkView : UIView

@property (nonatomic, strong) UIButton              *button;
@property (nonatomic, strong) UILabel               *label;

- (void)updateWithString:(NSString*)text;
- (void)setLabelText:(NSString*)text;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(CGColorRef)borderColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)setTextColor:(UIColor*)textColor;
- (void)setTextShadowColor:(UIColor*)textShadowColor;
- (void)setTextShadowOffset:(CGSize)textShadowOffset;

@end
