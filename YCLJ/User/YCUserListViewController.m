
#import "YCUserListViewController.h"
#import "YCUserListCell.h"
#import "YCOwnerModel.h"
#import "YCHouseFmdbTool.h"
#import "YCAppManager.h"
#import "YCHouseListViewController.h"

@interface YCUserListViewController ()

@end

@implementation YCUserListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self adjustView];
    
    self.title = @"测量阶段业主";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [YCUserListCell cellHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)transTableDataInfo
{
    [self loadSolutionFromWeb];
    
    [super loadCellDataDone];
}

- (void)loadCellDataDone
{
    
    [super loadCellDataDone];
    
    if (pageIndex == 1) {
        [self scrollingToTopPosition];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cellDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YCUserListCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:[YCUserListCell cellID]];
    
    if (cell == nil) {
        
        cell = [[YCUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YCUserListCell cellID]];
    }
    
//    cell.contentView.backgroundColor = HEX_COLOR(VIEW_BG_COLOR);
    
    if ([cellDataArray count] > 0) {
        
        cell.userModel = (YCOwnerModel *)cellDataArray[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    YCOwnerModel *userModel = (YCOwnerModel *)cellDataArray[indexPath.row];
    
    // 存储本地数据库
    [[YCAppManager instance] saveLocalOwnerData:userModel];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    /** 户型列表 */
    YCHouseListViewController *solutionListVC = [[YCHouseListViewController alloc] init];
    [self.navigationController pushViewController:solutionListVC animated:YES];
}

#pragma mark - 业主列表
- (void)loadSolutionFromWeb
{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[YCAppManager instance].workId forKey:@"chief_id"];
    [paramDict setObject:@(pageIndex) forKey:@"page"];
    [paramDict setObject:@"20" forKey:@"page_size"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/owner/list/", YC_HOST_URL];

    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA) {
                         
                         NSArray *resultArray = (NSArray *)[backDic valueForKey:@"data"];
                         
                         if ([resultArray isEqual:@""]) {
                             return;
                         }
                         
                         NSInteger logicCount = [resultArray count];
                         
                         for (NSInteger productIndex = 0; productIndex < logicCount; productIndex++) {
                             
                             NSMutableDictionary *logicDict = (NSMutableDictionary *)resultArray[productIndex];
                             
                             YCOwnerModel *areaModel = [YCOwnerModel newWithDict:logicDict];
                             [cellDataArray addObject:areaModel];
                         }
                         
                         [self loadCellDataDone];
                     } else if ([errCodeStr integerValue] == NO_MORE_DATA) {
                         [self loadCellDataDone];
                     } else {
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 } else {
                     //[self showHUDWithText:LocaleStringForKey(NSReturnDataIsEmpty, nil)];
                     [self isNeedShowEmptyView];
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
                 [self endRefreshingView];
                 //[self showHUDWithText:@"请检查网络设置。"];
             }];
}

- (void)loadSolutionFromDB
{
    
    cellDataArray = [YCHouseFmdbTool queryOwnerData:nil];
}

@end
