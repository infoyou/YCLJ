//
//  YCDrawViewController.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/19.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTRootViewController.h"

@interface YCDrawViewController : NSObject

@property (nonatomic, copy) void (^draw3DBlock)(UIViewController * drawVC);

+ (instancetype)instance;

- (void)setOwnerMobile:(NSString *)ownerMobile;

- (void)startDraw:(UIViewController *)vc model:(YCOwnerModel *)model;

@end
