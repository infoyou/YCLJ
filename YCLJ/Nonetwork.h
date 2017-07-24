//
//  Nonetwork.h
//  网络顶部提示框
//
//  Created by Mr.Zhang on 2017/5/19.
//  Copyright © 2017年 Mr.Zhang. All rights reserved.
//

static int disWidth = 30;//全局变量
static int disHeight = 40;//全局变量

#import <UIKit/UIKit.h>

//声明一个枚举类型
typedef NS_ENUM(NSInteger,NoContentType) {
    //自动消失
    Automaticallydisappear = 0,
    //点击消失
    Clicktodisappear = 1
};

@interface Nonetwork : UIView
//提示内容
@property(nonatomic,copy)NSString *Prompt;
//背景视图
@property(nonatomic,strong)UIView *Bagview;
//内容区域
@property(nonatomic,strong)UIView *Contarea;
//警告图标
@property(nonatomic,strong)UIImageView *Warningicon;
//内容文本
@property(nonatomic,strong)UILabel *Contentext;
//提示框消失类型
@property(nonatomic,assign)NSInteger typeDisappear;

//定义一个Block 回调函数
@property(nonatomic,copy) void(^returnsAnEventBlock)();

//弹出视图
-(void)popupWarningview;

@end
