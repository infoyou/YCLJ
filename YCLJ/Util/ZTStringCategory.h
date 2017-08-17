//
//  ZTStringCategory.h
//  YCLJSDK
//
//  Created by Adam on 2017/8/3.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)stringByAddingPercentEscapes;
- (NSString *)stringByReplacingPercentEscapes;

@end
