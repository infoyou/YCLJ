
#import "YCLJUserListViewController.h"
#import "UserListCell.h"
#import "UserModel.h"
#import "HouseFmdbTool.h"
#import "ZTHttpTool.h"

@interface YCLJUserListViewController ()

@end

@implementation YCLJUserListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"测量阶段业主";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSolutionFromDB];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [UserListCell cellHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Trans Data
- (void)loadSolutionFromWeb
{
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:@"0" forKey:@"start_index"];
    [dataDict setObject:@"10" forKey:@"count"];
    
    NSMutableDictionary *paramDict = [CommonUtils getParamDict:dataDict];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/plan/list/", YCLJ_HOST_URL];
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA) {
                         
                         NSArray *resultArray = (NSArray *)[(NSString *)[backDic valueForKey:@"data"] valueForKey:@"record"];
                         
                         NSInteger logicCount = [resultArray count];
                         
                         for (NSInteger productIndex = 0; productIndex < logicCount; productIndex++) {
                             
                             NSMutableDictionary *logicDict = (NSMutableDictionary *)resultArray[productIndex];
                             
                             UserModel *areaModel = [UserModel newWithDict:logicDict];
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
    
    cellDataArray = [HouseFmdbTool queryUserData:nil];
}

- (void)transTableDataInfo
{
    [self loadSolutionFromDB];
    
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
    
    UserListCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:[UserListCell cellID]];
    
    if (cell == nil) {
        
        cell = [[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserListCell cellID]];
    }
    
//    cell.contentView.backgroundColor = HEX_COLOR(VIEW_BG_COLOR);
    
    if ([cellDataArray count] > 0) {
        
        cell.userModel = (UserModel *)cellDataArray[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

@end
