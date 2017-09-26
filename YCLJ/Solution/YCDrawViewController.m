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
#import "YCPopViewExtension.h"
#import "YCUserListViewController.h"
#import "YCHouseListViewController.h"
#import "YCNewUserViewController.h"

typedef enum {
    
    HOUSE_EXIT_TYPE = 0,
    HOUSE_TO_SOLUTION_TYPE,
    
} BACK_VIEW_TYPE;

@interface YCDrawViewController () <YCAlertviewExtensionDelegate>
{
    YCPopViewExtension *alert;
    
}

@property (nonatomic, copy) NSString *tempHouseID;
@property (nonatomic, strong) UIViewController *startVC;

@end


@implementation YCDrawViewController

static YCDrawViewController *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCDrawViewController alloc] init];
        
        // 添加绘图保存成功监听
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseSaveSucceedAction:) name: @"kSDKSaveHouseDataSucceed_LFSQ" object:nil];
    });
    
    return singleton;
}

- (void)startDraw:(UIViewController *)vc model:(YCOwnerModel *)model
{
    self.startVC = vc;
    
    [LFDrawSDKAPI getHouseIDWhenSaveHouse:^(NSString * _Nonnull HouseID) {
        
        if (![HouseID isEqualToString:@""]) {
            // 如果是临时的
            [LFDrawManager initDrawVCWithHouseID:HouseID];
        } else {
            
            /** 初始化一个绘图界面 */
            [LFDrawManager initDrawVCWithNewHouse];
        }
    }];
    
    [self drawHouse];
}

/**
 * houseId 工长Id
 * ownerMobile 业主手机号码
 *
 */
- (void)setOwnerMobile:(NSString *)ownerMobile
{
    //    setHouseId:@"51652" ownerMobile:@"13585869804"
    
    if (![ownerMobile isEqualToString:@""] ) {
        
        [self drawHouseWithOwnerMobile:ownerMobile];
    } else {
        
        [self drawHouse];
    }
}

- (void)drawHouse
{
    LFDrawManager *dm = [LFDrawManager sharedInstance];
    
    [dm setCloseBtnActionBlock:^(NSString *houseID){
        
        NSLog(@"\n-------点击了“关闭”按钮-------\n %@", houseID);
        
        self.tempHouseID = houseID;
        [self backView:HOUSE_EXIT_TYPE];
        
        [[YCAppManager instance] updateTempHouseData:@""];
    }];
    
    // 点击3D
    [dm setJump3DPageBlock:^(UIViewController *drawVC){
        
        NSLog(@"\n-------点击了“3D”按钮-------\n");
        // [self dismissViewControllerAnimated:YES completion:nil];
        
        if (self.draw3DBlock)
        {
            self.draw3DBlock(drawVC);
            NSLog(@"绘制3D");
        }
    }];
}

// 原有基础上修改
- (void)drawHouseWithOwnerMobile:(NSString *)ownerMobile
{
    
    // 工长下面业主的户型，如果有拆改的返回拆改图ID，如果没有就返回原始图ID
    [[YCAppManager instance] transWorkId:[YCAppManager instance].workId
                             ownerMobile:ownerMobile];
    
    [YCAppManager instance].GetOwnerHouseId = ^(NSString *houseId, NSString *lfFile, NSString *msg){
        
        NSLog(@"houseId = %@", houseId);
        
        if(![msg isEqualToString:@""])
        {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        } else {
            [self downloadAction:lfFile houseId:houseId];
        }
        
    };
}

/**
 *
 *
 NSString *urlString = @"http://zhuangxiu-img.img-cn-shanghai.aliyuncs.com/leju/1708/03/37294516782411e780e900163e0e98a7.lf";
 *
 */
