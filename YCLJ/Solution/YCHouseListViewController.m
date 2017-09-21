//
//  YCHouseListViewController.m
//  Pods
//
//  Created by Adam on 2017/6/16.
//
//

#import "YCHouseListViewController.h"
#import "YCSendResultViewController.h"
#import "YCHouseObject.h"
#import "YCHouseListCell.h"
#import "YCAlertViewExtension.h"
#import "Nonetwork.h"

#import "LFDrawManager.h"
#import "YCAppManager.h"

#import "YCOwnerModel.h"
#import "YCHouseFmdbTool.h"
#import "YCHouseOwnerView.h"

@interface YCHouseListViewController () <HouseListCellDelegate,YCAlertviewExtensionDelegate, HouseListOwnerViewDelegate>
{
    YCAlertViewExtension *alert;
}

@property (nonatomic, strong) YCHouseModel *houseModel;
@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) NSMutableDictionary *userSolutionCountDict;
@property (nonatomic, strong) NSMutableDictionary *resultDict;
@property (nonatomic, strong) NSMutableDictionary *resultFormDict;
@property (nonatomic, assign) NSInteger userCount;

@end

@implementation YCHouseListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadSolutionFromDB];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"方案列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [self checkNetAvailable];
}

- (void)checkNetAvailable
{
    Nonetwork *Nonet = [[Nonetwork alloc] initWithFrame:[UIScreen mainScreen].bounds];
    Nonet.Prompt=@"无法连接服务器，请检查你的网络设置";
    Nonet.typeDisappear=1;
    [Nonet popupWarningview];
    Nonet.returnsAnEventBlock = ^{
        NSLog(@"重新加载数据");
    };
    
    [self.view addSubview:Nonet];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCHouseObject *houseObject = [self getCellHouseObject:indexPath.section
                                                      row:indexPath.row];
    
    return houseObject.cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Trans Data
- (void)loadSolutionFromWeb
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/chief/detail/%@", YC_HOST_URL, [YCAppManager instance].workId];
    
    [ZTHttpTool get:urlStr
             params:nil
            success:^(id json) {
                
                NSDictionary *backDic = json;
                
                if (backDic != nil) {
                    
                    NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                    
                    if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                        
                        NSDictionary *resultDict = [backDic valueForKey:@"data"];
                        
                        // owner
                        NSArray *ownerDictArray = (NSArray *)[resultDict valueForKey:@"owner_list"];
                        NSInteger ownerCount = ownerDictArray.count;
                        
                        NSMutableArray *ownerArray = [NSMutableArray arrayWithCapacity:ownerCount];
                        NSMutableArray *ownerHouseArray = [NSMutableArray array];
                        
                        for (NSInteger i=0; i<ownerCount; i++) {
                            
                            NSMutableDictionary *ownerDict = (NSMutableDictionary *)ownerDictArray[i];
                            YCOwnerModel *ownerModel = [YCOwnerModel newWithDict:ownerDict];
                            
                            // house
                            NSArray *houseDictArray = (NSArray *)[ownerDict valueForKey:@"house_list"];
                            NSInteger houseCount = houseDictArray.count;
                            
                            NSMutableArray *houseArray = [NSMutableArray arrayWithCapacity:houseCount];
                            for (NSInteger j=0; j<houseCount; j++) {
                                
                                NSMutableDictionary *houseDict = (NSMutableDictionary *)houseDictArray[j];
                                YCHouseModel *houseModel = [YCHouseModel newWithDict:houseDict];
                                [ownerHouseArray addObject:houseModel];
                                
                                [houseArray addObject:houseModel];
                            }
                            
                            [ownerArray addObject:ownerModel];
                        }
                        
                        [YCHouseFmdbTool insertOwnerArrayModel:ownerArray];
                        [YCHouseFmdbTool insertOwnerHouseArrayModel:ownerHouseArray];
                        
                        NSLog(@"over");
                    } else {
                        
                        NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                        //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败-%@", error);
            }];
}

- (void)loadSolutionFromDB
{
    
    [self loadSolutionFromWeb];
    
    // 从数据库读取
    NSTimeInterval currentTimeDouble = [ZTCommonUtils currentTimeIntervalDouble];
     _userArray = [YCHouseFmdbTool queryOwnerData:nil];
     _userCount = [_userArray count];
     _userSolutionCountDict = [YCHouseFmdbTool queryOwnerSolutionNumber];
     _resultDict = [YCHouseFmdbTool queryAllSolutionData:nil];
     _resultFormDict = [NSMutableDictionary dictionary];
     
     for (NSString *key in _resultDict) {
     
         YCHouseModel *houseModel = _resultDict[key];
         YCHouseObject *houseObject = [[YCHouseObject alloc] init];
         houseObject.houseModel = houseModel;
         
         [_resultFormDict setValue:houseObject forKey:key];
     }
    
    NSLog(@"从数据库读取 use time: %f", [ZTCommonUtils currentTimeIntervalDouble] - currentTimeDouble);
    
    [self loadCellDataDone];
}

- (void)transTableDataInfo
{
    //    [self loadSolutionFromDB];
}

- (void)loadCellDataDone
{
    
    [super loadCellDataDone];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_userCount > 0) {
        return _userCount;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger sectionCount = 0;
    
    if (_userCount > 0) {
        
        YCOwnerModel *userModel = (YCOwnerModel *)[_userArray objectAtIndex:section];
        NSString *mobile = userModel.mobile;
        if ([_userSolutionCountDict objectForKey:mobile]) {
            //            todo 为什么会调用3次
            sectionCount = [(NSNumber *)_userSolutionCountDict[mobile] intValue];
        }
        
        //        DLog(@"_userSolutionCountDict %@ %@", [(NSNumber *)_userSolutionCountDict[mobile] intValue], mobile);
    }
    
    return sectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_SECTION_H;
}

/**
 * Section view
 **/
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YCOwnerModel *userModel = [_userArray objectAtIndex:section];
    
    YCHouseOwnerView *owerView = [[YCHouseOwnerView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, CELL_SECTION_H)];
    owerView.userModel = userModel;
    owerView.delegate = self;
    
    return owerView;
}

