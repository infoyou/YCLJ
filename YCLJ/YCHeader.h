//
//  YCHeader.h
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import "ZTCommonUtils.h"
#import "ZTStringCategory.h"

#ifndef YCLJ_Header_h
#define YCLJ_Header_h

#define SUCCESS_DATA                        10000
#define NO_MORE_DATA                        1001

#define YC_HOST_URL           @"http://leju.jiandanhome.com"

#define LJ_SUCCESS_DATA                      0

// system info
#define CURRENT_OS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

//宽高适配
#define kBaseLine(a) (CGFloat)a * YC_SCREEN_WIDTH / 375.0
//文字大小适配
#define Textadaptation(a) (NSInteger)a * (YC_SCREEN_WIDTH / 375.0)

// 动态获取设备参数YC_SCREEN_WIDTH
#define YC_SCREEN_WIDTH      [UIScreen mainScreen].bounds.size.width
#define YC_SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define SCREEN_HEIGHT_OFFSET    64
#define SCREEN_SCALE      [UIScreen mainScreen].scale

//导航栏高
#define Nav_HEIGHT self.navigationController.navigationBar.frame.size.height
//状态栏高
#define StatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define COLORA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define COLOR(R,G,B) COLORA(R,G,B,1.0)

// 颜色
#define NAVI_BAR_BG_COLOR            @"0x5ed8cd"
#define VIEW_BG_COLOR                @"0xeeeded"
#define CELL_BG_COLOR                @"0xffffff"

#define HEX_COLOR(__STR)    [ZTCommonUtils colorWithHexString:__STR]
#define TRANSPARENT_COLOR   [UIColor clearColor]
#define TRANSPARENT_COLOR   [UIColor clearColor]

#define GetImageByName(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]]

#pragma mark - font
#define Font(fontSize)      [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]
#define FontBold(fontSize)      [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]
#define FontSystem(fontSize)      [UIFont systemFontOfSize:fontSize]
#define FontSystemBold(fontSize)  [UIFont boldSystemFontOfSize:fontSize]

// UI
#pragma mark - Alert
#define ShowAlertWithOneButton(Delegate,TITLE,MSG,But) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:Delegate \
cancelButtonTitle:But \
otherButtonTitles:nil] show]

#define ShowAlertWithTwoButton(Delegate,TITLE,MSG,But1,But2) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:Delegate \
cancelButtonTitle:But1 \
otherButtonTitles:But2, nil] show]

typedef enum {
    HOUSE_SOLUTION_ORIGN_TYPE = 0, // 原始图
    HOUSE_SOLUTION_ALTER_TYPE, // 拆改图
} House_Solution_TYPE;

#define Uploading_Data_Txt  @"数据正在上传\n请耐心等待!"
#define AFW_Data_Txt        @"爱福窝数据\n不支持此项功能!"

#endif /* YCLJ_Header_h */
