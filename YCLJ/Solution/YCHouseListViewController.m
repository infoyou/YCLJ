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
#import "YCDrawManager.h"
#import "YCAppManager.h"

#import "YCOwnerModel.h"
#import "YCHouseOwnerView.h"

@interface YCHouseListViewController () <HouseListCellDelegate,YCAlertviewExtensionDelegate, HouseListOwnerViewDelegate>
{
    YCAlertViewExtension *alert;
    NSInteger selDelTableSection;
}

@property (nonatomic, strong) YCHouseModel *houseModel;
@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, assign) NSInteger userCount;

@end

@implementation YCHouseListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self closeLoadingMsg];
    
    [self showLoadingMsg:@"加载数据"];

    [self loadFirstSolution];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"户型列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [self checkNetAvailable];
    
    [YCAppManager instance].GetUpdateResult = ^(NSString *msg){

        if(![msg isEqualToString:@""])
        {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        } else {

            [self loadFirstSolution];
        }
    };
}

- (void)checkNetAvailable
{
    Nonetwork *Nonet = [[Nonetwork alloc] initWithFrame:[UIScreen mainScreen].bounds];
    Nonet.Prompt = @"无法连接服务器，请检查你的网络设置";
    Nonet.typeDisappear = 1;
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

- (void)loadFirstSolution
{
    
    // 拉去网上数据
    [self loadSolutionFromWeb];
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
                        
                        for (NSInteger i=0; i<ownerCount; i++) {
                            
                            NSMutableDictionary *ownerDict = (NSMutableDictionary *)ownerDictArray[i];
                            YCOwnerModel *ownerModel = [YCOwnerModel newWithDict:ownerDict];
                            
                            // house
                            NSArray *houseDictArray = (NSArray *)[ownerDict valueForKey:@"house_list"];
                            NSInteger houseCount = houseDictArray.count;
                            
                            NSMutableArray *houseArray = [NSMutableArray arrayWithCapacity:houseCount];
                            NSMutableDictionary *houseObjectDict = [NSMutableDictionary dictionaryWithCapacity:houseCount];
                            
                            for (NSInteger j=0; j<houseCount; j++) {
                                
                                NSMutableDictionary *houseDict = (NSMutableDictionary *)houseDictArray[j];
                                
                                // 户型数据
                                YCHouseModel *houseModel = [YCHouseModel newWithDict:houseDict];
                                [houseArray addObject:houseModel];
                                
                                // 户型显示数据
                                YCHouseObject *houseObject = [[YCHouseObject alloc] init];
                                houseObject.houseModel = houseModel;
                                
                                NSString *key = [NSString stringWithFormat:@"%@#%ld", ownerModel.workOrderId, houseModel.type];
                                [houseObjectDict setObject:houseObject forKey:key];
                            }
                            
                            ownerModel.houseArray = houseArray;
                            ownerModel.houseObjectDict = houseObjectDict;
                            [ownerArray addObject:ownerModel];
                        }
                        
                        _userArray = ownerArray;
                        _userCount = [_userArray count];
                        
                        // 更新列表
                        [self loadCellDataDone];
                        
                        // 关闭提示
                        [self closeLoadingMsg];
                        
                        DLog(@"over");
                    } else {
                        
                        NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                        //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败-%@", error);
            }];
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
        
        YCOwnerModel *ownerModel = (YCOwnerModel *)[_userArray objectAtIndex:section];
        
        sectionCount = [ownerModel.houseArray count];
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
    YCOwnerModel *ownerModel = [_userArray objectAtIndex:section];
    
    YCHouseOwnerView *owerView = [[YCHouseOwnerView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, CELL_SECTION_H)];
    owerView.userModel = ownerModel;
    owerView.delegate = self;
    
    return owerView;
}

