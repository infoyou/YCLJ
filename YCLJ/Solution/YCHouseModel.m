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
            
            self.houseId = (NSString *)dict[@"houseId"] ? (NSString *)dict[@"houseId"]:@"";
            self.name = (NSString *)dict[@"name"] ? (NSString *)dict[@"name"]:@"";
            self.lfFile = (NSString *)dict[@"lf_file"] ? (NSString *)dict[@"lf_file"]:@"";
            self.huxingFpath = (NSString *)dict[@"huxing_fpath"] ? (NSString *)dict[@"huxing_fpath"]:@"";
            self.areaFpath = (NSString *)dict[@"area_fpath"] ? (NSString *)dict[@"area_fpath"]:@"";
            self.cadFpath = (NSString *)dict[@"cad_fpath"] ? (NSString *)dict[@"cad_fpath"]:@"";
            
            self.zipFpath = (NSString *)dict[@"zipFpath"] ? (NSString *)dict[@"zipFpath"]:@"";
            self.type = [(NSNumber *)dict[@"type"] intValue];
            self.isUpload = [(NSNumber *)dict[@"isUpload"] intValue];
            self.isDelete = [(NSNumber *)dict[@"isDelete"] intValue];
            
            self.ownerId = (NSString *)dict[@"ownerId"] ? (NSString *)dict[@"ownerId"]:@"";
        }
    }
    
    return self;
}

@end
