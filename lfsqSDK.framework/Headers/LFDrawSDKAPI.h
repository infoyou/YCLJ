//
//  LFDrawSDKAPI.h
//  lfsqSDKTest
//
//  Created by lreson on 2017/6/16.
//  Copyright © 2017年 kcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFHouseInfoModel.h"

typedef void(^ getHouseIDBlock)(NSString * _Nonnull HouseID);

typedef void(^ getCopyHouseIDSucceedBlock)(NSString * _Nonnull HouseID);


@interface LFDrawSDKAPI : NSObject


/** 获取 json文件 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseJsonDataPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 预览图 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHousePicPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 CAD文件(.dxf) 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseDXFDataPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 面积json文件(.json) 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseAreaJSONDataPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 3D文件(.obj) 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseU3DDataPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 3D文件(.mtl) 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseU3DMtlPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 户型ZIP文件(.zip) 保存路径  无该户型数据时为 @""*/
+(NSString*_Nullable)getHouseZIPDataPathWithHouseID:(NSString*_Nonnull)houseID;


/** 获取 户型信息 */
+(LFHouseInfoModel*_Nullable)getHouseInfoWithHouseID:(NSString*_Nonnull)houseID;


/** 判断 本地是否有该户型存在 */
+(BOOL)isHouseInloadLocalData:(NSString*_Nonnull)houseID;


/** 保存户型时 ，获取户型ID   ！！！不推荐使用 */
+(void)getHouseIDWhenSaveHouse:(getHouseIDBlock _Nullable )getHouseIDBlock;


/** 拿到户型数据 的根目录 */
+(NSString*_Nullable)getHouseFilePathWithHouseID:(NSString*_Nullable)houseID;


/** 创建obj文件夹 */
+(NSString*_Nullable)createHouseObjFilePathHouseID:(NSString*_Nullable)houseID;








@end
