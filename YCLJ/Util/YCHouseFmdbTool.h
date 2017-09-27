//
//  YCHouseFmdbTool.h
//  LVDatabaseDemo
//
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCOwnerModel;
@class YCHouseModel;

@interface YCHouseFmdbTool : NSObject

+ (void)firstUse;

#pragma mark - 从服务端保存数据到本地
+ (NSString *)insertOwnerArrayModel:(NSArray *)modelArray;
+ (NSString *)insertOwnerHouseArrayModel:(NSArray *)modelArray;

#pragma mark - 工长
+ (BOOL)queryWorkerData:(NSString *)mobile;
+ (void)insertWorker:(NSString *)workMobile
              workId:(NSString *)workId
            workName:(NSString *)workName;

#pragma mark - 业主
+ (NSString *)insertOwnerModel:(YCOwnerModel *)model;

#pragma mark - 户型方案
+ (BOOL)insertSolutionModel:(YCHouseModel *)model;
+ (BOOL)insertCopySolutionModel:(YCHouseModel *)model ownerId:(NSString *)ownerId;

+ (BOOL)querySolutionData:(NSString *)houseId;
+ (BOOL)queryOwnerSolutionZipFile:(NSString *)houseId;
+ (BOOL)queryOwnerSolutionObjFile:(NSString *)houseId;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryOwnerData:(NSString *)querySql;
+ (NSMutableDictionary *)queryOwnerSolutionNumber;
+ (NSMutableDictionary *)queryAllSolutionData:(NSString *)querySql;
+ (NSMutableDictionary *)queryOwnerSolutionData:(NSString *)houseId;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;


@end
