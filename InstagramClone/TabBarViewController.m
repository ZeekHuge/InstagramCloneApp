//
//  TabBarViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/9/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController (){
    UIImage * postImage;
}

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"finished at imaePicker");
    postImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"segue_postMaking" sender:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"canceld selecting");
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController* cont =[story instantiateViewControllerWithIdentifier:@"root_tabBar" ];
    
    UITabBarController* rootViewController = [story instantiateViewControllerWithIdentifier:@"root_tabBar" ];
    [self presentViewController:rootViewController animated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"inside prepareForSegue");
//    if ([segue.identifier isEqualToString:@"segue_postMaking"]) {
        [segue.destinationViewController performSelector:@selector(setPostImage:) withObject:postImage];
//    }
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    postImage = [[UIImage alloc] init];
    NSMutableArray* arr =  [self.viewControllers mutableCopy];
    UIImagePickerController* imgPicker = [[UIImagePickerController alloc] init];
    
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imgPicker.title =@"";
    UITabBarItem *barItem = [[UITabBarItem alloc] init];
    
    barItem.image = [UIImage imageNamed:@"camera_chngd"];
    barItem.title =  @"Add post";
    
    [imgPicker setTabBarItem:barItem];
    [arr insertObject:imgPicker atIndex:2];
    
    self.viewControllers = [NSArray arrayWithArray:arr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
