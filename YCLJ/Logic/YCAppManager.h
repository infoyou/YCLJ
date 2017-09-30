//
//  YCAppManager.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTLoaddingView.h"

@class YCOwnerModel;

@interface YCAppManager : NSObject
{
    ZTLoaddingView * Loadding;
}

@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *workMobile;
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, copy) NSString *houseId;
@property (nonatomic, strong) YCOwnerModel *userModel;

@property (nonatomic, copy) void(^GetHouseFile)(NSString *lfFile, NSString *msg);

@property (nonatomic, copy) void(^GetOwnerHouseId)(NSString *houseId, NSString *lfFile, NSString *msg);

+ (instancetype)instance;

- (void)updateTempHouseData:(NSString *)aHouseId;

- (NSString *)getTempHouseId;

#pragma mark - 获取户型lf.file 通过houseId
- (void)transHouseFileById:(NSString *)houseId;

#pragma mark - 获取户型id
- (void)transWorkId:(NSString *)workId
        workOrderId:(NSString *)workOrderId;

#pragma mark - 注册工长
- (void)registerWorkerData:(NSString *)strMobile
                    workId:(NSString *)workId
                  workName:(NSString *)workName;

#pragma mark - 上传户型数据文件
- (void)saveLocalHouseData:(NSString *)zipPath
                   houseId:(NSString *)houseId;

#pragma mark - copy户型数据
- (void)transCopyHouseData:(NSString *)houseId;

#pragma mark - 删除户型数据
- (void)transDeleteHouse:(NSString *)houseId;

#pragma mark - 上传户型数据文件
- (void)uploadFileMehtod:(NSString *)filePath
                 houseId:(NSString *)houseId;

- (void)saveLocalOwnerData:(YCOwnerModel *)userModel;

#pragma mark - show msg
- (void)showWithText:(NSString *)msg;

#pragma mark - loading msg
- (void)showLoadingMsg:(NSString *)msg;

- (void)closeLoadingMsg;

@end
