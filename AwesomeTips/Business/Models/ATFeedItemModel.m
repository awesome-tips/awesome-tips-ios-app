//
//  ATFeedItemModel.m
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import "ATFeedItemModel.h"

@implementation ATFeedItemModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]] && [[dictionary allKeys] count] > 0) {
        ATFeedItemModel *model = [[ATFeedItemModel alloc] init];
        model.fid = [self at_asssignEmptyString:dictionary[@"fid"]];
        model.author = [self at_asssignEmptyString:dictionary[@"author"]];
        model.title = [self at_asssignEmptyString:dictionary[@"title"]];
        model.url = [self at_asssignEmptyString:dictionary[@"url"]];
        model.postdate = [self at_asssignEmptyString:dictionary[@"postdate"]];
        model.platform = [dictionary[@"platform"] integerValue];
        return model;
    }
    return nil;
}

+ (NSString *)at_asssignEmptyString:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    
    if ((NSNull *)string == [NSNull null]) {
        return @"";
    }
    
    if ([string isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", string];;
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([string isEqualToString:@"(null)"]) {
        return @"";
    }
    if ([string isEqualToString:@"null"]) {
        return @"";
    }
    
    return string;
}

- (NSString *)platformString {
    switch (self.platform) {
        case 0:
            return @"微博";
        case 1:
            return @"公众号";
        case 2:
            return @"GitHub";
        case 3:
            return @"Medium";
        default:
            return @"未知";
    }
}

@end
