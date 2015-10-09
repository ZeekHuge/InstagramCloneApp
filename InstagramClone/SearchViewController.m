//
//  SearchViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/8/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (){
    NSMutableArray* imagesData;
    NSString* savedContentLocation;
    NSString* userToBeOpened;
}
@end

@implementation SearchViewController


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
    [request setReturnsObjectsAsFaults:FALSE];
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
    NSLog(@"inside ViewDidLoad of searchView");
    
    imagesData = [[NSMutableArray alloc] init];
    savedContentLocation = nil;
    
	// Do any additional setup after loading the view.
    
    savedContentLocation = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"loggedIn == %d",FALSE];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:FALSE];
    NSError * errorObject ;
    NSArray* arr = [context executeFetchRequest:request error:&errorObject];
    if( errorObject == nil){
        NSLog(@"Success - fetched data - %@",arr);
        if (arr.count > 0){
            for (NSManagedObject* obj in arr){
                NSLog(@"inside for - %@",obj);
                if ([obj valueForKey:@"username"] != nil){
                    NSLog(@"inside if - %@",obj);
                    [imagesData addObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"username"]] ];
                }
            }
            NSLog(@"imagesData is %@",imagesData);
        }else{
            NSLog(@"data fetched but database is empty");
        }
    }else{
        NSLog(@"wasnt able to fetch unlogged users");
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"inside ViewDidAppear of searchView");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Inside numberOfSectionsInCollectionView");
    return imagesData.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"inside cellForItemAtIndexPath");
    static NSString * collectionIdentifier = @"collectionCellInSearch";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    UIButton *buttonInCell= (UIButton * ) [cell viewWithTag:100];
    NSString * strAdd = [NSString stringWithFormat:@"%@%@profilePicture",savedContentLocation,[imagesData objectAtIndex:indexPath.row ]];
    [buttonInCell setImage:[UIImage imageWithContentsOfFile:strAdd] forState:UIControlStateNormal ] ;
    [buttonInCell setTitle:[imagesData objectAtIndex:indexPath.row] forState:UIControlStateNormal] ;
    NSLog(@"%@",strAdd);
    [buttonInCell addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];    
    return cell;
}


-(void) imageButtonTapped :(id) imageButton{
    UIButton* btn = imageButton;
    NSLog(@"image button tapped %@", btn.titleLabel.text);
    userToBeOpened = btn.titleLabel.text;
    [self performSegueWithIdentifier:@"segue_otherProfile" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"preparing for segue");
    [segue.destinationViewController performSelector:@selector(setTheFakeOnlineUserName:) withObject:userToBeOpened];
}


@end
