//
//  XLCPostDetailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

#import "XLCPostDetailViewController.h"
#import "XLCPostDetail.h"
#import "XLCPostManager.h"

#import "XLCPostDetailViewCell.h"
#import "FRDLivelyButton.h"
#import "LoadMoreFooterView.h"

@interface XLCPostDetailViewController () <EGORefreshTableHeaderDelegate, LoadMoreFooterDelegate> {
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSString *_title;
    NSString *_postId;
    NSString *_board;
    
    XLCPostDetail *_postDetail;
    
    BOOL _hasMorePost;
    NSString *_boardId;
    NSString *_lastReplyId;
    NSMutableArray *_replies;
    LoadMoreFooterView *_loadMoreFooterView;
}

@end

@implementation XLCPostDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _refreshHeaderView = nil;
        _postDetail = nil;
        _reloading = NO;
        _hasMorePost = NO;
        _lastReplyId = nil;
        _boardId = nil;
        _replies = nil;
        _loadMoreFooterView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRefreshViewController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];

    
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
    
    
    //NavBar tint color for elements:
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.title = _title;
    self.subtitle = [[NSString alloc] initWithFormat:@"%@版", _board];
    self.titleColor = [UIColor whiteColor];
    self.subtitleColor = [UIColor whiteColor];
    
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        _loadMoreFooterView.delegate = self;
    }
    
    [self showOrDismissTableFooterView];
    
    DebugLog(@"init XLCPostDetailViewController");
    [self performSelector:@selector(initRefreshPostDetail) withObject:nil afterDelay:0.4];
    
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

- (void) initAndClearReplies
{
    if (_replies == nil) {
        _replies = [[NSMutableArray alloc] init];
    }
    else {
        [_replies removeAllObjects];
    }
}

-(void)loadData
{
    _reloading = YES;
    
    
    void (^successBlock)(XLCPostDetail *) = ^(XLCPostDetail *postDetail)
    {
        DebugLog(@"Success to load post detail!");
        
        _postDetail = postDetail;
        _boardId = postDetail.reply.boardId;
        _hasMorePost = postDetail.reply.hasMore;
        _lastReplyId = postDetail.reply.lastReplyId;
        
        [self initAndClearReplies];
        [_replies addObjectsFromArray:postDetail.reply.replies];
        
        [self.tableView reloadData];
        
        DebugLog(@"post id : %@", postDetail.metaData.postId);
        DebugLog(@"post owner : %@", postDetail.metaData.owner);
        DebugLog(@"post title : %@", postDetail.metaData.title);
        
        [self showOrDismissTableFooterView];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCPostManager sharedXLCPostManager] doLoadPostDetailWithBoard:_board postId:_postId successBlock:successBlock failBlock:failBlock];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_postDetail == nil) {
        return 0;
    }
    
    return _replies.count + 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [cell getHeight];

    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = nil;
    if (indexPath.row == 0) {
        CellIdentifier = @"MainPostViewCell";
    } else {
        //NSInteger mod = indexPath.row % 20;
        //CellIdentifier = [[NSString alloc] initWithFormat:@"PostReplyViewCell_%ld", (long)mod];
        CellIdentifier = @"PostReplyViewCell";
    }
    
    XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSLog(@"No reusablecell for %@", CellIdentifier);
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"XLCPostReplyViewCell" owner:self options:nil];
        cell = (XLCPostDetailViewCell *)[nibArray objectAtIndex:0];
        
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (![cell isForIndexPath:indexPath]) {

        [cell setupWithInitialization];
        

        XLCPostDetail *postDetail = nil;
        NSString *postOwner = _postDetail.metaData.owner;
        
        if (indexPath.row > 0) {
            postDetail = [_replies objectAtIndex:(indexPath.row - 1)];
        }
        else {
            postDetail = _postDetail;
        }
        
        [cell setupWithPostDetail:postDetail PostOwner:postOwner AtIndexPath:indexPath];
        
    }
    
    
    
    return cell;
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        [refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
    }
}

- (void)initRefreshPostDetail
{
    [self.tableView setContentOffset:CGPointMake(0, -150) animated:YES];
    [self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
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

- (void) loadMoreReplies
{
    NSLog(@"try to load more replies!");
    _reloading = YES;
    
    
    void (^successBlock)(XLCPostReplies *) = ^(XLCPostReplies *postReplies)
    {
        DebugLog(@"Success to load more replies!");
        
        _hasMorePost = postReplies.hasMore;
        _lastReplyId = postReplies.lastReplyId;
        
        [_replies addObjectsFromArray:postReplies.replies];
        
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
    
    [[XLCPostManager sharedXLCPostManager] doLoadMorePostRepliesWithBoardId:_boardId mainPostId:_postId lastReplyId:_lastReplyId successBlock:successBlock failBlock:failBlock];
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view {
    
    NSLog(@"loadMoreTableFooterDidTriggerRefresh");
	[self loadMoreReplies];
	//[self performSelector:@selector(loadMoreReplies) withObject:nil afterDelay:0.4];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view {
    NSLog(@"loadMoreTableFooterDataSourceIsLoading");
	return _reloading;
}


-(void) passValueWithTitle:(NSString *)title Board:(NSString *)board postId:(NSString *)postId
{
    NSLog(@"The value is %@, %@ , %@", title, board, postId);
    _title = title;
    _board = board;
    _postId = postId;
}

@end
