//
//  StringCategory.m
//  YCLJSDK
//
//  Created by Adam on 2017/8/3.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "StringCategory.h"

CFStringRef charsToEscape = CFSTR("!*'();:@&=+$,/?%#[]");

@implementation NSString (URLEncoding)

- (NSString *)stringByAddingPercentEscapes
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self, NULL, charsToEscape,
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (NSString *)stringByReplacingPercentEscapes
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, CFSTR("")));
}

@end
