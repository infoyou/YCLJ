//
//  YCLJAppManager.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/29.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCLJAppManager.h"

@implementation YCLJAppManager

static YCLJAppManager *singleton = nil;

+ (instancetype)instance {
    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken,^{
        
        singleton = [[YCLJAppManager alloc] init];
    });
    
    return singleton;
}

- (void)updateUserData:(NSString *)aUserId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    if(_userId == nil) {
        
        [_def removeObjectForKey:@"userId"];
    } else {
        
        [_def setObject:aUserId forKey:@"userId"];
    }
    
    [_def synchronize];
}

- (void)updateHouseData:(NSString *)aHouseNo
                houseId:(NSString *)aHouseId
{
    NSUserDefaults *_def = [NSUserDefaults standardUserDefaults];
    
    [_def setObject:aHouseNo forKey:@"no"];
    [_def setObject:aHouseId forKey:@"houseId"];

    [_def synchronize];
}

- (NSString *)getHouseId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"houseId"];
}

@end
