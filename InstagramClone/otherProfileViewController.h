//
//  otherProfileViewController.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/8/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface otherProfileViewController : UIViewController < UITableViewDelegate , UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>{
    
    __weak IBOutlet UILabel *label_userFollowings;
    __weak IBOutlet UILabel *label_userFollowers;
    __weak IBOutlet UILabel *label_userPosts;
    __weak IBOutlet UIImageView *imageView_userProfilePic;
    __weak IBOutlet UILabel *label_userName;
    __weak IBOutlet UICollectionView *collectionView_images;
    __weak IBOutlet UITableView *tableView_timeline;
    __weak IBOutlet UINavigationItem *navigationBarItem_topBar;
    __weak IBOutlet UIButton *button_follow;
}

@end

