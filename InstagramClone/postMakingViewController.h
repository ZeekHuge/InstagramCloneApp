//
//  postMakingViewController.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/7/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postMakingViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    __weak IBOutlet UIImageView *imageView_postImage;
    __weak IBOutlet UIBarButtonItem *barButton_add;
    __weak IBOutlet UITextField *textField_caption;
}

@end
