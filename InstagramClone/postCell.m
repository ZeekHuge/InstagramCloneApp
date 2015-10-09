//
//  postCell.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/7/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "postCell.h"

@implementation postCell

@synthesize label_postMakerUsername = _label_postMakerUsername;
@synthesize label_postText = _label_postText;
@synthesize imageView_postImage = _imageView_postImage;
@synthesize imageView_postMakerProfile = _imageView_postMakerProfile;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
