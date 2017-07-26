//
//  YCLJHouseListViewController.m
//  Pods
//
//  Created by Adam on 2017/6/16.
//
//

#import "YCLJHouseListViewController.h"
#import "HouseObject.h"
#import "HouseListCell.h"
#import "LFDrawManager.h"
#import "YCLJAppManager.h"
#import "UserModel.h"
#import "HouseFmdbTool.h"
#import "ZTHttpTool.h"

#import "Nonetwork.h"

#define CELL_SECTION_H   90.f

@interface YCLJHouseListViewController () <HouseListCellDelegate>

@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) NSDictionary *userSolutionCountDict;
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSMutableDictionary *resultFormDict;
@property (nonatomic) NSInteger userCount;
@end

@implementation YCLJHouseListViewController

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
    HouseObject *houseObject = [self getCellHouseObject:indexPath.section
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
                         
                         for (NSInteger index = 0; index < logicCount; index++) {
                             
                             NSMutableDictionary *logicDict = (NSMutableDictionary *)resultArray[index];
                             
                             HouseModel *houseModel = [HouseModel newWithDict:logicDict];
                             HouseObject *houseObject = [[HouseObject alloc] init];
                             houseObject.houseModel = houseModel;
                             
                             // cellDataArray 废弃
                             [cellDataArray addObject:houseObject];
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
    _userArray = [HouseFmdbTool queryUserData:nil];
    _userCount = [_userArray count];
    _userSolutionCountDict = [HouseFmdbTool queryUserSolutionNumber];
    _resultDict = [HouseFmdbTool querySolutionData:nil];
    _resultFormDict = [NSMutableDictionary dictionary];

    for (NSString *key in _resultDict) {
        
        HouseModel *houseModel = _resultDict[key];
        HouseObject *houseObject = [[HouseObject alloc] init];
        houseObject.houseModel = houseModel;
        
        [_resultFormDict setValue:houseObject forKey:key];
    }
    
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
        
        UserModel *userModel = (UserModel *)[_userArray objectAtIndex:section];
        NSString *userId = userModel.userId;
        if ([_userSolutionCountDict objectForKey:userId]) {
            
            sectionCount = [(NSNumber *)_userSolutionCountDict[userId] intValue];
        }
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
    UserModel *userModel = [_userArray objectAtIndex:section];
    
    UIView *sectionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, CELL_SECTION_H)];
    sectionBgView.backgroundColor = [UIColor whiteColor];
    
    NSInteger fontSize = 15;
    NSInteger offsetW = 3;
    
    // name
    CGFloat nameY = 20;
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(17, nameY, YC_SCREEN_WIDTH/6, 20)];
    labName.text = userModel.name;
    labName.font = FontBold(fontSize);
    labName.textColor = HEX_COLOR(@"0x333333");
    [sectionBgView addSubview:labName];
    
    // mobile
    CGFloat mobileX = YC_SCREEN_WIDTH/6;
    
    UIImageView *imgMobile = [[UIImageView alloc] init];
    imgMobile.image = GetImageByName(@"ycMobile");
    DLog(@"ycMobile.png = %@", [CommonUtils bundle]);
    
    imgMobile.frame = CGRectMake(mobileX - 20 - offsetW, nameY, 20, 20);
    [sectionBgView addSubview:imgMobile];
    
    UILabel *labMobile = [[UILabel alloc] initWithFrame:CGRectMake(mobileX, nameY, YC_SCREEN_WIDTH/5, 20)];
    labMobile.text = userModel.mobile;
    labMobile.font = Font(fontSize);
    labMobile.textColor = HEX_COLOR(@"0x666666");
    [sectionBgView addSubview:labMobile];

    // address
    CGFloat addressX = 40;
    CGFloat addressY = 50;
    
    UIImageView *imgAddress = [[UIImageView alloc] init];
    imgAddress.image = GetImageByName(@"ycAddress");
    imgAddress.frame = CGRectMake(addressX - 20 - offsetW, addressY, 20, 20);
    [sectionBgView addSubview:imgAddress];

    UILabel *labHouse = [[UILabel alloc] initWithFrame:CGRectMake(addressX, addressY, YC_SCREEN_WIDTH/2-40, 20)];
    labHouse.text = userModel.address;
    labHouse.font = Font(fontSize);
    labHouse.textColor = HEX_COLOR(@"0x666666");
    [sectionBgView addSubview:labHouse];

    // area
    CGFloat areaX = YC_SCREEN_WIDTH/2 + 20;
    
    UIImageView *imgArea = [[UIImageView alloc] init];
    imgArea.image = GetImageByName(@"ycArea");
    imgArea.frame = CGRectMake(areaX - 20 - offsetW, addressY, 20, 20);
    [sectionBgView addSubview:imgArea];

    UILabel *labArea = [[UILabel alloc] initWithFrame:CGRectMake(areaX, addressY, 40, 20)];
    labArea.text = userModel.area;
    labArea.font = Font(fontSize);
    labArea.textColor = HEX_COLOR(@"0x666666");
    [sectionBgView addSubview:labArea];
    
    // share
    CGFloat shareX = YC_SCREEN_WIDTH - 40;
    CGFloat shareY = 40;
    CGFloat shareW = 20;
    CGFloat shareH = 20;
    
    UIImageView *imgShare = [[UIImageView alloc] init];
    imgShare.image = GetImageByName(@"ycShare");
    imgShare.frame = CGRectMake(shareX, shareY, shareW, shareH);
    [sectionBgView addSubview:imgShare];

    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(shareX-10, shareY-10, shareW + 20, shareH + 20);
    [btnShare addTarget:self action:@selector(doShareOwner) forControlEvents:UIControlEventTouchUpInside];
    [sectionBgView addSubview:btnShare];
    
    // 发送业主
    CGFloat sendW = 90;
    CGFloat sendX = YC_SCREEN_WIDTH - sendW - 72;
    CGFloat sendY = 37;
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(sendX, sendY, 90, 28);
    btnSend.backgroundColor = HEX_COLOR(@"0xDE3031");
    [btnSend setTitle:@"发送业主" forState:UIControlStateNormal];
    btnSend.titleLabel.textColor = HEX_COLOR(@"0xffffff");
    btnSend.titleLabel.font = Font(fontSize + 1);
    [btnSend addTarget:self action:@selector(doSendOwner) forControlEvents:UIControlEventTouchUpInside];
    
    btnSend.layer.masksToBounds = YES;
    btnSend.layer.cornerRadius = 5.f;
    [sectionBgView addSubview:btnSend];
    
    // line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_SECTION_H - 0.5, YC_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = HEX_COLOR(@"0xE8E8E8");
    [sectionBgView addSubview:lineView];
    
    return sectionBgView;
}

