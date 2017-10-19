//
//  YCDrawManager.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/19.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCDrawManager.h"
#import "LFDrawManager.h"
#import "LFDrawSDKAPI.h"
#import "YCPopViewExtension.h"

#import "YCNewUserViewController.h"
#import "YCUserListViewController.h"
#import "YCHouseListViewController.h"

#import "YCHouseModel.h"
#import "YCOwnerModel.h"

@interface YCDrawManager () <YCAlertviewExtensionDelegate>
{
    YCPopViewExtension *alert;
    NSInteger fromType;
}

@property (nonatomic, copy) NSString *tempHouseID;
@property (nonatomic, strong) UIViewController *startVC;
@property (nonatomic, strong) YCOwnerModel *model;

@end


@implementation YCDrawManager

static YCDrawManager *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCDrawManager alloc] init];
        
        // 添加绘图保存成功监听
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseSaveSucceedAction:) name: @"kSDKSaveHouseDataSucceed_LFSQ" object:nil];
    });
    
    return singleton;
}

- (void)startDraw:(UIViewController *)vc houseModel:(YCHouseModel *)houseModel
{
    self.startVC = vc;
    
    [[YCAppManager instance] showLoadingMsg:@"加载数据"];
    
    NSInteger houseDrawState = [houseModel.state integerValue];
    if (houseDrawState == 1) {
        
        [self downloadAction:houseModel.areaFpath
                     houseId:houseModel.houseId
                       state:houseDrawState];
    } else {
        
        [self downloadAction:houseModel.lfFile
                     houseId:houseModel.houseId
                       state:houseDrawState];
    }
}

- (void)startDraw:(UIViewController *)vc model:(YCOwnerModel *)model
{
    self.startVC = vc;
    self.model = model;
    self.model.ownerId = self.model.workOrderId;
    
    if (model != nil) {
        
        if (model.workOrderId != nil && model.workOrderId.length > 1) {
            if (model.houseId != nil && model.houseId.length > 1) {
                
                // 有工单，有图
                [self drawWithHouseId:model.houseId];
            } else {
                
                // 有工单，无图
                [self drawFirstViewPath:2];
            }
        }
    } else {
        
        [self drawFirstViewPath:0];
    }
}

#pragma mark - 第一次画， type [不同的来源]
- (void)drawFirstViewPath:(NSInteger)type
{
    [LFDrawSDKAPI getHouseIDWhenSaveHouse:^(NSString * _Nonnull HouseID) {
        
        if (HouseID == nil) {
            /** 初始化一个绘图界面 */
            [self drawHouse:nil type:type];
        } else if (![HouseID isEqualToString:@""]) {
            // 如果是临时的
            [self drawHouse:HouseID type:type];
        } else {
            /** 初始化一个绘图界面 */
            [self drawHouse:nil type:type];
        }
    }];
}

- (void)drawHouse:(NSString *)houseId
             type:(NSInteger)type
{
    fromType = type;
    
    //新图
    if (houseId != nil) {
        
        [LFDrawManager initDrawVCWithHouseID:houseId];
    } else {
        
        [LFDrawManager initDrawVCWithNewHouse];
    }
    
    LFDrawManager *dm = [LFDrawManager sharedInstance];
    
    [dm setCloseBtnActionBlock:^(NSString *houseID){
        
        NSLog(@"\n-------点击了“关闭”按钮-------\n %@", houseID);
        
        self.tempHouseID = houseID;
        [self backView];
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

// 通过户型Id 绘制户型
- (void)drawWithHouseId:(NSString *)houseId
{
    
    [[YCAppManager instance] transHouseFileById:houseId];
    
    [YCAppManager instance].GetHouseFile = ^(NSString *lfFile, NSString *msg){
        
        if(lfFile != nil)
        {
            [self downloadAction:lfFile
                         houseId:houseId
                           state:0];
        } else {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        }
    };
}

// 废弃
// 原有基础上修改
- (void)drawHouseWithWorkOrder:(NSString *)workOrderId
{
    
    // 工长下面业主的户型，如果有拆改的返回拆改图ID，如果没有就返回原始图ID
    [[YCAppManager instance] transWorkId:[YCAppManager instance].workId
                             workOrderId:workOrderId];
    
    [YCAppManager instance].GetOwnerHouseId = ^(NSString *houseId, NSString *lfFile, NSString *msg){
        
        NSLog(@"houseId = %@", houseId);
        
        if(![msg isEqualToString:@""])
        {
            ShowAlertWithOneButton(self, @"", msg, @"Ok");
        } else {
            [self downloadAction:lfFile
                         houseId:houseId
                           state:0];
        }
    };
}

- (void)downloadAction:(NSString *)urlString
               houseId:(NSString *)houseId
                 state:(NSInteger)state
{
    DLog(@"downloadAction:%@ houseId:%@", urlString, houseId);
    
    // dir
    NSString *dirKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/", [YCAppManager instance].workMobile, houseId];
    
    NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dirKCPath];
    
    // file
    NSString *fileKCPath = @"";
    if (state == 0) {
        // 科创
        fileKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/%@.lf", [YCAppManager instance].workMobile, houseId, houseId];
    } else {
        // 爱福窝
        fileKCPath = [NSString stringWithFormat:@"KCSOFT/%@/%@/%@.json", [YCAppManager instance].workMobile, houseId, houseId];
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileKCPath];
    
    // 判断本地是否存在
     if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
         // 从网上下载，保证内容最新
         [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_group_t downloadDispatchGroup = dispatch_group_create();
         
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
             
             if (state == 0) {
                 // 科创绘制
                 [self drawHouse:houseId type:1];
             } else {
                 // 爱福窝绘制
                 [self drawAfwData:filePath];
             }
             
             [[YCAppManager instance] closeLoadingMsg];
         });
     } else {

         if (state == 0) {
             // 科创绘制
             [self drawHouse:houseId type:1];
         } else {
             // 爱福窝绘制
             [self drawAfwData:filePath];
         }

         [[YCAppManager instance] closeLoadingMsg];
     }
}

