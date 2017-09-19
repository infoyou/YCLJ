//
//  YCDrawViewController.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/19.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCDrawViewController.h"
#import "LFDrawManager.h"
#import "LFDrawSDKAPI.h"

#import "YCLJ.h"

typedef enum {
    HOUSE_EXIT_TYPE = 0,
    HOUSE_TO_SOLUTION_TYPE,
} BACK_VIEW_TYPE;

@interface YCDrawViewController () <YCAlertviewExtensionDelegate>
{
    YCPopViewExtension *alert;
}

@property (nonatomic, copy) NSString *tempHouseID;

@end


@implementation YCDrawViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [ZTCommonUtils commonMsg];
    
    self.tempHouseID = nil;
    
    /**
     添加绘图保存成功监听
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseSaveSucceedAction:) name: @"kSDKSaveHouseDataSucceed_LFSQ" object:nil];
}

/**
 * houseId 工长Id
 * ownerMobile 业主手机号码
 *
 */
- (void)setHouseId:(NSString *)houseId ownerMobile:(NSString *)ownerMobile
{
//    setHouseId:@"51652" ownerMobile:@"13585869804"
    
    if (![houseId isEqualToString:@""] && ![ownerMobile isEqualToString:@""] ) {
        
        [self drawHouse:houseId ownerMobile:ownerMobile];
    } else {
        
        [self drawHouse];
    }
}

- (void)drawHouse
{
    /** 初始化一个绘图界面 */
    [LFDrawManager initDrawVCWithNewHouse];
    
    LFDrawManager *dm = [LFDrawManager sharedInstance];
    // 点击户型列表
    [dm setHouseListBtnActionBlock:^(NSString *houseID){
        
        NSLog(@"点击了户型列表");
        
        self.tempHouseID = houseID;
        [self backView:HOUSE_TO_SOLUTION_TYPE];
    }];
    
    [dm setCloseBtnActionBlock:^(NSString* houseID){
        
        NSLog(@"\n-------点击了“关闭”按钮-------\n %@", houseID);
        
        self.tempHouseID = houseID;
        [self backView:HOUSE_EXIT_TYPE];
    }];
    
    // 点击3D
//    [dm setJump3DPageBlock:^(UIViewController * drawVC){
//        
//        LFUnityViewController * d3VC = [[LFUnityViewController alloc] init];
//        [drawVC.navigationController pushViewController:d3VC animated:YES];
//    }];
}

// 原有基础上修改
- (void)drawHouse:(NSString *)houseId ownerMobile:(NSString *)ownerMobile
{
    
    // 工长下面业主的户型，如果有拆改的返回拆改图ID，如果没有就返回原始图ID
    [[YCAppManager instance] transHouseId:houseId
                              ownerMobile:ownerMobile];
    
    [YCAppManager instance].GetHouseId = ^(NSString *houseId){
        
        NSLog(@"houseId = %@", houseId);
        
        /** 初始化一个绘图界面 */
        [LFDrawManager initDrawVCWithHouseID:houseId];
        
        LFDrawManager *dm = [LFDrawManager sharedInstance];
        // 点击户型列表
        [dm setHouseListBtnActionBlock:^(NSString *houseID){
            
            NSLog(@"点击了户型列表");
            
            self.tempHouseID = houseID;
            [self backView:HOUSE_TO_SOLUTION_TYPE];
        }];
        
        [dm setCloseBtnActionBlock:^(NSString* houseID){
            
            NSLog(@"\n-------点击了“关闭”按钮-------\n %@", houseID);
            
            self.tempHouseID = houseID;
            [self backView:HOUSE_EXIT_TYPE];
        }];
        
        // 点击3D
//        [dm setJump3DPageBlock:^(UIViewController * drawVC){
//            LFUnityViewController * d3VC = [[LFUnityViewController alloc] init];
//            [drawVC.navigationController pushViewController:d3VC animated:YES];
//        }];
    };
}

- (IBAction)btnAreaList:(id)sender {
    
    YCUserListViewController *solutionListVC = [[YCUserListViewController alloc] init];
    [self.navigationController pushViewController:solutionListVC animated:NO];
}

- (IBAction)getJsonPath:(id)sender {
    
    NSLog(@"\n-------HouseJson-------\n%@",[LFDrawSDKAPI getHouseJsonDataPathWithHouseID:self.tempHouseID]);
}

- (IBAction)getPicPath:(id)sender {
    
    NSLog(@"\n-------Pic-------\n%@",[LFDrawSDKAPI getHousePicPathWithHouseID:self.tempHouseID]);
}