- (YCHouseObject *)getCellHouseObject:(NSInteger)section row:(NSInteger)row
{
    YCOwnerModel *ownerModel = (YCOwnerModel *)[_userArray objectAtIndex:section];
    
    NSString *key = [NSString stringWithFormat:@"%@#%ld", ownerModel.workOrderId, row];
    
    YCHouseObject *houseObject = nil;
    
    if ([ownerModel.houseObjectDict objectForKey:key]) {
        
        houseObject = (YCHouseObject *)ownerModel.houseObjectDict[key];
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
    cell.ownerModel = _userArray[indexPath.section];
    cell.houseObject = [self getCellHouseObject:indexPath.section
                                            row:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    YCHouseObject *houseObject = [self getCellHouseObject:indexPath.section
                                                      row:indexPath.row];
    YCHouseModel *houseModel = houseObject.houseModel;
    
    if ([houseModel.state integerValue] == 1) {
        // 爱福窝老图
        DLog(@"houseModel.areaFpath %@", houseModel.areaFpath);
        if ([houseModel.areaFpath isEqualToString:@""]) {
            
            [self showWithText:@"户型数据为空"];
        } else {
            
            [[YCDrawManager instance] startDraw:self
                                     houseModel:houseModel];
        }
    } else {
        // 新图
        DLog(@"houseModel.lfFile %@", houseModel.lfFile);
        if ([houseModel.lfFile isEqualToString:@""]) {
            
            [self showWithText:Uploading_Data_Txt];
        } else {
            
            [[YCDrawManager instance] startDraw:self
                                     houseModel:houseModel];
        }
    }
}

#pragma mark - HouseListCellDelegate method
- (void)handleCopy:(YCHouseModel *)houseModel
{
    // 同步后台
    [[YCAppManager instance] transCopyHouseData:houseModel.houseId];
    
    [YCAppManager instance].GetCopyResult = ^(NSString *msg){
        
        if(![msg isEqualToString:@""])
        {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        } else {
            // 刷新table view
            [self loadFirstSolution];
        }
    };
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
    // 同步服务器
    YCOwnerModel *ownerModel = _userArray[selDelTableSection];
    [[YCAppManager instance] transDeleteHouse:_houseModel.houseId
                                   ownerModel:ownerModel];
    
    [YCAppManager instance].GetDelResult = ^(NSString *msg){
        
        if(![msg isEqualToString:@""])
        {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        } else {
            // 刷新table view
            [self loadFirstSolution];
        }
    };
}

- (void)handleDel:(YCHouseListCell *)cell houseModel:(YCHouseModel *)houseModel
{
    _houseModel = houseModel;
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
    selDelTableSection = indexPath.section;
    [self addAlertView];
}

#pragma mark - HouseListOwnerViewDelegate method
- (void)doShareOwner:(NSString *)workOrderId
{
    //    DLog(@"doShareOwner");
    //    ShowAlertWithOneButton(self, @"", @"分享业主", @"OK");
    
    if (self.shareBlock)
    {
        NSString *shareUrl = [NSString stringWithFormat:@"%@/leju/house/house-summary?chief_id=%@&work_order_id=%@", YC_HOST_URL, [YCAppManager instance].workId, workOrderId];
        
        self.shareBlock(shareUrl); // 调用回调函数
        NSLog(@"分享数据 %@", shareUrl);
    }
}

- (void)transSyncHouse:(NSString *)houseNum
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/sync/%@", YC_HOST_URL, houseNum];
    
    [ZTHttpTool get:urlStr
              params:nil
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         YCSendResultViewController *sendResultVC = [[YCSendResultViewController alloc] init];
                         sendResultVC.hidesBottomBarWhenPushed = YES;
                         [self.navigationController pushViewController:sendResultVC animated:YES];
                         
                         if (self.sendBlock)
                         {
                             self.sendBlock(@"0"); // 调用回调函数
                             DLog(@"发送业主成功");
                         }
                     } else {
                         
                         NSString *msg = [backDic valueForKey:@"msg"];
                         if (self.sendBlock)
                         {
                             self.sendBlock(@"1"); // 调用回调函数
                             DLog(@"发送业主失败 %@", msg);
                         }
                         
                         [self showWithText:msg];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

- (void)doSendOwner:(NSString *)houseNum
{
    [self transSyncHouse:houseNum];
}

@end
