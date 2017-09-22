//
//  YCAppManager.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCAppManager.h"
#import "ZTHttpTool.h"
#import "YCHouseFmdbTool.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"
#import "LFDrawSDKAPI.h"
#import "YCHouseListViewController.h"

@implementation YCAppManager

static YCAppManager *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCAppManager alloc] init];
    });
    
    return singleton;
}

- (BOOL) isHengping
{
    return _hengping;
}

- (void) setHengping:(BOOL)flag
{
    _hengping = flag;
}

- (void)updateHouseData:(NSString *)aHouseId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:aHouseId forKey:@"houseId"];
    
    [_def synchronize];
}

- (NSString *)getHouseId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"houseId"];
}

#pragma mark - 注册工长
- (void)registerWorkerData:(NSString *)strMobile
                    workId:(NSString *)workId
                  workName:(NSString *)workName
{
    if (![YCHouseFmdbTool queryWorkerData:strMobile]) {
        // 工长第一次登录 或 换手机
        [YCHouseFmdbTool firstUse];
        [YCHouseFmdbTool insertWorker:strMobile
                               workId:workId
                             workName:workName];
    }
    
}

#pragma mark - 获取户型id
- (void)transWorkId:(NSString *)workId
        ownerMobile:(NSString *)ownerMobile
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:workId forKey:@"chief_id"];
    [dataDict setObject:ownerMobile forKey:@"owner_mobile"];
    
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
                         
                         NSLog(@"house_num %@", house_num);
                         
                         if (self.GetOwnerHouseId)
                         {
                             // 调用回调函数
                             self.GetOwnerHouseId(house_num, lf_file, @"");
                         }
                         
                     } else {
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                         
                         if (self.GetOwnerHouseId)
                         {
                             self.GetOwnerHouseId(@"", @"", [backDic valueForKey:@"msg"]); // 调用回调函数
                         }
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
    
    NSLog(@"transHouseId %@", @"结束");
}

#pragma mark - 用户登录
- (void)transLoginData:(NSString *)userName passWord:(NSString *)passWord
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:userName forKey:@"username"];
    [dataDict setObject:passWord forKey:@"password"];
    
    NSMutableDictionary *paramDict = [ZTCommonUtils getParamDict:dataDict];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/signin/", YC_HOST_URL];
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         
                         NSString *ownerId = resultDict[@"user_id"];
                         NSString *mobile = resultDict[@"mobile"];
                         NSString *userName = resultDict[@"username"];
                         
                         NSLog(@"ownerId %@", ownerId);
                         NSLog(@"mobile %@", mobile);
                         NSLog(@"userName %@", userName);
                         
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 保存用户数据
- (void)saveLocalOwnerData:(YCOwnerModel *)userModel
{
    
    // 保存业主数据
    [YCHouseFmdbTool insertOwnerModel:userModel];
    
    // 更改本地数据
    NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET ownerId = '%@' where houseId = '%@'", userModel.mobile, _houseId];
    [YCHouseFmdbTool modifyData:modifySql];
    
    // 上传户型数据到服务端
    [self transHouseData:_houseId];
}

#pragma mark - 保存户型数据
- (void)saveLocalHouseData:(NSString *)zipPath
                   houseId:(NSString *)houseId
{
    _houseId = houseId;
    NSArray *array = [zipPath componentsSeparatedByString:@".zip"];
    NSString *zipFpath = array[0];
    
    NSMutableDictionary *houseDict = [NSMutableDictionary dictionary];
    [houseDict setValue:houseId forKey:@"house_num"];
    [houseDict setValue:zipFpath forKey:@"pkg"];
    [houseDict setValue:HOUSE_SOLUTION_ORIGN_TYPE forKey:@"is_copy"];
    [houseDict setValue:0 forKey:@"isUpload"];
    [houseDict setValue:0 forKey:@"isDelete"];
    
    YCHouseModel *houseModel = [YCHouseModel newWithDict:houseDict];
    [YCHouseFmdbTool insertSolutionModel:houseModel];
    
}