- (IBAction)getDxfPath:(id)sender {
    
    NSLog(@"\n-------DXF-------\n%@",[LFDrawSDKAPI getHouseDXFDataPathWithHouseID:self.tempHouseID]);
}

- (IBAction)getAreaPath:(id)sender {
    
    NSLog(@"\n-------暂未提供-------\n");
}

- (IBAction)get3DDataPath:(id)sender {
    
    NSLog(@"\n-------U3D-------\n%@",[LFDrawSDKAPI getHouseU3DDataPathWithHouseID:self.tempHouseID]);
}


- (IBAction)getZIPDataPath:(id)sender {
    
    NSString *zipPath = [LFDrawSDKAPI getHouseZIPDataPathWithHouseID:self.tempHouseID];
    
    NSLog(@"\n-------ZIP-------\n%@", zipPath);
}

/**
 监听 绘图保存成功 拿到houseID
 */
- (void)houseSaveSucceedAction:(NSNotification*)notification
{
    
    NSString *getHouseID = notification.userInfo[@"kSDKHouseID_LFSQ"];
    NSLog(@"\n-------收到户型保存成功的消息---getHouseID----\n%@", getHouseID);
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kSDKSaveHouseDataSucceed_LFSQ" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加alertview
- (void)addAlertView
{
    alert = [[YCPopViewExtension alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    alert.delegate = self;
    [alert setbackviewframeWidth:300 Andheight:150];
    [alert settipeTitleStr:@"" fontSize:14];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [self.view bringSubviewToFront:alert];
}

- (void)addNewHouse
{
    // 新建模式
    if (self.tempHouseID != nil) {
        // 保存本地文件
        NSString *zipPath = [LFDrawSDKAPI getHouseZIPDataPathWithHouseID:self.tempHouseID];
        
        // 保存户型
        [[YCAppManager instance] saveLocalHouseData:zipPath
                                            houseId:self.tempHouseID];
        
        // 上传户型zip文件到服务端
        [[YCAppManager instance] uploadFileMehtod:zipPath
                                          houseId:self.tempHouseID];
    }
}

- (void)clickBtnSelector:(UIButton *)btn
{
    
    NSInteger btnTag = btn.tag;
    switch (btnTag) {
        case 1000:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            [alert removeFromSuperview];
            
            [self addNewHouse];
            
            // 选择已有业主信息
            YCUserListViewController *solutionListVC = [[YCUserListViewController alloc] init];
            [self.navigationController pushViewController:solutionListVC animated:NO];
        }
            break;
            
        case 2000:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            [alert removeFromSuperview];
            
            [self addNewHouse];
            
            // 新建业主信息[姓名，手机号，小区名称，建筑面积]
            YCNewUserViewController *newUserVC = [[YCNewUserViewController alloc] init];
            [self.navigationController pushViewController:newUserVC animated:NO];
        }
            break;
            
        case 3000:
        {
            // 取消
            [alert removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

// --------- 绘制页面中涉及到的逻辑跳转 start ---------

/**
 *
 * 从绘制页面返回App
 *  type
 0, 退出
 1, 进入户型列表
 **/
- (void)backView:(BACK_VIEW_TYPE)type
{
    
    if ([YCHouseFmdbTool querySolutionData:self.tempHouseID]) {
        
        // 编辑模式
        //        [self.navigationController popViewControllerAnimated:YES];
        [self btnHouseList];
        
        if (self.tempHouseID != nil) {
            
            // 保存本地文件
            NSString *zipPath = [LFDrawSDKAPI getHouseZIPDataPathWithHouseID:self.tempHouseID];
            
            // 上传户型zip文件到服务端
            [[YCAppManager instance] uploadFileMehtod:zipPath
                                              houseId:self.tempHouseID];
        }
        
    } else {
        switch (type) {
                
            case HOUSE_EXIT_TYPE:
            {
                // 新建业主信息[姓名，手机号，小区名称，建筑面积] 或 选择业主信息
                [self addAlertView];
            }
                break;
                
            case HOUSE_TO_SOLUTION_TYPE:
            {
                // 进入户型列表
                [self btnHouseList];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)btnHouseList {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(goHouseListVC)
               withObject:nil
               afterDelay:0.4];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goHouseListVC {
    /** 户型列表 */
    YCHouseListViewController *solutionListVC = [[YCHouseListViewController alloc] init];
    [self.navigationController pushViewController:solutionListVC animated:NO];
    
    solutionListVC.shareEventBlock = ^{
        NSLog(@"分享数据");
    };
    
    solutionListVC.sendEventBlock = ^{
        NSLog(@"发送数据");
    };
    
}

// --------- 绘制页面中涉及到的逻辑跳转 end ---------

@end
