//
//  BaseTableViewController.m
//  
//
//  Created by Adam on 15/7/29.
//  Copyright (c) 2015年 fule. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation BaseTableViewController
@synthesize mTableView;

- (void)viewDidLoad {
    
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    self.mTableView.backgroundColor = TRANSPARENT_COLOR;
    self.mTableView.separatorColor = TRANSPARENT_COLOR;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [self.view addSubview:self.mTableView];
    
//    [self adjustView];
    
    [super viewDidLoad];
}

- (void)addTapStatus
{
    
    self.mTableView.scrollsToTop = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self addTapStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

- (void)setTablePage
{
    pageIndex = 1;
    pageCount = 10;
}

- (void)adjustView
{
    
    mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // Enter the refresh status immediately
    [mTableView.mj_header beginRefreshing];
    
    mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

- (void)hiddenFooter
{
    
//    mTableView.footer.alpha = 0.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabHeadView
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  // 取消选中
    
    selIndexPath = indexPath;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, 9)];
    
    headView.backgroundColor = HEX_COLOR(VIEW_BG_COLOR);
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

#pragma mark - UITableViewDataSource method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([cellDataArray count] == 0) {
        return 0;
    } else {
        return [cellDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - scroll table

- (void)scrollingToTopPosition
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mTableView scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
}

- (void)transTableDataInfo
{
    // Request TableView List Data
}

#pragma mark - Load Cell Data

- (void)clearTableData
{
    if (cellDataArray != nil &&
        [cellDataArray count] > 0) {
        
        [cellDataArray removeAllObjects];
    } else {
        
        cellDataArray = [NSMutableArray array];
    }
}

- (void)loadNewDataDone
{
    // 刷新表格
    [mTableView reloadData];
    
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.mTableView.mj_header endRefreshing];
}

- (void)loadMoreDataDone
{
    // 刷新表格
    [mTableView reloadData];
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.mTableView.mj_footer endRefreshing];
}

- (void)endRefreshingView
{
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.mTableView.mj_header endRefreshing];
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.mTableView.mj_footer endRefreshing];
}

- (void)loadNewData
{
    NSLog(@"load New Data");
    [self setTablePage];
    
    [self clearTableData];
    
    [self transTableDataInfo];
}

- (void)loadMoreData
{
    pageIndex ++;
    NSLog(@"load More Data");
    [self transTableDataInfo];
}

- (void)loadCellDataDone
{
    
    if(pageIndex > 1) {
        [self loadMoreDataDone];
    } else {
        [self loadNewDataDone];
    }
    
}

#pragma mark - is Need Show Empty View
- (void)isNeedShowEmptyView
{
    
    
}

#pragma mark - 处理上拉显示NaviBar，下拉隐藏NaviBar
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Do your action here
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    static CGFloat lastY = 0;
    
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat headerHeight = self.mTableView.tableHeaderView.frame.size.height;
    
    if ((lastY <= headerHeight) && (currentY > headerHeight)) {
        NSLog(@" ******* Header view just disappeared");
//        [self setDefaultStatusAndNavi];
    }
    
    if ((lastY > headerHeight) && (currentY <= headerHeight)) {
        NSLog(@" ******* Header view just appeared");
//        [self setCoustomStatusAndNavi];
    }
    
    lastY = currentY;
}

#pragma mark － 无网络时点击事件
- (void)btnNoNetWorkClicked:(id)sender
{
    
    [self transTableDataInfo];
}

@end
