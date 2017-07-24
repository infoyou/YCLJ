//
//  LFDrawManager.h
//  lfsq
//
//  Created by lreson on 2017/6/14.
//  Copyright © 2017年 kcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LFDrawManager : NSObject


/**
 app启动时，用UserID初始化量房神器SDK
 */
+(void)registerLfsqSDKWithUserID:(NSString*)UserID;


/**
 初始化绘图控制器，创建一个新户型
 */
+(void)initDrawVCWithNewHouse;


/**
 初始化控制器，根据户型ID，打开一个新户型
 */
+(void)initDrawVCWithHouseID:(NSString*)houseID;


/**
 APP进入后台时保存 需在appDelegate的 applicationDidEnterBackground调用
 */
+(void)saveHouseWhenAPPBeBackground;


/** 
 “户型列表”点击事件block 
 */
@property (nonatomic, copy) void (^houseListBtnActionBlock)(NSString *houseID);

/**
 跳转到u3d界面
 */
@property (nonatomic, copy) void (^jump3DPageBlock)(UIViewController * drawVC);



/**
 LFDrawManager 单例
 */
+ (instancetype)sharedInstance;


@end
