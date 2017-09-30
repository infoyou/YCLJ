//
//  YCHouseModel.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/23.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCHouseModel : NSObject

@property (nonatomic, copy) NSString *houseId; //4,
@property (nonatomic, copy) NSString *name; //"华府豪庭",
@property (nonatomic, copy) NSString *lfFile;
@property (nonatomic, copy) NSString *areaFpath;
@property (nonatomic, copy) NSString *huxingFpath;
@property (nonatomic, copy) NSString *cadFpath;
@property (nonatomic, copy) NSString *zipFpath;
@property (nonatomic, copy) NSString *state; // 0,新图；1,爱福窝老图

@property (nonatomic, copy) NSString *creatDate; //1497520802,
@property (nonatomic, copy) NSString *updateDate; //1497520802

@property (nonatomic, copy) NSString *zipUrl;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger isUpload;
@property (nonatomic, assign) NSInteger isDelete;

@property (nonatomic, copy) NSString *ownerId;   //本地数据库从键

//id, ownerId, houseId, filePath

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