#pragma mark - 新增户型数据
- (void)transHouseData:(NSString *)houseId
{
    
    NSMutableDictionary *paramDict = [YCHouseFmdbTool queryOwnerSolutionData:houseId];
    [paramDict setValue:_workId forKey:@"chief_id"];
    [paramDict setValue:_workName forKey:@"chief_name"];
    [paramDict setValue:_workMobile forKey:@"chief_mobile"];
    [paramDict setValue:houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/save/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ||
                         [errCodeStr integerValue] == 10001 ) {
                         
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         
                         NSString *strHouseId = resultDict[@"house_num"];
                         NSString *strLFfile = resultDict[@"lf_file"];
                         
                         // 如果上传过zip文件，直接更新
                         if ([YCHouseFmdbTool queryOwnerSolutionZipFile:strHouseId]) {
                             // 检查Solution是否有zipURL，如果有更新
                             [self transUpdateHouse];
                         }
                         
                         // 更改本地数据
                         NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET lfFile = '%@' where houseId = '%@'", strLFfile, strHouseId];
                         [YCHouseFmdbTool modifyData:modifySql];
                         
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

#pragma mark - copy户型数据
- (void)transCopyHouseData:(NSString *)houseId
{
    
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
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 更新户型数据
- (void)transUpdateHouse
{
    
    NSMutableDictionary *paramDict = [YCHouseFmdbTool queryOwnerSolutionData:_houseId];
    [paramDict setValue:_houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/update/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         
                         NSString *strHouseId = resultDict[@"house_num"];
                         NSString *strLFfile = resultDict[@"lf_file"];
                         
                         // 更改本地数据
                         NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET lfFile = '%@' where houseId = '%@'", strLFfile, strHouseId];
                         [YCHouseFmdbTool modifyData:modifySql];
                         
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 删除户型数据
- (void)transDeleteHouse:(NSString *)houseId
{
    
    NSMutableDictionary *paramDict = [YCHouseFmdbTool queryOwnerSolutionData:houseId];
    [paramDict setValue:houseId forKey:@"house_num"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/house/delete/", YC_HOST_URL];
    
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         NSLog(@"删除拆改图成功");
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/zipfile/upload/", YC_HOST_URL];
    // 注意：以后如果一个方法，要传很多参数，就把参数包装成一个模型
    [ZTHttpTool upload:urlStr parameters:parameters uploadParam:uploadP success:^(id json) {
        
        NSDictionary *backDic = json;
        
        if (backDic != nil) {
            
            NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
            
            if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                
                NSDictionary *resultDict = [backDic valueForKey:@"data"];
                NSString *zipFileUrl = resultDict[@"file_url"];
                
                NSLog(@"zipFileUrl %@", zipFileUrl);
                
                // 拆改图直接上传 || 原始图需要有zipUrl地址直接通知
                if ([_houseId hasSuffix:@"_1"] ||
                    [YCHouseFmdbTool queryOwnerSolutionZipFile:houseId])
                {
                    // save过 直接通知
                    [self transUpdateHouse];
                }
                
                // 更新Solution zipUrl 字段
                NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET zipUrl = '%@', updateDate = '%@', isUpload = 1 where houseId = '%@'", zipFileUrl, [ZTCommonUtils getCurrentTime], _houseId];
                [YCHouseFmdbTool modifyData:modifySql];
                
            } else {
                
                NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
            }
        }
        
    } failure:^(NSError *error) {
        //        if (failure) {
        //            failure(error);
        //        }
    }];
}

#pragma mark - 上传户型数据文件
- (void)uploadFileMehtod:(NSString *)filePath
                 houseId:(NSString *)houseId
{
    
    _houseId = houseId;
    [self transZipData:filePath houseId:houseId type:@"0"];
    
    NSArray *array = [filePath componentsSeparatedByString:@".zip"];
    NSString *zipFpath = array[0];
    NSString *u3dDir = [NSString stringWithFormat:@"%@_obj", zipFpath];
    
    //    NSLog(@"u3dDir is dir %@", u3dDir);
    if ([ZTCommonUtils isExistDirName:u3dDir]) {
        
        //        NSLog(@"u3dDir is exist");
        //        NSMutableArray *pathArray = [ZTCommonUtils allFilesAtPath:u3dDir];
        //        NSInteger count = pathArray.count;
        //
        //        for (NSInteger i=0; i<count; i++) {
        //            NSLog(@"u3dDir pathArray[%d] = %@", i, pathArray[i]);
        //        }
        
        NSString *u3dZipFpath = [NSString stringWithFormat:@"%@.zip", u3dDir];
        [ZTCommonUtils zipFileDir:u3dZipFpath sourcePath:u3dDir];
        
        // 存在3d文件，上传
        [self transZipData:u3dZipFpath houseId:houseId type:@"1"];
    }
    
}

@end