- (void)drawAfwData:(NSString *)filePath
{
    // 爱福窝老图
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSError *error = nil;
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]);
    NSLog(@"%@",error);
    
    [LFDrawManager initAFWDrawVCWithHouseDict:dict];
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
        
        // 3D
        // [LFDrawSDKAPI getHouseU3DPathWithHouseID:self.tempHouseID];
        
        // 保存户型
        [[YCAppManager instance] saveHouseParam:zipPath
                                        houseId:self.tempHouseID];
    }
}

- (void)clickBtnSelector:(UIButton *)btn
{
    
    NSInteger btnTag = btn.tag;
    switch (btnTag) {
        case 1000:
        {
            [alert removeFromSuperview];
            [self.startVC dismissViewControllerAnimated:YES completion:nil];

            [self addNewHouse];
            
            // 选择已有业主信息
            YCUserListViewController *userListVC = [[YCUserListViewController alloc] init];
            userListVC.hidesBottomBarWhenPushed = YES;
            [self.startVC.navigationController pushViewController:userListVC animated:NO];
        }
            break;
            
        case 2000:
        {
            [alert removeFromSuperview];
            [self.startVC dismissViewControllerAnimated:YES completion:nil];
            
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

- (void)backView
{
    
    switch (fromType) {
        case 0:
        {
            // 新建业主信息[姓名，手机号，小区名称，建筑面积] 或 选择业主信息
            [self addAlertView];
        }
            break;
            
        case 1:
        {
            if (self.tempHouseID != nil) {
                
                // 保存本地文件
                NSString *zipPath = [LFDrawSDKAPI getHouseZIPDataPathWithHouseID:self.tempHouseID];
                
                [LFDrawSDKAPI getHouseU3DPathWithHouseID:self.tempHouseID];
                
                // 保存户型
                [[YCAppManager instance] saveHouseParam:zipPath
                                                houseId:self.tempHouseID];
                // Upload
                [[YCAppManager instance] uploadFileMehtod];
            }
            
            [self.startVC dismissViewControllerAnimated:YES completion:nil];
        }
            break;

        case 2:
        {
            // 存储数据
            [[YCAppManager instance] saveLocalOwnerData:self.model];
            
            [self.startVC dismissViewControllerAnimated:YES completion:nil];
            
            [self startHouseList:self.startVC];
        }
            break;

        default:
            break;
    }
}

- (void)startHouseList:(UIViewController *)vc
{
    self.startVC = vc;
    
    /** 户型列表 */
    YCHouseListViewController *houseListVC = [[YCHouseListViewController alloc] init];
    houseListVC.hidesBottomBarWhenPushed = YES;
    [self.startVC.navigationController pushViewController:houseListVC animated:NO];
    
    houseListVC.shareBlock = ^(NSString *url) {
        if (self.shareBlock)
        {
            self.shareBlock(url);
            NSLog(@"分享数据 %@", url);
        }
    };
    
    houseListVC.sendBlock = ^(NSString *flag) {
        
        if (self.sendBlock) {
    
            self.sendBlock(flag);
            NSLog(@"发送数据 %@", flag);
        }
    };
}

@end
