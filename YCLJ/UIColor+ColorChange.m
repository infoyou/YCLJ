//
//  UIColor.m
//  onePerMout
//
//  Created by Mr.Zhang on 2017/4/24.
//  Copyright © 2017年 Mr.Zhang. All rights reserved.
//

#import "UIColor+ColorChange.h"

@implementation UIColor (ColorChange)


+(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //字符串应为6或8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //判断字符串前缀是否包含某个字符
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    //从六位数中找到RGB对应的位数并进行转换
    NSRange range;
    //其中location是一个以0为开始的index，length是表示对象的长度
    range.location = 0;
    range.length = 2;
    //R G B    substringWithRange  截取字符串
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
        
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
    
}

@end


















