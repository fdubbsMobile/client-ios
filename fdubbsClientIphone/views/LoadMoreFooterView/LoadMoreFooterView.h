//
//  LoadMoreFooterView.h
//  iKaka
//
//  Created by Eric.Wang on 13-1-1.
//
//

#define USE_MODIFIED_VERSION

#ifdef USE_MODIFIED_VERSION
//Modify by  wangyx810328 http://blog.csdn.net/wangyx810328/article/details/9033733
// LoadMoreFooterView.h
#import <UIKit/UIKit.h>

typedef enum{
	LoadMorePulling = 0,
	LoadMoreNormal,
	LoadMoreLoading,
} LoadMoreState;

@protocol LoadMoreFooterDelegate;
@interface LoadMoreFooterView : UIView
{
    id _delegate;
}

@property(nonatomic,retain) id<LoadMoreFooterDelegate> delegate;
@property(nonatomic,retain) UIButton *statusButton;
@property(nonatomic,retain) UIActivityIndicatorView *activityView;
@property(nonatomic,assign) LoadMoreState state;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)showMore;

@end

@protocol LoadMoreFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view;
@end


#else

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

typedef enum{
    LoadMorePulling = 3,
    LoadMoreNormal = 4,
    LoadMoreLoading = 5,
} LoadMoreState;

typedef enum
{
    REQUESTTYPENORMAL = 0,
    REQUESTTYPELOADMORE = 1
}REQUESTTYPE;

@protocol  LoadMoreFooterViewDelegate;

@interface LoadMoreFooterView : UIView
{
    LoadMoreState _state;
    
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(assign, nonatomic) id<LoadMoreFooterViewDelegate> delegate;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)loadMoreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)loadMoreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end

@protocol LoadMoreFooterViewDelegate <NSObject>
  @optional
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view;

@end

#endif