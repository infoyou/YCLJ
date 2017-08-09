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

@property (nonatomic, copy) NSString *workOrderId;

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
