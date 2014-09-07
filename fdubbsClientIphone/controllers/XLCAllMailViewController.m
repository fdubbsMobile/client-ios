//
//  XLCAllMailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-6.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCAllMailViewController.h"
#import "FRDLivelyButton.h"
#import "XLCMailManager.h"
#import "XLCMailSummary.h"
#import "XLCMailSummaryInBox.h"
#import "XLCMailSummaryViewCell.h"
#import "XLCMailDetailPassValueDelegate.h"
#import "XLCActivityIndicator.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreFooterView.h"

@interface XLCAllMailViewController () <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, LoadMoreFooterDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    __block BOOL _reloading;
    
    __block NSMutableArray *_mailList;
    
    __block NSUInteger _startNumber;
    __block XLCMailSummaryInBox *_mailSummaryInbox;
    
    __block BOOL _hasMoreMail;
    LoadMoreFooterView *_loadMoreFooterView;
    
    NSObject<XLCMailDetailPassValueDelegate> *mailDetailPassValueDelegte ;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XLCAllMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mailList = nil;
        _startNumber = 0;
        _mailSummaryInbox = nil;
        _reloading = NO;
        _hasMoreMail = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self addRefreshViewController];
    [self addLoadMoreViewController];
    
    [self showOrDismissTableFooterView];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
    
}

-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        //[refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_hasMoreMail) {
        
        if (!_reloading) {
            NSLog(@"scrollViewDidScroll -- hasMore");
            [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (_hasMoreMail) {
        
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


-(void)loadData
{
    
    _reloading = YES;
    
    // load all mails
    
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [XLCActivityIndicator hideOnView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    
    
    void (^successBlock)(XLCMailSummaryInBox *) = ^(XLCMailSummaryInBox *mailSummaryInbox)
    {
        
        DebugLog(@"Success to load all mails!");
        _mailSummaryInbox = mailSummaryInbox;
        _startNumber = mailSummaryInbox.startMailNum;
        
        _mailList = [[NSMutableArray alloc] initWithArray:mailSummaryInbox.mailSummaryList];
        
        if (mailSummaryInbox.startMailNum > 1) {
            _hasMoreMail = YES;
        } else {
            _hasMoreMail = NO;
        }
        
        [self.tableView reloadData];
        
        [self showOrDismissTableFooterView];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    [[XLCMailManager sharedXLCMailManager] doLoadAllMailsInBoxWithStartNumber:0 successBlock:successBlock failBlock:failBlock];
    [XLCActivityIndicator showLoadingOnView:self.view];
    
    
    
}

- (void) addLoadMoreViewController
{
    if (_loadMoreFooterView ==nil) {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _loadMoreFooterView.delegate = self;
    }
    
}

- (void)showOrDismissTableFooterView
{
    if (_hasMoreMail) {
        self.tableView.tableFooterView = _loadMoreFooterView;
        self.tableView.tableFooterView.hidden = NO;
    }
    else {
        self.tableView.tableFooterView = nil;
        self.tableView.tableFooterView.hidden = YES;
    }
}

- (void) loadMoreMails
{
    NSLog(@"try to load more mails!");
    _reloading = YES;
    
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
    
    
    
    void (^successBlock)(XLCMailSummaryInBox *) = ^(XLCMailSummaryInBox *mailSummaryInbox)
    {
        
        DebugLog(@"Success to load all mails!");
        _mailSummaryInbox = mailSummaryInbox;
        _startNumber = mailSummaryInbox.startMailNum;
        
        [_mailList addObjectsFromArray:mailSummaryInbox.mailSummaryList];
        
        if (mailSummaryInbox.startMailNum > 1) {
            _hasMoreMail = YES;
        } else {
            _hasMoreMail = NO;
        }
        
        [self.tableView reloadData];
        
        [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [self showOrDismissTableFooterView];
        _reloading = NO;
    };
    
    if (_startNumber > 20) {
        [[XLCMailManager sharedXLCMailManager] doLoadAllMailsInBoxWithStartNumber:(_startNumber - 20) successBlock:successBlock failBlock:failBlock];
    } else {
        [[XLCMailManager sharedXLCMailManager] doLoadAllMailsInBoxWithStartNumber:1 mailCountInPage:(_startNumber - 19) successBlock:successBlock failBlock:failBlock];
    }
    
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view {
    
    NSLog(@"loadMoreTableFooterDidTriggerRefresh");
	[self loadMoreMails];
	//[self performSelector:@selector(loadMoreReplies) withObject:nil afterDelay:0.4];
    
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view {
    NSLog(@"loadMoreTableFooterDataSourceIsLoading");
	return _reloading;
}

- (XLCMailSummary *)getMailSummaryByIndex:(NSUInteger)index
{
    return [_mailList objectAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mailViewCell";
    XLCMailSummaryViewCell *cell = (XLCMailSummaryViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCMailSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCMailSummary *mailSummary = [self getMailSummaryByIndex:indexPath.row];
    
    XLCMailMetaData *metaData = mailSummary.mailMetaData;
    //[[cell textLabel] setText:[[mailSummary mailMetaData] title]];
    [[cell senderLabel] setText:[metaData sender]];
    [[cell dateLabel] setText:[metaData date]];
    [[cell titleLabel] setText:[metaData title]];
    cell.index = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_mailList count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showMailDetail"])
    {
        NSLog(@"showMailDetail");
        NSInteger selectedIdx = [(XLCMailSummaryViewCell *)sender index];
        XLCMailSummary *mailSummary = [self getMailSummaryByIndex:selectedIdx];
        XLCMailMetaData *metaData = mailSummary.mailMetaData;
        mailDetailPassValueDelegte = (NSObject<XLCMailDetailPassValueDelegate> *)destination;
        [mailDetailPassValueDelegte passValueWithMailNumber:metaData.mailNumber mailLink:metaData.mailLink];
    }
}


@end
