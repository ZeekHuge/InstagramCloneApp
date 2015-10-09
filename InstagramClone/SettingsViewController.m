//
//  SettingsViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/7/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

-(NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSManagedObject *) fetchLoggedInObject {
    NSManagedObject* obj = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"loggedIn == %d",TRUE];
    [request setPredicate:predicate];
    NSError *errorObject = nil ;
    NSArray* arr =[context executeFetchRequest:request error:&errorObject];
    if(errorObject == nil){
        NSLog(@"fetched data successfully");
        if (arr.count > 0){
            obj = [arr objectAtIndex:0];
            return obj;
        }else{
            NSLog(@"No database exists");
        }
    }else{
        NSLog(@"Error occured while fetch - %@ %@",errorObject,[errorObject localizedDescription]);
    }
    return nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"inside ViewDidLoad of settingsView");
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"inside ViewDidAppear of settingsView");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button_changeProfilePicTapped:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData* imageData = UIImagePNGRepresentation(pickedImage);
    NSManagedObject *obj = [self fetchLoggedInObject];
    if (obj !=  nil){
        NSString* storingLocation = [NSString stringWithFormat:@"%@%@%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], [obj valueForKey:@"username"],@"profilePicture"];
        NSLog(@"saving at location %@",storingLocation);
        [imageData writeToFile:storingLocation atomically:NO];
    }else{
        NSLog(@"received obj object was nil");
    }
}

- (IBAction)button_logoutTapped:(id)sender {
    
    NSManagedObjectContext* context = [self managedObjectContext];
    NSManagedObject* obj = [self fetchLoggedInObject];
    if (obj != nil){
        NSError* errorObject = nil;
        [obj setValue:[NSNumber numberWithBool:FALSE] forKey:@"loggedIn"];
        [context save:&errorObject];
        if (errorObject == nil){
            NSLog(@"loggedOut successfully");
            NSLog(@"the logged in object is%@",[self fetchLoggedInObject]);
            [self performSegueWithIdentifier:@"segue_backToLogin" sender:self];
        }else{
            NSLog(@"error while loggingOut - %@ %@",errorObject,[errorObject localizedDescription]);
        }
    }else{
        NSLog(@"error -- obj provided was empty");
    }
}
    



@end
