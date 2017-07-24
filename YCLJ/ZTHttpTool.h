//
//  ZTHttpTool.h
//  YCLJSDK
//
//  Created by Adam on 2017/6/21.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadParamModel.h"

@interface ZTHttpTool : NSObject

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure;

+ (void)upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(UploadParamModel *)uploadParam
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

@end
