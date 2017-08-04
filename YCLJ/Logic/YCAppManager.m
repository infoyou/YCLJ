//
//  YCAppManager.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCAppManager.h"
#import "ZTHttpTool.h"
#import "HouseFmdbTool.h"
#import "YCHouseModel.h"
#import "YCOwnerModel.h"

@implementation YCAppManager

static YCAppManager *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCAppManager alloc] init];
    });
    
    return singleton;
}

- (void)updateUserData:(NSString *)aUserId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if(_userId == nil) {
        
        [_def removeObjectForKey:@"userId"];
    } else {
        
        [_def setObject:aUserId forKey:@"userId"];
    }
    
    [_def synchronize];
}

- (void)updateHouseData:(NSString *)aHouseNo
                houseId:(NSString *)aHouseId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:aHouseNo forKey:@"no"];
    [_def setObject:aHouseId forKey:@"houseId"];

    [_def synchronize];
}

- (NSString *)getHouseId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"houseId"];
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
                         
                         NSString *userId = resultDict[@"user_id"];
                         NSString *mobile = resultDict[@"mobile"];
                         NSString *userName = resultDict[@"username"];
                         
                         NSLog(@"userId %@", userId);
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

- (void)saveHouseData:(YCOwnerModel *)userModel
{
    
    // 保存业主数据
    [YCAppManager instance].userId = [HouseFmdbTool insertOwnerModel:userModel];
    
    // 保存户型数据
    NSArray *array = [_zipPath componentsSeparatedByString:@".zip"];
    NSString *zipFpath = array[0];
    
    NSMutableDictionary *houseDict = [NSMutableDictionary dictionary];
    [houseDict setValue:@"" forKey:@"no"]; // 先保存到本地，同步到服务器再修改字段
    [houseDict setValue:_houseId forKey:@"houseId"];
    [houseDict setValue:zipFpath forKey:@"zipFpath"];
    [houseDict setValue:HOUSE_SOLUTION_ORIGN_TYPE forKey:@"type"];
    [houseDict setValue:0 forKey:@"isUpload"];
    [houseDict setValue:0 forKey:@"isDelete"];
    
    YCHouseModel *houseModel = [YCHouseModel newWithDict:houseDict];
    [HouseFmdbTool insertSolutionModel:houseModel userId:_userId];
    
}

#pragma mark - 新增户型数据
- (void)transHouseData
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    //    [dataDict setObject:_popTxtName.text forKey:@"name"];
    
    NSMutableDictionary *paramDict = [ZTCommonUtils getParamDict:dataDict];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/plan/create/", YC_HOST_URL];
    [ZTHttpTool post:urlStr
              params:paramDict
             success:^(id json) {
                 
                 NSDictionary *backDic = json;
                 
                 if (backDic != nil) {
                     
                     NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
                     
                     if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                         
                         NSDictionary *resultDict = [backDic valueForKey:@"data"];
                         
//                         _houseName = resultDict[@"name"];
                         _solutionId = resultDict[@"no"];
                         
                         // 更改本地数据
                         NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET solutionId = '%@' where houseId = '%@'", _solutionId, _houseId];
                         [HouseFmdbTool modifyData:modifySql];

                         // 上传数据文件到服务端
                         [self uploadFileMehtod:_zipPath no:_solutionId];
                     } else {
                         
                         NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                         //[self showHUDWithText:[backDic valueForKey:@"msg"]];
                     }
                 }
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"请求失败-%@", error);
             }];
}

#pragma mark - 上传户型数据文件
- (void)uploadFileMehtod:(NSString *)filePath no:(NSString *)no
{
    
    // 创建参数模型
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:no forKey:@"no"]; // 服务端房型
    [parameters setObject:@"5" forKey:@"type"];
    [parameters setObject:_houseId forKey:@"houseId"]; // 科创houseID
    
    NSFileManager * fm;
    fm = [NSFileManager defaultManager];
    //创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改
    NSData * fileData;
    fileData = [fm contentsAtPath:filePath];
    
    // 创建上传的模型
    ZTUploadParamModel *uploadP = [[ZTUploadParamModel alloc] init];
    uploadP.data = fileData;
    uploadP.name = @"upfile";
    uploadP.fileName = @".zip";
    uploadP.mimeType = @"application/zip";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/leju/plan/upload_file/", YC_HOST_URL];
    // 注意：以后如果一个方法，要传很多参数，就把参数包装成一个模型
    [ZTHttpTool upload:urlStr parameters:parameters uploadParam:uploadP success:^(id json) {
        
        NSDictionary *backDic = json;
        
        if (backDic != nil) {
            
            NSString *errCodeStr = (NSString *)[backDic valueForKey:@"code"];
            
            if ( [errCodeStr integerValue] == SUCCESS_DATA ) {
                
                NSDictionary *resultDict = [backDic valueForKey:@"data"];
                
                NSString *no = resultDict[@"no"];
                NSString *zipFileUrl = resultDict[@"fpath_url"];
                
                NSLog(@"no %@", no);
                NSLog(@"zipFileUrl %@", zipFileUrl);
                
                // 更新Solution zipUrl 字段
                NSString *modifySql = [NSString stringWithFormat:@"UPDATE Solution SET zipUrl = '%@', isUpload = 1 where houseId = '%@'", zipFileUrl, _houseId];
                [HouseFmdbTool modifyData:modifySql];
                
            } else {
                
                NSLog(@"back msg is %@", [backDic valueForKey:@"msg"]);
                //[self showHUDWithText:[backDic valueForKey:@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        //        if (failure) {
        //            failure(error);
        //        }
    }];
}

@end
