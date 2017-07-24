//
//  houseInfoModel.h
//  lfsqSDKTest
//
//  Created by lreson on 2017/6/16.
//  Copyright © 2017年 kcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFHouseInfoModel : NSObject


/** 户型版本 */
@property (nonatomic, copy) NSString *houseVersion;
/** 户型名称 */
@property (nonatomic, copy) NSString *houseName;
/** 量房时间 */
@property (nonatomic, copy) NSString *measureDate;
/** 省*/
@property (nonatomic, copy) NSString *province;
/** 市*/
@property (nonatomic, copy) NSString *city;
/** 区*/
@property (nonatomic, copy) NSString *area;
/** 小区*/
@property (strong,nonatomic) NSString *community;
/** 详细地址*/
@property (nonatomic, copy) NSString *address;
/** 业主姓名 */
@property (nonatomic, copy) NSString *ownerName;
/** 联系方式*/
@property (nonatomic, copy) NSString *contactInformation;
/** 户型朝向*/
@property (nonatomic, copy) NSString *orientation;

@end
