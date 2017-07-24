//
//  UIColor.h
//  onePerMout
//
//  Created by Mr.Zhang on 2017/4/24.
//  Copyright © 2017年 Mr.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

//颜色转换：iOS中（以#开头），十六进制的颜色转换为UIColor（RTGB
+(UIColor *)colorWithHexString:(NSString *)color;

@end
