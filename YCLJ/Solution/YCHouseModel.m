//
//  YCHouseModel.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/23.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCHouseModel.h"

@implementation YCHouseModel

+ (instancetype)newWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init])
    {
        if (dict != nil) {
            
            self.houseId = (NSString *)dict[@"house_num"] ? (NSString *)dict[@"house_num"]:@"";
            self.name = (NSString *)dict[@"name"] ? (NSString *)dict[@"name"]:@"";
            self.lfFile = (NSString *)dict[@"lf_file"] ? (NSString *)dict[@"lf_file"]:@"";
            self.huxingFpath = (NSString *)dict[@"huxing_fpath"] ? (NSString *)dict[@"huxing_fpath"]:@"";
            self.areaFpath = (NSString *)dict[@"area_file"] ? (NSString *)dict[@"area_file"]:@"";
            self.cadFpath = (NSString *)dict[@"cad_file"] ? (NSString *)dict[@"cad_file"]:@"";
            self.state = (NSString *)dict[@"state"] ? (NSString *)dict[@"state"]:@"";
            
            self.zipFpath = (NSString *)dict[@"pkg"] ? (NSString *)dict[@"pkg"]:@"";
            self.type = [(NSNumber *)dict[@"is_copy"] intValue];
            self.isUpload = [(NSNumber *)dict[@"isUpload"] intValue];
            self.isDelete = [(NSNumber *)dict[@"isDelete"] intValue];
            
            self.ownerId = (NSString *)dict[@"work_order_id"] ? (NSString *)dict[@"work_order_id"]:@"";
            
            self.creatDate = (NSString *)dict[@"create_time"] ? (NSString *)dict[@"create_time"]:@"";
            self.updateDate = (NSString *)dict[@"modify_time"] ? (NSString *)dict[@"modify_time"]:@"";
        }
    }
    
    return self;
}

@end
