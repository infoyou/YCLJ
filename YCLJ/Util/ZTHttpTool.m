//
//  ZTHttpTool.m
//  YCLJSDK
//
//  Created by Adam on 2017/6/21.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "ZTHttpTool.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

@implementation ZTHttpTool

+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(void (^)(id json))success
    failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(error);
        }
    }];  
}

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure
{
    
    NSLog(@"%@", url);
    
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey:key];
        //        NSLog(@"Server Url \n %@?cmd=%@", url, value);
        NSLog(@"%@=%@", key, value);
    }
    
    // 1.创建请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [session POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        if (success) {
            
            success(responseObject);
            NSLog(@"BackMsg \n %@", responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

+ (void)upload:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(ZTUploadParamModel *)uploadParam
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    
    // 创建请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
