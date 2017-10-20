//
//  LFSDKViewController.h
//  lfsqSDKTest
//
//  Created by lreson on 2017/9/22.
//  Copyright © 2017年 kcsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^houseListBtnActionBlock)(NSString* houseID ,UIViewController *drawVC);
typedef void(^jump3DPageBlock)(UIViewController * drawVC);
typedef void(^closeBtnActionBlock)(NSString* houseID);



@interface LFSDKViewController : UIViewController


/**
 app启动时，用UserID初始化量房神器SDK
 */
- (void)registerLfsqSDKWithUserID:(NSString*)UserID;

/**
 初始化控制器，打开爱福窝户型数据
 */
- (void)initAFWDrawVCWithHouseDict:(NSDictionary *)dict;


/**
 APP进入后台时保存 需在appDelegate的 applicationDidEnterBackground调用
 */
- (void)saveHouseWhenAPPBeBackground;


/**
 注销
 */
- (void)loginOut;


///**
// 初始化绘图控制器，创建一个新户型
// */
//- (void)initDrawVCWithNewHouseWithHouseListBtnActionBlock:(houseListBtnActionBlock)houseListBtnActionBlock jump3DPageBlock:(jump3DPageBlock)jump3DPageBlock closeBtnActionBlock:(closeBtnActionBlock)closeBtnActionBlock;
//
//
///**
// 初始化控制器，根据户型ID，打开一个新户型
// */
//-(void)initDrawVCWithHouseID:(NSString*)houseID houseListBtnActionBlock:(houseListBtnActionBlock)houseListBtnActionBlock jump3DPageBlock:(jump3DPageBlock)jump3DPageBlock closeBtnActionBlock:(closeBtnActionBlock)closeBtnActionBlock;
//




@end
