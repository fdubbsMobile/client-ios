//
//  LoadMoreFooterView.m
//  iKaka
//
//  Created by Eric.Wang on 13-1-1.
//
//
#import "LoadMoreFooterView.h"



#ifdef USE_MODIFIED_VERSION

@interface LoadMoreFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreFooterView
@synthesize delegate = _delegate;
@synthesize statusButton = _statusButton;
@synthesize activityView = _activityView;
@synthesize state = _state;

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	//[_statusButton release];
	//[_activityView release];
    
    //[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
        
        _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f)];
        //UIButton *showbtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_statusButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        [self addSubview:_statusButton];
        
		_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(50.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
		
		[self setState:LoadMoreNormal];
    }
	
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{
	switch (aState) {
		case LoadMorePulling:
            [_statusButton setTitle:NSLocalizedString(@"松开加载更多", @"松开加载更多") forState:UIControlStateNormal];
			break;
		case LoadMoreNormal:
            [_statusButton setTitle:NSLocalizedString(@"上拉加载更多", @"上拉加载更多") forState:UIControlStateNormal];
			[_activityView stopAnimating];
			break;
		case LoadMoreLoading:
            [_statusButton setTitle:NSLocalizedString(@"加载中...", @"加载中") forState:UIControlStateNormal];
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == LoadMoreLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
		}
		
		if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
			[self setState:LoadMorePulling];
		} else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
			[self setState:LoadMoreNormal];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height-30)) && !_loading) {
        [self setState:LoadMoreLoading];
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
			[_delegate loadMoreTableFooterDidTriggerRefresh:self];
		}
	}
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[self setState:LoadMoreNormal];
}

- (void)showMore{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
    
    if (YES == _loading) return;
    
    [self setState:LoadMoreLoading];
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
        [_delegate loadMoreTableFooterDidTriggerRefresh:self];
    }
    
}

@end

#else



#define  LoadMoreViewHight 60.0f
#define TEXT_COLOR   [UIColor darkGrayColor]
#define FLIP_ANIMATION_DURATION 0.18f

@interface LoadMoreFooterView (Private)

- (void)setState:(LoadMoreState)aState;

@end

@implementation LoadMoreFooterView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, LoadMoreViewHight - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        [label release];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, LoadMoreViewHight - LoadMoreViewHight, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
//        layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(25.0f, LoadMoreViewHight - 38.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        [view release];
        
        
        [self setState:LoadMoreNormal];
    }
    return self;
}

- (void)setState:(LoadMoreState)aState{
    
    switch (aState) {
        case LoadMorePulling:
            _statusLabel.text = NSLocalizedString(@"松开即可加载更多...", @"松开即可加载更多...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case LoadMoreNormal:
            if (_state == LoadMorePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"上拉即可加载更多...", @"上拉即可加载更多...");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            break;
        case LoadMoreLoading:
            _statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;
        default:
            break;
    }
    _state = aState;
}



#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_state == LoadMoreLoading) {
        
        //CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        //offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, LoadMoreViewHight, 0.0f);
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        
        if (_state == LoadMorePulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + LoadMoreViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
            [self setState:LoadMoreNormal];
        } else if (_state == LoadMoreNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + LoadMoreViewHight  && !_loading) {
            [self setState:LoadMorePulling];
        }
        
        if (scrollView.contentInset.bottom != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
    
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)loadMoreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + LoadMoreViewHight && !_loading) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
        
        [self setState:LoadMoreLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LoadMoreViewHight, 0.0f);
        [UIView commitAnimations];
        
    }
    
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)loadMoreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:LoadMoreNormal];
    
}
#pragma mark -
#pragma mark Dealloc


- (void)dealloc {
    
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    //_lastUpdatedLabel = nil;
    [super dealloc];
}

@end

#endif