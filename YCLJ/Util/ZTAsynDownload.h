//
//  ZTAsynDownload.h
//  YCLJSDK
//
//  Created by Adam on 2017/9/23.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^initProgress)(long long initValue);

typedef void (^loadedData)(long long loadedLength);

@interface ZTAsynDownload : NSObject<NSURLConnectionDataDelegate>

@property (strong) NSURL *httpURL;

@property (copy) void (^initProgress)(long long initValue);

@property (copy) void (^loadedData)(long long loadedLength);

+ (ZTAsynDownload *) initWithURL:(NSURL *) url;

- (void) startAsyn;

@end
