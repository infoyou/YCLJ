//
//  YCLJAppManager.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCLJAppManager : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *houseNo;
@property (nonatomic, copy) NSString *houseId;

+ (instancetype)instance;

- (void)updateHouseData:(NSString *)aHouseNo
                houseId:(NSString *)aHouseId;

- (NSString *)getHouseId;

@end
