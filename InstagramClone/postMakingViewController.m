//
//  postMakingViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/7/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "postMakingViewController.h"

@interface postMakingViewController (){
    BOOL toggleFlag ;
    UIImage* imageForPost ;
}
//-(void)setPostImage:(UIImage*) postImage;
@end

@implementation postMakingViewController

-(NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext* context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate managedObjectContext]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSManagedObject * ) fetchloggedInObject{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"loggedIn == %d",TRUE];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    NSError *errorObject =nil;
    NSArray * arr = [context executeFetchRequest:request error:&errorObject];
    if (errorObject == nil){
        NSLog(@"Fetched succesfully");
        if (arr.count > 0){
            NSLog(@"returning %@",[arr objectAtIndex:0] );
            return [arr objectAtIndex:0];
        }else{
            NSLog(@"No database exists");
        }
    }else{
        NSLog(@"thereWas an error whileFetching - %@ %@",errorObject, [errorObject localizedDescription] );
    }
    return nil ;
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
    
	// Do any additional setup after loading the view.
    NSLog(@"inside ViewDidLoad");

    imageView_postImage.image = imageForPost;
}








-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"inside ViewDidAppear profileMaker");
    
}


-(void)setPostImage:(UIImage*) postImage{
    NSLog(@"received %@",postImage);
    imageForPost = postImage;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textField_caption resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"inside textFieldShouldReturn");
    [textField resignFirstResponder];
    return TRUE;
}


- (IBAction)button_cancelTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





- (IBAction)button_postItTapped:(id)sender {
    NSManagedObject* obj = [self fetchloggedInObject];
    if (obj != nil){
        NSData* imageData = UIImagePNGRepresentation(imageView_postImage.image);
        NSArray* arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* savingFIleAppending =[NSString stringWithFormat:@"/%@%@",[obj valueForKey:@"username"], [obj valueForKey:@"postsNumber"]];
        NSString* savingPath = [[arr objectAtIndex:0] stringByAppendingString:savingFIleAppending];
        NSLog(@"Saving image at %@",savingPath);
        [imageData writeToFile:savingPath atomically:NO];
        NSLog(@"image saved");
        
        //saving into database;
        
        NSManagedObject *obj = [self fetchloggedInObject];
        NSString* toSaveString = [NSString stringWithFormat:@"%@%@@%@@",[obj valueForKey:@"posts"],textField_caption.text,savingFIleAppending];
        NSLog(@"going to save this string %@",toSaveString);
        NSManagedObjectContext *context = [self managedObjectContext];
        [obj setValue:toSaveString forKey:@"posts"];
        [obj setValue:[NSNumber numberWithInt:[[obj valueForKey:@"postsNumber"] integerValue] + 1 ] forKey:@"postsNumber"];
        [obj setValue:[NSString stringWithFormat:@"%@%@@",[obj valueForKey:@"pictures"],savingFIleAppending] forKey:@"pictures"];
        [context save:nil];
        obj = [self fetchloggedInObject];
        NSLog(@"%@",obj);
        
        [self performSegueWithIdentifier:@"segue_goToHomeView" sender:self];
//        imageView_postImage.image = [UIImage imageNamed:@"smile.png"];
//        textField_caption.text = @"";
        
    }else{
        NSLog(@"fetched loggedIn objectNil");
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
