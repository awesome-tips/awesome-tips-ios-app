//
//  ATFeedItemModel.h
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFeedItemModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *postdate;
@property (nonatomic, assign) NSInteger platform;
@property (nonatomic, copy, readonly) NSString *platformString;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
