//
//  YCAppManager.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCOwnerModel;

@interface YCAppManager : NSObject

@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *workMobile;
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, copy) NSString *houseId;
@property (nonatomic, strong) YCOwnerModel *userModel;

+ (instancetype)instance;

- (void)updateHouseData:(NSString *)aHouseId;

- (NSString *)getHouseId;

#pragma mark - 上传户型数据文件
- (void)saveLocalHouseData:(NSString *)zipPath
                   houseId:(NSString *)houseId;

#pragma mark - 新增户型数据
- (void)transHouseData:(NSString *)houseId;

#pragma mark - 删除户型数据
- (void)transDeleteHouse:(NSString *)houseId;

#pragma mark - 上传户型数据文件
- (void)uploadFileMehtod:(NSString *)filePath
                 houseId:(NSString *)houseId
                    type:(NSString *)type;

- (void)transLoginData:(NSString *)userName passWord:(NSString *)passWord;
- (void)saveLocalOwnerData:(YCOwnerModel *)userModel;

@end