- (void)downloadAction:(NSString *)urlString houseId:(NSString *)houseId
{
    DLog(@"downloadAction:%@ houseId:%@", urlString, houseId);
    
    //    self.status.text = @"正在下载";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t downloadDispatchGroup = dispatch_group_create();
    
    // KCSOFT/13524010590/062ECECD-FA54-453B-8C40-741919A1BA7B/062ECECD-FA54-453B-8C40-741919A1BA7B.lf
    
    // dir
    NSString *dirKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/", [YCAppManager instance].workMobile, houseId];
    
    NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dirKCPath];
    
    // file
    NSString *fileKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/%@.lf", [YCAppManager instance].workMobile, houseId, houseId];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileKCPath];
    
    
    // 如果本地不存在图片，则从网络中下载
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    if (![fileManager fileExistsAtPath:filePath])
    { // 不管是否存在都从网上下载，保证内容最新
        
        // Create target path
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
        
        dispatch_group_async(downloadDispatchGroup, queue, ^{
            DLog(@"Starting file download:%@", dirPath);
            
            // URL组装和编码
            NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"file download from url: %@", urlString);
            
            // 开始下载图片
            NSData *responseData = [NSData dataWithContentsOfURL:url];
            // 将图片保存到指定路径中
            [responseData writeToFile:filePath atomically:YES];
            // 将下载的图片赋值给info
            NSLog(@"file download finish:%@", filePath);
            [self drawWithHouseId:houseId];
        });
    }
    //    else {
    //
    //        [self drawWithHouseId:houseId];
    //    }
}

- (void)drawWithHouseId:(NSString *)houseId
{
    /** 初始化一个绘图界面 */
    [LFDrawManager initDrawVCWithHouseID:houseId];
    
    LFDrawManager *dm = [LFDrawManager sharedInstance];
    
    [dm setCloseBtnActionBlock:^(NSString* houseID){
        
        NSLog(@"\n-------点击了“关闭”按钮-------\n %@", houseID);
        
        self.tempHouseID = houseID;
        [self backView:HOUSE_EXIT_TYPE];
    }];
    
    // 点击3D
    [dm setJump3DPageBlock:^(UIViewController * drawVC){
        
        if (self.draw3DBlock)
        {
            self.draw3DBlock(drawVC);
            NSLog(@"绘制3D");
        }
        
        //        LFUnityViewController * d3VC = [[LFUnityViewController alloc] init];
        //        [drawVC.navigationController pushViewController:d3VC animated:YES];
    }];
}

- (IBAction)btnAreaList:(id)sender {
    
    YCUserListViewController *solutionListVC = [[YCUserListViewController alloc] init];
    [self.startVC.navigationController pushViewController:solutionListVC animated:NO];
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

//添加alertview
- (void)addAlertView
{
    alert = [[YCPopViewExtension alloc] initWithFrame:CGRectMake(0, 0, self.startVC.view.frame.size.width, self.startVC.view.frame.size.height + 120)];
    alert.delegate = self;
    [alert setbackviewframeWidth:300 Andheight:150];
    [alert settipeTitleStr:@"" fontSize:14];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [self.startVC.view bringSubviewToFront:alert];
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
            [self.startVC dismissViewControllerAnimated:YES completion:nil];
            [alert removeFromSuperview];
            
            [self addNewHouse];
            
            // 选择已有业主信息
            YCUserListViewController *userListVC = [[YCUserListViewController alloc] init];
            userListVC.hidesBottomBarWhenPushed = YES;
            [self.startVC.navigationController pushViewController:userListVC animated:NO];
        }
            break;
            
        case 2000:
        {
            [self.startVC dismissViewControllerAnimated:YES completion:nil];
            [alert removeFromSuperview];
            
            [self addNewHouse];
            
            // 新建业主信息[姓名，手机号，小区名称，建筑面积]
            YCNewUserViewController *newUserVC = [[YCNewUserViewController alloc] init];
            newUserVC.hidesBottomBarWhenPushed = YES;
            [self.startVC.navigationController pushViewController:newUserVC animated:NO];
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
    
    [self.startVC dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(goHouseListVC)
               withObject:nil
               afterDelay:0.4];
}

- (void)goHouseListVC {
    /** 户型列表 */
    YCHouseListViewController *houseListVC = [[YCHouseListViewController alloc] init];
    houseListVC.hidesBottomBarWhenPushed = YES;
    [self.startVC.navigationController pushViewController:houseListVC animated:NO];
    
    houseListVC.shareBlock = ^(NSString *url) {
        if (self.shareBlock)
        {
            self.shareBlock(url);
            NSLog(@"分享数据");
        }
    };
    
    houseListVC.sendBlock = ^(NSString *url) {
        
        self.sendBlock(url);
        NSLog(@"发送数据");
    };
}

// --------- 绘制页面中涉及到的逻辑跳转 end ---------

@end

