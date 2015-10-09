//
//  postCell.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/7/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_postMakerProfile;
@property (weak, nonatomic) IBOutlet UILabel *label_postMakerUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_postImage;
@property (weak, nonatomic) IBOutlet UILabel *label_postText;

@end
