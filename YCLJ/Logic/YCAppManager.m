//
//  YCAppManager.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCAppManager.h"
#import "ZTHttpTool.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"
#import "LFDrawSDKAPI.h"
#import "YCHouseListViewController.h"
#import "ZTLoaddingView.h"
#import "ZTToastView.h"

@implementation YCAppManager

static YCAppManager *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCAppManager alloc] init];
    });
    
    return singleton;
}

#pragma mark - 更改临时图户型Id
- (void)updateTempHouseData:(NSString *)aHouseId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:aHouseId forKey:@"kSDKHouseID_LFSQ"];
    
    [_def synchronize];
}

#pragma mark - 获取临时图户型Id
- (NSString *)getTempHouseId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kSDKHouseID_LFSQ"];
}

#pragma mark - 注册工长
- (void)registerWorkerData:(NSString *)strMobile
                    workId:(NSString *)workId
                  workName:(NSString *)workName
{
    
    if (![[self getWorkMobile] isEqualToString:strMobile]) {
        
        [self updateUserData:workId
                  workMobile:strMobile
                    workName:workName];
        
        // 清除临时图
        [[YCAppManager instance] updateTempHouseData:@""];

    } else {
        
        [self loadWorkMsg];
    }
}

- (void)loadWorkMsg
{
    self.workId = [[NSUserDefaults standardUserDefaults] objectForKey:@"workId"];
    self.workMobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"workMobile"];
    self.workName = [[NSUserDefaults standardUserDefaults] objectForKey:@"workName"];
}

- (void)updateUserData:(NSString *)workId
            workMobile:(NSString *)workMobile
              workName:(NSString *)workName
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if(workId == nil) {
        
        [_def removeObjectForKey:@"workId"];
        [_def removeObjectForKey:@"workMobile"];
        [_def removeObjectForKey:@"workName"];
    } else {
        
        [_def setObject:workId forKey:@"workId"];
        [_def setObject:workMobile forKey:@"workMobile"];
        [_def setObject:workName forKey:@"workName"];
    }
    
    [_def synchronize];
    
    self.workId = workId;
    self.workMobile = workMobile;
    self.workName = workName;
}

- (NSString *)getWorkMobile
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"workMobile"];
}

#pragma mark - 获取户型lf.file 通过houseId
- (void)transHouseFileById:(NSString *)houseId
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/detail/%@/", YC_HOST_URL, houseId];
    
    [ZTHttpTool get:urlStr
             params:nil
            success:^(id json) {
                
                NSDictionary *backDic = json;
                
                if (backDic != nil) {
                    
                    NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                    
                    if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                        
                        NSDictionary *resultDict = [backDic valueForKey:@"data"];
                        NSString *lf_file = resultDict[@"lf_file"];
                        
                        if (self.GetHouseFile)
                        {
                            // 调用回调函数
                            self.GetHouseFile(lf_file, @"");
                        }
                    } else {
                        
                        NSString *msg = [backDic valueForKey:@"msg"];
                        if (self.GetHouseFile)
                        {
                            // 调用回调函数
                            self.GetHouseFile(nil, msg);
                        }
                        DLog(@"back msg is %@", msg);
                        [self showWithText:msg];
                    }
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败-%@", error);
            }];
}

#pragma mark - 获取户型id
- (void)transWorkId:(NSString *)workId
        workOrderId:(NSString *)workOrderId
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:workId forKey:@"chief_id"];
    [dataDict setObject:workOrderId forKey:@"work_order_id"];
    
    NSMutableDictionary *paramDict = [ZTCommonUtils getParamDict:dataDict];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/house-num/", YC_HOST_URL];
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         
                         NSString *house_num = resultDict[@"house_num"];
                         NSString *lf_file = resultDict[@"lf_file"];
                         
                         DLog(@"house_num %@", house_num);
                         
                         if (self.GetOwnerHouseId)
                         {
                             // 调用回调函数
                             self.GetOwnerHouseId(house_num, lf_file, @"");
                         }
                         
                     } else {
                         [self showWithText:[backDic valueForKey:@"msg"]];
                         
                         if (self.GetOwnerHouseId)
                         {
                             self.GetOwnerHouseId(@"", @"", [backDic valueForKey:@"msg"]); // 调用回调函数
                         }
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 DLog(@"请求失败-%@", error);
             }];
    
    DLog(@"transHouseId %@", @"结束");
}

#pragma mark - 保存用户数据
- (void)saveLocalOwnerData:(YCOwnerModel *)ownerModel
{
    
    // 上传户型数据到服务端
    [self transHouseData:ownerModel];
}

#pragma mark - 保存户型数据
- (void)saveHouseParam:(NSString *)zipPath
               houseId:(NSString *)houseId
{
    _houseId = houseId;
    _zipPath = zipPath;
}

