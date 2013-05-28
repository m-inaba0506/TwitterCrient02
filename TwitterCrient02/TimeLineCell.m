//
//  TimeLineCell.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "TimeLineCell.h"

@implementation TimeLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.tweetTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.tweetTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.tweetTextLabel.textColor = [UIColor blackColor];
        self.tweetTextLabel.numberOfLines = 0;
        [self.contentView addSubview:self.tweetTextLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:11.0];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
        
//        self.favLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.favLabel.font = [UIFont boldSystemFontOfSize:11.0];
//        self.favLabel.textColor = [UIColor blackColor];
//        self.favLabel.text = @"★";
//        [self.contentView addSubview:self.favLabel];
        
        
        self.ribon = [[UIImageView alloc] init];
        self.ribon.image = [UIImage imageNamed:@"ribon.png"];
        [self.contentView addSubview:self.ribon];
      
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 5, 48, 48);
    self.tweetTextLabel.frame = CGRectMake(58, 25, 257, self.tweetTextLabelHeight);
    self.nameLabel.frame = CGRectMake(58, 10, 247, 10);
    self.ribon.frame = CGRectMake(300, 0, 30, 25);
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;//画像サイズに合わせてimageViewを貼り付ける
}
@end
