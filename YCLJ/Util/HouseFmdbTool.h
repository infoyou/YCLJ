//
//  HouseFmdbTool.h
//  LVDatabaseDemo
//
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class YCOwnerModel;
@class YCHouseModel;

@interface HouseFmdbTool : NSObject

+ (void)firstUse;

#pragma mark - 工长
+ (BOOL)queryWorkerData:(NSString *)mobile;
+ (NSString *)insertWorker:(NSString *)workMobile
                    workId:(NSString *)workId;

#pragma mark - 业主
+ (NSString *)insertOwnerModel:(YCOwnerModel *)model;

#pragma mark - 户型
+ (BOOL)insertSolutionModel:(YCHouseModel *)model userId:(NSString *)userId;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryOwnerData:(NSString *)querySql;
+ (NSDictionary *)queryOwnerSolutionNumber;
+ (NSDictionary *)querySolutionData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;


@end