#pragma mark - 新增户型数据
- (void)transHouseData:(YCOwnerModel *)ownerModel;
{
    
    _ownerModel = ownerModel;
    DLog(@"===== save =====");
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:_ownerModel.mobile forKey:@"owner_mobile"];
    [paramDict setObject:@"0" forKey:@"is_copy"];
    [paramDict setObject:_ownerModel.workOrderId forKey:@"work_order_id"];

    [paramDict setValue:_workId forKey:@"chief_id"];
    [paramDict setValue:_workName forKey:@"chief_name"];
    [paramDict setValue:_workMobile forKey:@"chief_mobile"];
    [paramDict setValue:_houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/save/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         /**
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         NSString *strHouseId = resultDict[@"house_num"];
                         NSString *strLFfile = resultDict[@"lf_file"];
                         */
                         
                         if (self.GetSaveResult)
                         {
                             // 调用回调函数
                             self.GetSaveResult(@"");
                         }
                     } else if ([errCodeStr integerValue] == 10001) {
                         
                         if (self.GetSaveResult)
                         {
                             // 调用回调函数
                             self.GetSaveResult(@"");
                         }
                     } else {
                         
                         NSString *msg = [backDic valueForKey:@"msg"];
                         if (self.GetSaveResult)
                         {
                             // 调用回调函数
                             self.GetSaveResult(msg);
                         }
                         DLog(@"back msg is %@", msg);
                         [self showWithText:msg];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 DLog(@"请求失败-%@", error);
             }];
}

#pragma mark - copy户型数据
- (void)transCopyHouseData:(NSString *)houseId
{
    DLog(@"===== copy house data =====");
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/copy/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         DLog(@"copy success");
                         if (self.GetCopyResult)
                         {
                             // 调用回调函数
                             self.GetCopyResult(@"");
                         }
                     } else {
                         
                         NSString *msg = [backDic valueForKey:@"msg"];
                         if (self.GetCopyResult)
                         {
                             // 调用回调函数
                             self.GetCopyResult(msg);
                         }
                         DLog(@"back msg is %@", msg);
                         [self showWithText:msg];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 DLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 更新户型数据
- (void)transUpdateHouse
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:_houseId forKey:@"house_num"];
    [paramDict setValue:_ownerModel.mobile forKey:@"owner_mobile"];
    [paramDict setValue:_ownerModel.workOrderId forKey:@"work_order_id"];
    if ([_houseId hasSuffix:@"_1"]) {
        [paramDict setValue:@"1" forKey:@"is_copy"];
    } else {
        [paramDict setValue:@"0" forKey:@"is_copy"];
    }
    
    DLog(@"===== update =====");
    [paramDict setValue:_houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/update/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         // 清除临时图
                         [[YCAppManager instance] updateTempHouseData:@""];
                         
                         if (self.GetUpdateResult)
                         {
                             // 调用回调函数
                             self.GetUpdateResult(@"");
                         }
                     } else {
                         
                         NSString *msg = [backDic valueForKey:@"msg"];
                         if (self.GetUpdateResult)
                         {
                             // 调用回调函数
                             self.GetUpdateResult(msg);
                         }
                         DLog(@"back msg is %@", msg);
                         [self showWithText:msg];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 DLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 删除户型数据
- (void)transDeleteHouse:(NSString *)houseId
              ownerModel:(YCOwnerModel *)ownerModel
{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:ownerModel.mobile forKey:@"owner_mobile"];
    [paramDict setObject:@"1" forKey:@"is_copy"];
    [paramDict setObject:ownerModel.workOrderId forKey:@"work_order_id"];
    [paramDict setValue:houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/delete/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         DLog(@"删除拆改图成功");
                         if (self.GetDelResult)
                         {
                             // 调用回调函数
                             self.GetDelResult(@"");
                         }
                     } else {
                         
                         NSString *msg = [backDic valueForKey:@"msg"];
                         if (self.GetDelResult)
                         {
                             // 调用回调函数
                             self.GetDelResult(msg);
                         }
                         DLog(@"back msg is %@", msg);
                         [self showWithText:msg];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 DLog(@"请求失败-%@", error);
             }];
}

