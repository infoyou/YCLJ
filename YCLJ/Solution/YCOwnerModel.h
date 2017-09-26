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

@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *type; // 房屋类型
@property (nonatomic, copy) NSString *style;// 房屋属性 is_new

@property (nonatomic, copy) NSString *workOrderId; // 工单
@property (nonatomic, copy) NSString *houseId; //绘制户型Id

@property (nonatomic, copy) NSString *createTime; //创建时间

@property (nonatomic, strong) NSArray *houseArray;

+ (instancetype)newWithDict:(NSDictionary *)dict;
+ (instancetype)newWithUserDict:(NSDictionary *)dict;

@end
