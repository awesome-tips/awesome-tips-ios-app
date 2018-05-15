//
//  ATNetworkManager.h
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMNetworking/XMNetworking.h>

typedef NS_ENUM(NSInteger, ATNetworkErrorCode) {
    kATSuccessCode = 0,      //!< 接口请求成功
    kATErrorCode = 1,        //!< 接口请求失败
    kATUnknownCode = -1,     //!< 未知错误
};

@interface XMRequest (ATUtils)
@property (nonatomic, assign, getter=isCached) BOOL cached; //!< 当前请求是否要缓存，默认为 NO
@end

#pragma mark -

@interface ATNetworkManager : NSObject

/**
 初始化网络配置
 */
+ (void)setup;

@end
