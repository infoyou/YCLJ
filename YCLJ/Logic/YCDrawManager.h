//
//  YCDrawManager.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/19.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCOwnerModel;
@class YCHouseModel;

@interface YCDrawManager : NSObject

@property (nonatomic, copy) void (^draw3DBlock)(UIViewController * drawVC);
@property (nonatomic, copy) void (^shareBlock)(NSString *url);
@property (nonatomic, copy) void (^sendBlock)(NSString *flag);

+ (instancetype)instance;

- (void)drawHouse:(NSString *)houseId type:(NSInteger)type;

- (void)startDraw:(UIViewController *)vc model:(YCOwnerModel *)model;

- (void)startHouseList:(UIViewController *)vc;
- (void)startDraw:(UIViewController *)vc houseModel:(YCHouseModel *)houseModel;

@end
