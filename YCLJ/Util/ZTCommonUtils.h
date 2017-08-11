//
//  ZTCommonUtils.h
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import <Foundation/Foundation.h>
#import "YCHeader.h"
#import <UIKit/UIKit.h>

@interface ZTCommonUtils : NSObject

+ (NSString *)currentTimeInterval;
+ (NSString *)curDateString;
+ (NSString *)currentDateStr:(NSString *)strSecs;

#pragma mark - Param Dict
+ (NSMutableDictionary *)getParamDict:(NSMutableDictionary *)dataDict;

#pragma mark - Common Method
+ (UIColor *)colorWithHexString:(NSString *)hex;

#pragma mark - copy file
+ (void)doCopyFile:(NSString *)sourcePath targetPath:(NSString *)targetPath houseId:(NSString *)houseId;
+ (void)zipFileDir:(NSString *)zipPath sourcePath:(NSString *)sourcePath;

+ (BOOL)isExistDirName:(NSString *)dirName;

#pragma mark - 定宽高度自适应
+ (CGFloat)calcuViewHeight:(NSString *)content font:(UIFont*)font width:(CGFloat)width;
+ (CGFloat)calcuViewWidth:(NSString *)content font:(UIFont *)font;

+ (NSString *)commonMsg;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

@end
