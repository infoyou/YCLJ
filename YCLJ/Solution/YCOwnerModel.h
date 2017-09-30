//
//  YCOwnerModel.h
//  YCLJSDK
//
//  Created by Adam on 2017/7/11.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCOwnerModel : NSObject

@property (nonatomic, copy) NSString *ownerId;   //本地数据库主键
@property (nonatomic, copy) NSString *name;     //姓名
@property (nonatomic, copy) NSString *mobile;   //手机号码
@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *area;     //面积

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *style;

@property (nonatomic, copy) NSString *createTime; //创建时间

@property (nonatomic, copy) NSString *workOrderId; //工单
@property (nonatomic, copy) NSString *houseId; //绘制户型Id

@property (nonatomic, strong) NSMutableArray *houseArray;
@property (nonatomic, strong) NSMutableDictionary *houseObjectDict;

@property (nonatomic, copy) NSString *state; //是否是爱福窝数据

+ (instancetype)newWithDict:(NSDictionary *)dict;
+ (instancetype)newWithUserDict:(NSDictionary *)dict;

@end
