//
//  CommonUtils.m
//  Pods
//
//  Created by Adam on 2017/6/15.
//
//

#import "CommonUtils.h"
#import <UIKit/UIDevice.h>
#import "SSZipArchive.h"

@implementation CommonUtils

+ (NSBundle *)bundle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    return bundle;
}

+ (NSString *)currentTimeInterval {
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    // 秒.毫秒 1442541004.2110679
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *dateInterval = [NSString stringWithFormat:@"%.0f", interval * 1000];
    
    return dateInterval;
}

+ (NSString *)curDateString
{
    NSDate *curDate =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    return [dateFormatter stringFromDate:curDate];
}

#pragma mark - Param Dict
+ (NSMutableDictionary *)getParamDict:(NSMutableDictionary *)dataDict
{
    
    if (dataDict != nil) {
        
        [dataDict setObject:[CommonUtils currentTimeInterval] forKey:@"time"];
    }
    
    NSMutableDictionary *commonDict = [NSMutableDictionary dictionary];
    [commonDict setObject:@"ios" forKey:@"plat"];
    [commonDict setObject:@"2" forKey:@"interVersion"];
    [dataDict setObject:commonDict forKey:@"common"];
    
    return dataDict;
}

+ (NSString *)dictToJsonString:(NSMutableDictionary *)dictionary
{
    NSString *backVal = nil;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    backVal = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    
    return backVal;
}

#pragma mark - Common Method
+ (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - 定宽高度自适应
+ (CGFloat)calcuViewHeight:(NSString *)content font:(UIFont *)font width:(CGFloat)width
{
    CGRect titleSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
    
    return titleSize.size.height;
}

+ (CGFloat)calcuViewWidth:(NSString *)content font:(UIFont *)font
{
    
    // 计算宽度
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:content attributes:attributes] size].width;
}

+ (NSMutableArray *)allFilesAtPath:(NSString *)direString
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:direString error:nil];
    
    for (NSString *fileName in tempArray) {
        
        BOOL flag = YES;
        NSString *fullPath = [direString stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                // ignore .DS_Store
                if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                    [pathArray addObject:fullPath];
                }
            } else {
                [pathArray addObject:[self allFilesAtPath:fullPath]];
            }
        }
    }
    
    return pathArray;
}

+ (void)doCopyFile:(NSString *)sourcePath targetPath:(NSString *)targetPath houseId:(NSString *)houseId
{
    // Create target path
    [[NSFileManager defaultManager] createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:NULL];
 
    // Copy .lf file
    NSError *copyError = nil;
    
    NSString *sourceFileName = [NSString stringWithFormat:@"%@/%@.lf", sourcePath, houseId];
    NSString *newFileName = [NSString stringWithFormat:@"%@/%@_1.lf", targetPath, houseId];
    if (![[NSFileManager defaultManager] copyItemAtPath:sourceFileName toPath:newFileName error:&copyError]) {
        DLog(@"Copy failure");
    }
    
}

+ (void)zipFileDir:(NSString *)zipPath sourcePath:(NSString *)sourcePath
{
    
    // Create
    [SSZipArchive createZipFileAtPath:zipPath withContentsOfDirectory:sourcePath];
    
    // Unzip
    // [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
}

+ (NSString *)commonMsg
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app名称: %@",app_Name);
    NSLog(@"app版本: %@",app_Version);
    NSLog(@"app build版本: %@",app_build);
    
    //手机序列号
    NSUUID *identifierUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString* identifierNumber = [identifierUUID UUIDString];
    NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName);
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    return nil;
}

@end
