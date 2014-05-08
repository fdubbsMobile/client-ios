//
//  XLCPostDetailViewCell.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-26.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostDetailViewCell.h"
#import "XLCParagraph.h"
#import "XLCParagraphContent.h"


#import "NIAttributedLabel.h"
#import "XLCCustomLinkView.h"

#define INITIAL_HEIGHT 30

@interface XLCPostDetailViewCell ()
{
    BOOL hasInitialied;
    BOOL hasQuote;
    CGFloat heightOfCell;
    
    NSInteger section;
    NSInteger row;
    
    NIAttributedLabel *postContentLabel;
    NSMutableArray *bottomBorderLayers;
}
@end

@implementation XLCPostDetailViewCell

- (id)init
{
    NSLog(@"XLCPostDetailViewCell init");
    self = [super init];
    if (self) {
        [self initCell];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCell];
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initCell];
}

- (void) initCell
{
    hasInitialied = FALSE;
    hasQuote = FALSE;
    heightOfCell = INITIAL_HEIGHT;
    
    section = -1;
    row = -1;
    
    postContentLabel = nil;
    bottomBorderLayers = [[NSMutableArray alloc] init];
}

- (void)setupWithInitialization
{
    if (hasInitialied == TRUE) {
        [self removeBottomBorderLayers];
        return;
    }
    
    //NSLog(@"Init setupWithInitialization");
    [self setup];
}


- (void)setup
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.backgroundColor = [UIColor whiteColor];
    
    /*
    UIImage *stretchableImage = [[UIImage imageNamed:@"quoteBackground"]
                                 stretchableImageWithLeftCapWidth:130 topCapHeight:14];
    self.qouteBgView = [[UIImageView alloc] initWithImage:stretchableImage];
    self.qouteView = [[UIView alloc] initWithFrame:CGRectInset(bounds, 10.0f, 0)];
    [self.qouteView addSubview:self.qouteBgView];
    //[self.qouteView setBackgroundColor:[UIColor redColor]];
    */
    //[self addSubview:self.qouteView];
    
    
    
    hasQuote = FALSE;
    hasInitialied = TRUE;
}

- (void)setupWithPostDetail:(XLCPostDetail *)postDetail
                    isReply:(BOOL)isReply AtIndexPath:(NSIndexPath *)index
{
    heightOfCell = INITIAL_HEIGHT;
    section = index.section;
    row = index.row;
    
    [self constructPostMetadata:postDetail isReply:isReply];
    
    [self constructPostContent:postDetail];
    
    heightOfCell += self.postMetadataView.frame.size.height;
    heightOfCell += self.postContentView.frame.size.height;
    /*
    if (postDetail.qoute.count > 0) {
        hasQuote = TRUE;
        NSLog(@"has qoute");
        // add qoute content
        
        heightOfCell += self.qouteView.frame.size.height;
    } else {
        NSLog(@"no qoute");
        self.qouteView.hidden = YES;
    }
    */
    
    [self adjustViewHeight];
    //[self addBottomBorderForView:self.postMetadataView];
    [self addBottomBorderForView:self];
    
    
    
    NSLog(@"height is %f", [self getHeight]);
}

#pragma mark Load Post Metadata
- (void)constructPostMetadata:(XLCPostDetail *)postDetail isReply:(BOOL)isReply
{
    self.ownerLabel.text = postDetail.metaData.owner;
    self.dateLabel.text = postDetail.metaData.date;
    
    if (isReply) {
        //self.titleLabel.hidden = YES;
        [self.titleLabel removeFromSuperview];
        CGRect metadataFrame = self.postMetadataView.frame;
        metadataFrame.size.height -= self.titleLabel.frame.size.height;
        self.postMetadataView.frame = metadataFrame;
    } else {
        
        self.titleLabel.text = postDetail.metaData.title;
    }
}

#pragma mark Load Post Content

- (void)constructPostContent:(XLCPostDetail *)postDetail
{
    NSLog(@"constructPostContent");
    
    NSArray *paragraphs = postDetail.body;
    
    
    NSString *postContent = [[NSString alloc] init];
    for (XLCParagraph *paragraph in paragraphs) {
        NSArray *contents = paragraph.paraContent;
        for (XLCParagraphContent *content in contents) {
            if (content.isNewLine) {
                postContent = [postContent stringByAppendingString:@"\n"];
            }
            else if (content.isImage) {
                XLCCustomLinkView *imageLinkView = [[XLCCustomLinkView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
                [imageLinkView updateWithString:@"图片链接"];
                [postContentLabel insertSubview:imageLinkView atIndex:[postContent length]];
            }
            else if (content.isLink) {
                NSLog(@"link ref : %@", content.linkRef);
                postContent = [postContent stringByAppendingString:content.linkRef];
            }
            else {
                NSLog(@"post content : %@", content.content);
                postContent = [postContent stringByAppendingString:content.content];
            }
        }
        postContent = [postContent stringByAppendingString:@"\n"];
    }
    
    NSLog(@"Post Content : \n%@", postContent);
    
    postContentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
    postContentLabel.numberOfLines = 0;
    postContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    postContentLabel.font = [UIFont systemFontOfSize:15];
    postContentLabel.text = postContent;
    
    NSLog(@"text length : %d", postContentLabel.text.length);
    XLCCustomLinkView *imageLinkView = [[XLCCustomLinkView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [imageLinkView updateWithString:@"图片链接"];
    [postContentLabel insertView:imageLinkView atIndex:0];
    
    [self.postContentView addSubview:postContentLabel];
    
    CGSize size = [postContentLabel sizeThatFits:CGSizeMake(self.postContentView.bounds.size.width, CGFLOAT_MAX)];
    NSLog(@"lable size : width = %f, height = %f", size.width, size.height);
    postContentLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGRect contentFrame = self.postContentView.frame;
    contentFrame.size.height = postContentLabel.frame.size.height;
    self.postContentView.frame = contentFrame;
}


- (void) adjustViewHeight
{
    /*
    if (hasQuote) {
        CGRect qouteFrame = self.qouteView.frame;
        qouteFrame.origin.y = self.postContentView.frame.origin.y +
        self.postContentView.frame.size.height + 5;
        self.qouteView.frame = qouteFrame;
    }
    */
    CGRect cellFrame = self.frame;
    cellFrame.size.height = [self getHeight];
    self.frame = cellFrame;
}

- (void) addBottomBorderForView:(UIView *)theView
{
    CALayer *bottomBorder = [CALayer layer];
    float height = theView.frame.size.height - 1.0f;
    float width = theView.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [theView.layer addSublayer:bottomBorder];
    
    [bottomBorderLayers addObject:bottomBorder];
}

- (void) removeBottomBorderLayers
{
    for (CALayer *bottomBorder in bottomBorderLayers) {
        [bottomBorder removeFromSuperlayer];
    }
    
    [bottomBorderLayers removeAllObjects];
}




- (CGFloat)getHeight
{
    return heightOfCell;
}

- (BOOL) isForIndexPath:(NSIndexPath *)index
{
    return section == index.section && row == index.row;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
