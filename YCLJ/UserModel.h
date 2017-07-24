//
//  UserModel.h
//  YCLJSDK
//
//  Created by Adam on 2017/7/11.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userId;   //本地数据库主键
@property (nonatomic, copy) NSString *name;     //姓名
@property (nonatomic, copy) NSString *mobile;   //手机号码
@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *area;     //面积

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