- (void)transZipData:(NSString *)filePath
             houseId:(NSString *)houseId
                type:(NSString *)type
{
    // 创建参数模型
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:type forKey:@"zip_type"]; // 0:普通zip包, 1: obj的zip包
    [parameters setObject:_houseId forKey:@"house_num"]; // 科创houseID
    
    NSFileManager * fm;
    fm = [NSFileManager defaultManager];
    // 创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改
    NSData * fileData;
    fileData = [fm contentsAtPath:filePath];
    
    // 创建上传的模型
    ZTUploadParamModel *uploadP = [[ZTUploadParamModel alloc] init];
    uploadP.data = fileData;
    uploadP.name = @"file";
    uploadP.fileName = @".zip";
    uploadP.mimeType = @"application/zip";
    
    DLog(@"===== zipfile upload =====");
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/zipfile/upload/", YC_HOST_URL];
    // 注意：以后如果一个方法，要传很多参数，就把参数包装成一个模型
    [ZTHttpTool upload:urlStr parameters:parameters uploadParam:uploadP success:^(id json) {
        
        NSDictionary *backDic = json;
        
        if (backDic != nil) {
            
            NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
            
            if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                
                NSDictionary *resultDict = [backDic valueForKey:@"data"];
                NSString *zipFileUrl = resultDict[@"file_url"];
                
                DLog(@"zipFileUrl %@", zipFileUrl);
                
                // Update
                [self transUpdateHouse];
                
                if (self.GetUploadResult)
                {
                    // 调用回调函数
                    self.GetUploadResult(@"");
                }
            } else {
                
                NSString *msg = [backDic valueForKey:@"msg"];
                if (self.GetUploadResult)
                {
                    // 调用回调函数
                    self.GetUploadResult(msg);
                }
                DLog(@"back msg is %@", msg);
                [self showWithText:msg];
            }
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"请求失败-%@", error);
    }];
}

- (void)trans3dData:(NSString *)filePath
            houseId:(NSString *)houseId
               type:(NSString *)type
{
    // 创建参数模型
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:type forKey:@"zip_type"]; // 0:普通zip包, 1: obj的zip包
    [parameters setObject:_houseId forKey:@"house_num"]; // 科创houseID
    
    NSFileManager * fm;
    fm = [NSFileManager defaultManager];
    // 创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改
    NSData * fileData;
    fileData = [fm contentsAtPath:filePath];
    
    // 创建上传的模型
    ZTUploadParamModel *uploadP = [[ZTUploadParamModel alloc] init];
    uploadP.data = fileData;
    uploadP.name = @"file";
    uploadP.fileName = @".zip";
    uploadP.mimeType = @"application/zip";
    
    DLog(@"===== zipfile upload =====");
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/zipfile/upload/", YC_HOST_URL];
    // 注意：以后如果一个方法，要传很多参数，就把参数包装成一个模型
    [ZTHttpTool upload:urlStr parameters:parameters uploadParam:uploadP success:^(id json) {
        
        NSDictionary *backDic = json;
        
        if (backDic != nil) {
            
            NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
            
            if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                
                NSDictionary *resultDict = [backDic valueForKey:@"data"];
                NSString *zipFileUrl = resultDict[@"file_url"];
                
                DLog(@"zipFileUrl %@", zipFileUrl);
                
                // Update
                [self transUpdateHouse];
                
                // 3d文件 暂不回调
                /*
                if (self.GetUploadResult)
                {
                    // 调用回调函数
                    self.GetUploadResult(@"");
                }
                 */
            } else {
                
                NSString *msg = [backDic valueForKey:@"msg"];
                // 3d文件 暂不回调
                /*
                if (self.GetUploadResult)
                {
                    // 调用回调函数
                    self.GetUploadResult(msg);
                }
                 */
                DLog(@"back msg is %@", msg);
                [self showWithText:msg];
            }
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"请求失败-%@", error);
    }];
}

#pragma mark - 上传户型数据文件
- (void)uploadFileMehtod
{
    
    // zip
    [self transZipData:_zipPath houseId:_houseId type:@"0"];
    
    // 3d
    NSArray *array = [_zipPath componentsSeparatedByString:@".zip"];
    NSString *zipFpath = array[0];
    NSString *u3dDir = [NSString stringWithFormat:@"%@_obj", zipFpath];
    
    DLog(@"u3dDir is dir %@", u3dDir);
    if ([ZTCommonUtils isExistDirName:u3dDir]) {
        
        NSString *u3dZipFpath = [NSString stringWithFormat:@"%@.zip", u3dDir];
        [ZTCommonUtils zipFileDir:u3dZipFpath sourcePath:u3dDir];
        
        // 存在3d文件，上传
        [self trans3dData:u3dZipFpath houseId:_houseId type:@"1"];
    }
}

#pragma mark - show msg
- (void)showWithText:(NSString *)msg
{
    /*
    [ZTToastView showToastViewWithText:msg
                           andDuration:1
                             andCorner:5
                         andParentView:[self getCurrentVC].view];
     */
}

#pragma mark - loading msg
- (void)showLoadingMsg:(NSString *)msg
{
    Loadding = [ZTLoaddingView initWithParentView:[self getCurrentVC].view];
    [Loadding showLoaddingViewWithText:msg andStyle:0];
}

- (void)closeLoadingMsg
{
    [Loadding dismissLoaddingView];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
