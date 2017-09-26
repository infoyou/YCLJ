//
//  YCDrawViewController.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/19.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCDrawViewController : NSObject

@property (nonatomic, copy) void (^draw3DBlock)(UIViewController * drawVC);
@property (nonatomic, copy) void (^shareBlock)(NSString *url);
@property (nonatomic, copy) void (^sendBlock)(NSString *url);

+ (instancetype)instance;

- (void)setOwnerMobile:(NSString *)ownerMobile;

- (void)startDraw:(UIViewController *)vc model:(YCOwnerModel *)model;
- (void)startHouseList:(UIViewController *)vc;

@end
