//
//  instagramCloneViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/5/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "instagramCloneViewController.h"
#import <CoreData/CoreData.h>

#define SIGNUPDOING 1
#define LOGINDOING 2
#define DATABASE_LOGININFO @"UsernameInfo"

@interface instagramCloneViewController (){
    NSManagedObjectContext *dataBaseContext;
    NSInteger actionAtLoginPage;
//    NSFetchRequest *request;
    //NSManagedObject *dataBaseObject_UsernameInfo;
}
@end


@implementation instagramCloneViewController

-(void) showAlert:(NSString *)title withMessage:(NSString *)message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"loggedIn == %d",TRUE]];
    NSArray* arr = [[self managedObjectContext] executeFetchRequest:request error:nil];
    if (arr.count >0){
            [self performSegueWithIdentifier:@"segue_homePage" sender:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@",[self managedObjectContext]);
	// Do any additional setup after loading the view.
    actionAtLoginPage =  SIGNUPDOING;
    dataBaseContext = [self managedObjectContext];
//    request = [ NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
//    dataBaseObject_UsernameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UsernameInfo" inManagedObjectContext:dataBaseContext];
   
   }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textView_username resignFirstResponder];
    [textView_password resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [scrollView_parentView setContentOffset:CGPointMake(0, 50) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_signUpTapped:(id)sender {
    [imageView_arrowImageSignUp setHidden:FALSE];
    [imageView_arrowImageLogin setHidden:TRUE];
    [button_forgetPassword setUserInteractionEnabled:FALSE];
    [button_forgetPassword setHidden:TRUE];
    actionAtLoginPage =  SIGNUPDOING;
}

- (IBAction)button_loginTapped:(id)sender {
    [imageView_arrowImageSignUp setHidden:TRUE];
    [imageView_arrowImageLogin setHidden:FALSE];
    [button_forgetPassword setUserInteractionEnabled:TRUE];
    [button_forgetPassword setHidden:FALSE];
    actionAtLoginPage =  LOGINDOING;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"inside textFieldShouldReturn");
    [scrollView_parentView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    if(textField == textView_password){
        if ([textView_username.text isEqualToString:@""]){
            NSLog(@"Empty username given");
            [self showAlert:@"Error" withMessage:@"Username can't be empty"];
            return YES;
        }
        else if ([textView_password.text isEqualToString:@""]){
            NSLog(@"Empty password given");
            [self showAlert:@"Error" withMessage:@"Password can't be empty"];
            return YES;
        }
        else{
            NSError *errorObject =nil;
            NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"username == %@",textView_username.text]];
            NSMutableArray *requestResult = [[dataBaseContext executeFetchRequest:request error:&errorObject] mutableCopy];
            
            if (errorObject != nil){
                NSLog(@"error occured - %@  %@",errorObject,[errorObject localizedDescription]);
                [self showAlert:@"Error" withMessage:@"An error occured, please try later"];
            }else{
                if (requestResult.count > 0 ){
                    NSManagedObject * obj = [requestResult objectAtIndex:0];
                    if(actionAtLoginPage == SIGNUPDOING){
                            NSLog(@"username Exists");
                            [self showAlert:@"Already Exist" withMessage:@"The specified username already exists"];
                    }
                    if (actionAtLoginPage == LOGINDOING){
                            NSLog(@"Checking for password");
                            if ([textView_password.text isEqualToString:[obj valueForKey:@"password"]]) {
                                    NSLog(@"user %@ identified logging in",textView_username.text);
                                    [obj setValue:[NSNumber numberWithBool:YES] forKey:@"loggedIn"];
                                    [dataBaseContext save:&errorObject];
                                    if (errorObject != nil) {
                                        NSLog(@"Error while logging in %@ %@",errorObject,[errorObject localizedDescription]);
                                        [self showAlert:@"Error" withMessage:@"Some error occured. Try again later"];
                                    }else{
                                        [self performSegueWithIdentifier:@"segue_homePage" sender:self];
                                    }
                            }else{
                                NSLog(@"Wrong password");
                                [self showAlert:@"Error" withMessage:@"Wrong password. Try again"];
                            }
                    }
                }else{
                    if(actionAtLoginPage == SIGNUPDOING){
                        NSLog(@"New user - processing to add him");
                        NSManagedObjectContext* context = [self managedObjectContext];
                        NSManagedObject* newObj = [NSEntityDescription insertNewObjectForEntityForName:@"UsernameInfo" inManagedObjectContext:context];
                        [newObj setValue:textView_username.text forKey:@"username"];
                        [newObj setValue:textView_password.text forKey:@"password"];
                        [newObj setValue:[NSNumber numberWithBool:TRUE] forKey:@"loggedIn"];
                        
                        [context save:&errorObject];
                        if (errorObject != nil){
                            NSLog(@"coulndt add the user - %@ %@",errorObject,[errorObject localizedDescription]);
                        }else{
                            NSLog(@"User Added - %@",textView_username.text);
                            NSLog(@"Logging in with same credentials");
                            [self performSegueWithIdentifier:@"segue_homePage" sender:self];
                        }
                    }
                    
                    if (actionAtLoginPage == LOGINDOING){
                        NSLog(@"insed logging function- username dosent exists");
                        [self showAlert:@"Error" withMessage:@"The specified username dosent exists"];
                    }
                }
            }
        }
    }
    return  TRUE;
}

@end
