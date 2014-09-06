//
//  XLCSectionDetailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-5.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCSectionDetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "FRDLivelyButton.h"
#import "XLCSection.h"
#import "XLCBoardMetaData.h"
#import "XLCBoardDetail.h"
#import "XLCBoardManager.h"
#import "XLCBoardViewCell.h"
#import "XLCBoardDetailPassValueDelegate.h"
#import "XLCActivityIndicator.h"

@interface XLCSectionDetailViewController () <EGORefreshTableHeaderDelegate>
{
    NSString *_desc;
    NSString *_category;
    NSString *_sectionId;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSObject<XLCBoardDetailPassValueDelegate> *boardDetailPassValueDelegte ;

}

@property  __block XLCSection *section;

@end

@implementation XLCSectionDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _desc = nil;
        _category = nil;
        _sectionId = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRefreshViewController];
    
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
    
    
    self.title = _desc;
    self.titleColor = [UIColor whiteColor];
    
    self.subtitle = _category;
    self.subtitleColor = [UIColor whiteColor];
    
    
    [self performSelector:@selector(initRefreshAllBoardsInSection) withObject:nil afterDelay:0.1];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRefreshAllBoardsInSection
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
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
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
    
    void (^successBlock)(XLCSection *) = ^(XLCSection *section)
    {
        _section = section;
        DebugLog(@"Success to load section!");
        
        [self.tableView reloadData];
        
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
    
    [[XLCBoardManager sharedXLCBoardManager] doLoadAllBoardsInSection:_sectionId successBlock:successBlock failBlock:failBlock];
    //[indicatorView startAnimating];
    [XLCActivityIndicator showLoadingOnView:self.view];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (_section == nil) {
        return 0;
    }
    
    return [_section.boards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"boardsInSectionCell";
    XLCBoardViewCell *cell = (XLCBoardViewCell *)[tableView
                                                      dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCBoardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    XLCBoardDetail *boardDetail = (XLCBoardDetail *)[_section.boards objectAtIndex:indexPath.row];
    XLCBoardMetaData *boardMetaData = boardDetail.metaData;
    [[cell description] setText:boardMetaData.boardDesc];
    [[cell title] setText:boardMetaData.title];
    cell.index = indexPath.row;
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




-(void) passValueWithSectionDesc:(NSString *)sectionDesc category:(NSString *)category sectionId:(NSString *)sectionId
{
    NSLog(@"The value is %@, %@, %@", sectionDesc, category, sectionId);
    _desc = sectionDesc;
    _category = category;
    _sectionId = sectionId;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showBoardDetail"])
    {
        NSLog(@"showBoardDetail");
        NSInteger selectedIdx = [(XLCBoardViewCell *)sender index];
        XLCBoardDetail *boardDetail = (XLCBoardDetail *)[_section.boards objectAtIndex:selectedIdx];
        XLCBoardMetaData *boardMetaData = boardDetail.metaData;
        boardDetailPassValueDelegte = (NSObject<XLCBoardDetailPassValueDelegate> *)destination;
		[boardDetailPassValueDelegte passValueWithBoardTitle:boardMetaData.title description:boardMetaData.boardDesc boardId:boardMetaData.boardId];
	}
}

@end
