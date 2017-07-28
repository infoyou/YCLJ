//
//  YCAppManager.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCAppManager : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *houseNo;
@property (nonatomic, copy) NSString *houseId;
@property (nonatomic, copy) NSString *zipPath;

+ (instancetype)instance;

- (void)updateHouseData:(NSString *)aHouseNo
                houseId:(NSString *)aHouseId;

- (NSString *)getHouseId;

- (void)transLoginData:(NSString *)userName passWord:(NSString *)passWord;
- (void)saveHouseData;
- (void)transHouseData;

@end
