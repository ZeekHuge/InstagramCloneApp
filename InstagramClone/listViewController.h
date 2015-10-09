//
//  listViewController.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/8/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UIImageView *imageView_arrowFollowing;
    __weak IBOutlet UIImageView *imageView_arrowFollowers;
    __weak IBOutlet UITableView *tableView_lists;
}

@end
