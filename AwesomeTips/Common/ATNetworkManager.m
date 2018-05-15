//
//  ATNetworkManager.m
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import "ATNetworkManager.h"
#import <objc/runtime.h>

#define AWESOME_TIPS_API_HOST @"https://app.kangzubin.com/iostips/api/"

NSString * const ATNetworkErrorDomain = @"ATNetworkErrorDomain";

static NSError * ATNetworkErrorGenerator(NSInteger code, NSString *msg) {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: msg.length > 0 ? msg : @""};
    NSError * __autoreleasing error = [NSError errorWithDomain:ATNetworkErrorDomain code:code userInfo:userInfo];
    return error;
}

@implementation XMRequest (ATUtils)

- (BOOL)isCached {
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return [num boolValue]; // 默认为 NO
}

- (void)setCached:(BOOL)cached {
    NSNumber *boolValue = @(cached);
    objc_setAssociatedObject(self, @selector(version), boolValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation ATNetworkManager

+ (void)setup {
    // 网络请求全局配置
    [XMCenter setupConfig:^(XMConfig *config) {
        config.generalServer = AWESOME_TIPS_API_HOST;
        config.callbackQueue = dispatch_get_main_queue();
#ifdef DEBUG
        config.consoleLog = YES;
#endif
    }];
    
    // 加载 app.kangzubin.com 域名的证书
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"app.kangzubin.com" ofType:@"cer"];
    NSData *certificateData = [NSData dataWithContentsOfFile:path];
    if (certificateData) {
        [XMCenter addSSLPinningCert:certificateData];
    }
    // 对 app.kangzubin.com 域名下的接口做 SSL Pinning 验证
    [XMCenter addSSLPinningURL:@"https://app.kangzubin.com"];
    
    // 请求预处理插件
    [XMCenter setRequestProcessBlock:^(XMRequest *request) {
        // 在这里对所有的请求进行统一的预处理，如业务数据加密等
        NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
        headers[@"from"] = @"ios-app";
        headers[@"version"] = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        request.headers = [headers copy];
    }];
    
    // 响应后处理插件
    // 如果 Block 的返回值不为空，则 responseObject 会被替换为 Block 的返回值
    [XMCenter setResponseProcessBlock:^id(XMRequest *request, id responseObject, NSError *__autoreleasing * error) {
        // 在这里对请求的响应结果进行统一处理，如业务数据解密等
        if (![request.server isEqualToString:AWESOME_TIPS_API_HOST]) {
            return nil;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] count] > 0) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code != kATSuccessCode) {
                // 网络请求成功，但接口返回的 Code 表示失败，这里给 *error 赋值，后续走 failureBlock 回调
                *error = ATNetworkErrorGenerator(code, responseObject[@"msg"]);
            } else {
                // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
                NSDictionary *resultData = responseObject[@"data"];
                
                if (request.isCached) {
                    // 缓存相关操作
                }
                
                return resultData;
            }
        }
        return nil;
    }];
    
    // 错误统一过滤处理
    [XMCenter setErrorProcessBlock:^(XMRequest *request, NSError *__autoreleasing * error) {
        // 比如对不同的错误码统一错误提示等
        
    }];
}

@end
