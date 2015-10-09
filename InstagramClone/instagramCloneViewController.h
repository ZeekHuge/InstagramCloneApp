//
//  instagramCloneViewController.h
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/5/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface instagramCloneViewController : UIViewController <UITextFieldDelegate>{
    
    __weak IBOutlet UIScrollView *scrollView_parentView;
    __weak IBOutlet UIImageView *imageView_arrowImageLogin;
    __weak IBOutlet UIButton *button_forgetPassword;
    __weak IBOutlet UIImageView *imageView_arrowImageSignUp;
    __weak IBOutlet UITextField *textView_username;
    __weak IBOutlet UITextField *textView_password;
}

@end