- (HouseObject *)getCellHouseObject:(NSInteger)section row:(NSInteger)row
{
    UserModel *userModel = (UserModel *)[_userArray objectAtIndex:section];
    NSString *userId = userModel.userId;
    
    NSString *key = [NSString stringWithFormat:@"%@%ld", userId, row];
    
    HouseObject *houseObject;
    
    if ([_resultDict objectForKey:key]) {
        
        houseObject = (HouseObject *)_resultFormDict[key];
    } else {
        houseObject = nil;
    }

    return houseObject;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HouseListCell *cell = [self.mTableView dequeueReusableCellWithIdentifier:[HouseListCell cellID]];
    
    if (cell == nil) {
        
        cell = [[HouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HouseListCell cellID]];
    }
    
    cell.contentView.backgroundColor = HEX_COLOR(CELL_BG_COLOR);
    cell.delegate = self;
    cell.houseObject = [self getCellHouseObject:indexPath.section
                                            row:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    HouseObject *houseObject = [self getCellHouseObject:indexPath.section
                                                    row:indexPath.row];;
    NSString *houseId = houseObject.houseModel.houseId;
    [YCLJAppManager instance].houseId = houseId;//缓存houseId
    [LFDrawManager initDrawVCWithHouseID:houseId];
}

#pragma mark - logic
- (void)doShareOwner {
    
    ShowAlertWithOneButton(self, @"", @"分享业主", @"OK");
}

- (void)doSendOwner {
    
    ShowAlertWithOneButton(self, @"", @"发送业主", @"OK");
}

#pragma mark - HouseListCellDelegate method
- (void)handleCopy:(HouseModel *)houseModel
{

    // 判断是否符合条件
    NSInteger sectionCount = [(NSNumber *)_userSolutionCountDict[houseModel.userId] intValue];
    if (sectionCount > 1) {
        // 已经有拆改图了
        return;
    }
    
    DLog(@"handle Copy %@", houseModel.zipFpath);
    NSString *sourcePath = houseModel.zipFpath;
    NSString *orginHouseId = houseModel.houseId;
    
    NSString *targetPath = [NSString stringWithFormat:@"%@_1", sourcePath];
    
    // copy file
    [CommonUtils doCopyFile:sourcePath targetPath:targetPath houseId:orginHouseId];
    
    NSString *zipFpath = [NSString stringWithFormat:@"%@.zip", targetPath];
    [CommonUtils zipFileDir:zipFpath sourcePath:targetPath];
    
    // copy db
    houseModel.isUpload = 0;
    houseModel.isDelete = 0;
    houseModel.type = 1;
    houseModel.zipUrl = @"";
    houseModel.zipFpath = targetPath;
    houseModel.houseId = [NSString stringWithFormat:@"%@_1", orginHouseId];
    [HouseFmdbTool insertSolutionModel:houseModel userId:houseModel.userId];
    
    // reload msg
    [self loadSolutionFromDB];
    
    // 刷新table view
    [self.mTableView reloadData];
}

- (void)handleDel:(HouseListCell *)cell houseModel:(HouseModel *)houseModel
{
    
    NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET isDelete = 1 where houseId = '%@'", houseModel.houseId];
    [HouseFmdbTool modifyData:modifySql];
    
    // reload msg
    [self loadSolutionFromDB];
    
    // 刷新table view
    [self.mTableView reloadData];
    
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

@end
