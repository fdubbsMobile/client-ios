//
//  XLCBoardDetailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-8.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardDetailViewController.h"
#import "FRDLivelyButton.h"
#import "EGORefreshTableHeaderView.h"
#import "XLCPostManager.h"
#import "MONActivityIndicatorView.h"
#import "XLCPostSummaryViewCell.h"
#import "XLCPostSummaryInBoard.h"
#import "LoadMoreFooterView.h"
#import "XLCPostDetailPassValueDelegate.h"
#import "XLCActivityIndicator.h"

@interface XLCBoardDetailViewController () <EGORefreshTableHeaderDelegate, LoadMoreFooterDelegate, MONActivityIndicatorViewDelegate>
{
    NSUInteger _boardId;
    NSString *_boardTitle;
    NSString *_boardDesc;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    __block MONActivityIndicatorView *indicatorView;
    
    BOOL _hasMorePost;
    LoadMoreFooterView *_loadMoreFooterView;
    
    __block NSMutableArray *_postSummaryList;
    __block NSUInteger _startPostNum;
    
    NSObject<XLCPostDetailPassValueDelegate> *postDetailPassValueDelegte ;
}


@end

@implementation XLCBoardDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _reloading = NO;
        _hasMorePost = NO;
        _loadMoreFooterView = nil;
        _postSummaryList=nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    //NavBar tint color for elements:
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    FRDLivelyButton *leftBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,25)];
    [leftBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                 kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                 kFRDLivelyButtonColor: [UIColor whiteColor]
                                 }];
    [leftBarButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:NO];
    [leftBarButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    FRDLivelyButton *rightBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,25,20)];
    [rightBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                  kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                  kFRDLivelyButtonColor: [UIColor whiteColor]
                                  }];
    [rightBarButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    //[rightBarButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    self.title = _boardDesc;
    self.titleColor = [UIColor whiteColor];
    
    self.subtitle = [[NSString alloc] initWithFormat:@"%@版", _boardTitle];;
    self.subtitleColor = [UIColor whiteColor];
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 6;
    indicatorView.radius = 15;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
    
    [self addRefreshViewController];
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
    }
    
    [self showOrDismissTableFooterView];
    
    [self performSelector:@selector(initRefreshPostSummaryInBoard) withObject:nil afterDelay:0.1];
    
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}

- (void)initRefreshPostSummaryInBoard
{
    //[self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
    //[self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

-(void)doPullRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_hasMorePost) {
        
        if (!_reloading) {
            NSLog(@"scrollViewDidScroll -- hasMore");
            [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (_hasMorePost) {
        
        if (!_reloading) {
            NSLog(@"scrollViewDidEndDragging -- hasMore");
            [_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
        }
    }
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadData];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

- (void) initAndClearPostSummaryList
{
    if (_postSummaryList == nil) {
        _postSummaryList = [[NSMutableArray alloc] init];
    }
    else {
        [_postSummaryList removeAllObjects];
    }
}

-(void)loadData
{
    _reloading = YES;
    
    void (^successBlock)(XLCPostSummaryInBoard *) = ^(XLCPostSummaryInBoard *postSummaryInBoard)
    {
        
        DebugLog(@"Success to load post summary in board!");
        
        [self initAndClearPostSummaryList];
        
        [_postSummaryList addObjectsFromArray:[postSummaryInBoard postSummaryList]];
        _startPostNum = [postSummaryInBoard startPostNum];
        
        if (_startPostNum > 1)
        {
            _hasMorePost = TRUE;
        }
        else
        {
            _hasMorePost = FALSE;
        }
        
        [self.tableView reloadData];
        
        [self showOrDismissTableFooterView];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        //[indicatorView stopAnimating];
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        //[indicatorView stopAnimating];
        [XLCActivityIndicator hideOnView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCPostManager sharedXLCPostManager] doLoadPostSummaryInBoardWithBoardName:_boardTitle mode:@"topic" successBlock:successBlock failBlock:failBlock];
    //[indicatorView startAnimating];
    [XLCActivityIndicator showLoadingOnView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostSummaryInBoardCell";
    XLCPostSummaryViewCell *cell = (XLCPostSummaryViewCell *)[tableView
                                                                    dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCPostSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCPostSummary *postSummary = [_postSummaryList objectAtIndex:indexPath.row];
    
    [cell setUpWithPostSummary:postSummary AtRow:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_postSummaryList count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        //[refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
        
        _reloading = FALSE;
    }
}

- (void)showOrDismissTableFooterView
{
    if (_hasMorePost) {
        self.tableView.tableFooterView = _loadMoreFooterView;
        self.tableView.tableFooterView.hidden = NO;
    }
    else {
        self.tableView.tableFooterView = nil;
        self.tableView.tableFooterView.hidden = YES;
    }
}

- (void) loadMorePostSummary
{
    NSLog(@"try to load more post summary!");
    _reloading = YES;
    
    
    void (^successBlock)(XLCPostSummaryInBoard *) = ^(XLCPostSummaryInBoard *postSummaryInBoard)
    {
        DebugLog(@"Success to load more post summary!");
        
        [_postSummaryList addObjectsFromArray:[postSummaryInBoard postSummaryList]];
        _startPostNum = [postSummaryInBoard startPostNum];
        
        if (_startPostNum > 1)
        {
            _hasMorePost = TRUE;
        }
        else
        {
            _hasMorePost = FALSE;
        }
        
        [self.tableView reloadData];
        
        [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [self showOrDismissTableFooterView];
        _reloading = NO;
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    NSUInteger startNum = _startPostNum - 20;
    if (startNum < 1) {
        startNum = 1;
    }
    
    [[XLCPostManager sharedXLCPostManager] doLoadPostSummaryInBoardWithBoardName:_boardTitle mode:@"topic" startPostNumber:startNum successBlock:successBlock failBlock:failBlock];
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view {
    
    NSLog(@"loadMoreTableFooterDidTriggerRefresh");
	[self loadMorePostSummary];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view {
    NSLog(@"loadMoreTableFooterDataSourceIsLoading");
	return _reloading;
}


#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void) passValueWithBoardTitle:(NSString *)title description:(NSString *)description boardId:(NSUInteger)boardId
{
    NSLog(@"passValueWithBoardTitle");
    NSLog(@"The value is %@, %@, %lu", title, description, (unsigned long)boardId);
    _boardId = boardId;
    _boardTitle = title;
    _boardDesc = description;
    
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showPostDetail"])
    {
        NSLog(@"showPostDetail");
        NSInteger selectedIdx = [(XLCPostSummaryViewCell *)sender rowIndex];
        XLCPostSummary *selectedPost = [_postSummaryList objectAtIndex:selectedIdx];
        postDetailPassValueDelegte = (NSObject<XLCPostDetailPassValueDelegate> *)destination;
		[postDetailPassValueDelegte passValueWithTitle:selectedPost.metaData.title board:_boardTitle postId:selectedPost.metaData.postId];
	}
}

@end
