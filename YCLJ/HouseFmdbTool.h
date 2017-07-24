//
//  HouseFmdbTool.h
//  LVDatabaseDemo
//
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UserModel;
@class HouseModel;

@interface HouseFmdbTool : NSObject

// 插入模型数据
+ (NSString *)insertUserModel:(UserModel *)model;
+ (BOOL)insertSolutionModel:(HouseModel *)model userId:(NSString *)userId;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryUserData:(NSString *)querySql;
+ (NSDictionary *)queryUserSolutionNumber;
+ (NSDictionary *)querySolutionData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;


@end