- (YCHouseObject *)getCellHouseObject:(NSInteger)section row:(NSInteger)row
{
    YCOwnerModel *userModel = (YCOwnerModel *)[_userArray objectAtIndex:section];
    NSString *ownerId = userModel.ownerId;
    
    NSString *key = [NSString stringWithFormat:@"%@%ld", ownerId, row];
    
    YCHouseObject *houseObject = nil;
    
    if ([_resultDict objectForKey:key]) {
        
        houseObject = (YCHouseObject *)_resultFormDict[key];
    } else {
        houseObject = nil;
    }
    
    return houseObject;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YCHouseListCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:[YCHouseListCell cellID]];
    
    if (cell == nil) {
        
        cell = [[YCHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YCHouseListCell cellID]];
    }
    
    cell.contentView.backgroundColor = HEX_COLOR(CELL_BG_COLOR);
    cell.delegate = self;
    cell.houseObject = [self getCellHouseObject:indexPath.section
                                            row:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/**
 *
 *
 NSString *urlString = @"http://zhuangxiu-img.img-cn-shanghai.aliyuncs.com/leju/1708/03/37294516782411e780e900163e0e98a7.lf";
 *
 */
- (void)downloadAction:(NSString *)urlString houseId:(NSString *)houseId
{
    //    self.status.text = @"正在下载";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t downloadDispatchGroup = dispatch_group_create();
    
    // KCSOFT/13524010590/062ECECD-FA54-453B-8C40-741919A1BA7B/062ECECD-FA54-453B-8C40-741919A1BA7B.lf
    NSString *fileKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/%@.lf", [YCAppManager instance].workMobile, houseId, houseId];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileKCPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 如果本地不存在图片，则从网络中下载
    if (![fileManager fileExistsAtPath:filePath]) {
        
        dispatch_group_async(downloadDispatchGroup, queue, ^{
            DLog(@"Starting file download:%@", filePath);
            
            // URL组装和编码
            NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"file download from url: %@", urlString);
            
            // 开始下载图片
            NSData *responseData = [NSData dataWithContentsOfURL:url];
            // 将图片保存到指定路径中
            [responseData writeToFile:filePath atomically:YES];
            // 将下载的图片赋值给info
            NSLog(@"file download finish:%@", filePath);
            [LFDrawManager initDrawVCWithHouseID:houseId];
        });
    } else {
        
        [LFDrawManager initDrawVCWithHouseID:houseId];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    YCHouseObject *houseObject = [self getCellHouseObject:indexPath.section
                                                      row:indexPath.row];;
    NSString *houseId = houseObject.houseModel.houseId;
    [YCAppManager instance].houseId = houseId; //缓存当前绘制的houseId
    YCOwnerModel *userModel = [_userArray objectAtIndex:indexPath.section];
    [LFDrawManager initDrawVCWithHouseID:houseId];
    
    // 加载网络
    //    [YCAppManager instance].houseId = @"062ECECD-FA54-453B-8C40-741919A1BA7B";
    //    [self downloadAction];
}

#pragma mark - HouseListCellDelegate method
- (void)handleCopy:(YCHouseModel *)houseModel
{
    
    // 判断是否符合条件
    NSInteger sectionCount = [(NSNumber *)_userSolutionCountDict[houseModel.ownerId] intValue];
    //    if (sectionCount > 1) {
    //        // 已经有拆改图了
    //        return;
    //    }
    
    //    DLog(@"handle Copy %@", houseModel.zipFpath);
    NSString *sourcePath = houseModel.zipFpath;
    NSString *orginHouseId = houseModel.houseId;
    
    NSString *targetPath = [NSString stringWithFormat:@"%@_1", sourcePath];
    
    // copy file
    [ZTCommonUtils doCopyFile:sourcePath targetPath:targetPath houseId:orginHouseId];
    
    NSString *zipFpath = [NSString stringWithFormat:@"%@.zip", targetPath];
    [ZTCommonUtils zipFileDir:zipFpath sourcePath:targetPath];
    
    // copy db
    houseModel.isUpload = 0;
    houseModel.isDelete = 0;
    houseModel.type = 1;
    houseModel.zipUrl = @"";
    houseModel.zipFpath = targetPath;
    houseModel.houseId = [NSString stringWithFormat:@"%@_1", orginHouseId];
    [YCHouseFmdbTool insertCopySolutionModel:houseModel ownerId:houseModel.ownerId];
    
    // 同步后台
    [[YCAppManager instance] transHouseData:houseModel.houseId];
    
    // reload msg
    [self loadSolutionFromDB];
    
    // 刷新table view
    [self.mTableView reloadData];
}

//添加 alertview
-(void)addAlertView
{
    self.view.backgroundColor =[UIColor whiteColor];
    alert = [[YCAlertViewExtension alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    alert.delegate=self;
    [alert setbackviewframeWidth:300 Andheight:150];
    [alert settipeTitleStr:@"是否要删除该拆改图?" fontSize:15];
    [self.view addSubview:alert];
}

- (void)clickBtnSelector:(UIButton *)btn
{
    
    NSInteger btnTag = btn.tag;
    switch (btnTag) {
        case 1000:
        {
            // 确定
            [self deleteCell];
            [alert removeFromSuperview];
        }
            break;
            
        case 2000:
        {
            // 取消
            [alert removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteCell
{
    NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET isDelete = 1 where houseId = '%@'", _houseModel.houseId];
    [YCHouseFmdbTool modifyData:modifySql];
    
    // reload msg
    [self loadSolutionFromDB];
    
    // 刷新table view
    [self.mTableView reloadData];
    
    // 同步服务器
    [[YCAppManager instance] transDeleteHouse:_houseModel.houseId];
    
    /*
     UITableView *curTableView = (UITableView *)cell.superview.superview;
     NSIndexPath *indexPath = [curTableView indexPathForCell:cell];
     
     [curTableView beginUpdates];
     NSArray *array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil];
     [curTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
     //    [curTableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]]
     //                withRowAnimation:UITableViewRowAnimationLeft];
     [curTableView endUpdates];
     */
    
}

- (void)handleDel:(YCHouseListCell *)cell houseModel:(YCHouseModel *)houseModel
{
    _houseModel = houseModel;
    [self addAlertView];
}

#pragma mark - HouseListOwnerViewDelegate method
- (void)doShareOwner
{
    //    DLog(@"doShareOwner");
    //    ShowAlertWithOneButton(self, @"", @"分享业主", @"OK");
    
    if (self.shareEventBlock)
    {
        self.shareEventBlock(); // 调用回调函数
    }
    
}

- (void)doSendOwner
{
    YCSendResultViewController *sendResultVC = [[YCSendResultViewController alloc] init];
    sendResultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sendResultVC animated:YES];
    
    if (self.sendEventBlock)
    {
        self.sendEventBlock(); // 调用回调函数
    }
    
}

@end
