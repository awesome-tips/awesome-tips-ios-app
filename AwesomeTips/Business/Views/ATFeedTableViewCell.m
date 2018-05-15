//
//  ATFeedTableViewCell.m
//  AwesomeTips
//
//  Created by Zubin Kang on 2018/5/15.
//  Copyright © 2018 KANGZUBIN. All rights reserved.
//

#import "ATFeedTableViewCell.h"
#import "ATFeedItemModel.h"

@implementation ATFeedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 2;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutUIWithModel:(ATFeedItemModel *)model {
    self.textLabel.text = model.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ @%@ · %@", model.postdate, model.author, model.platformString];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 80.0f;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self.class);
}

@end
