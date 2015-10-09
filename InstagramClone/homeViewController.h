//
//  homeViewController.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/6/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UITableView *tableView_mainTableView;
    __weak IBOutlet UITableView *tableView_home;
}

@end
