//
//  ATFeedTableViewCell.h
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATFeedItemModel;

@interface ATFeedTableViewCell : UITableViewCell

- (void)layoutUIWithModel:(ATFeedItemModel *)model;

+ (CGFloat)cellHeight;
+ (NSString *)reuseIdentifier;

@end
