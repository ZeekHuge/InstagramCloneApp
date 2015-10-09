//
//  otherProfileViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/8/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "otherProfileViewController.h"
#import "instagramCloneViewController.h"
#import "postCell.h"

@interface otherProfileViewController (){
    
    NSManagedObjectContext *databaseContext ;
    NSManagedObject *databaseObject_UsersnameInfo;
    NSFetchRequest *requests ;
    NSMutableArray *postsTimelineData;
    NSMutableArray* imagesData;
    NSPredicate *predicate;
    NSString* savedContentLocation;
    NSString* userToFakeAsOnline;
}


@end

@implementation otherProfileViewController

-(NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext * context =nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}



-(NSManagedObject *) fetchLoggedInObject {
    
    NSError *errorObject = nil;
    NSManagedObject *obj = nil;
    requests = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    
    predicate = [NSPredicate predicateWithFormat:@"username == %@", userToFakeAsOnline];
    [requests setPredicate:predicate];
    NSArray * fetchedResults = [databaseContext executeFetchRequest:requests error:&errorObject];
    
    if(errorObject != nil){
        NSLog(@"error occured for fetch %@ %@", errorObject, [errorObject localizedDescription]);
    }else{
        NSLog(@"no error occured fetched - %@",fetchedResults);
        if (fetchedResults.count  > 0){
            obj = [fetchedResults objectAtIndex:0];
            NSLog(@"will return - %@",[fetchedResults objectAtIndex:0]);
        }else{
            NSLog(@"No database exists");
        }
    }
    return obj;
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
    NSLog(@"inside viewDidload of  otherProfile");
    //    imagesData = [[NSMutableArray alloc] initWithObjects:@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png",@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png",@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png", nil];
    
    //    postsTimelineData = [[NSMutableArray alloc] initWithObjects:@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png",@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png",@"home.png",@"cameraIcon.png",@"searchIcon.png",@"upArrow.png",@"listIcon.png", nil];
    databaseContext = [self managedObjectContext];
    
}

-(NSManagedObject*) fetchOriginallyLoggedIn{
    NSError *errorObject = nil;
    NSManagedObject *obj = nil;
    requests = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    
    predicate = [NSPredicate predicateWithFormat:@"loggedIn == %d", TRUE];
    [requests setPredicate:predicate];
    NSArray * fetchedResults = [databaseContext executeFetchRequest:requests error:&errorObject];
    
    if(errorObject != nil){
        NSLog(@"error occured for fetch %@ %@", errorObject, [errorObject localizedDescription]);
    }else{
        NSLog(@"no error occured fetched - %@",fetchedResults);
        if (fetchedResults.count  > 0){
            obj = [fetchedResults objectAtIndex:0];
            NSLog(@"will return - %@",[fetchedResults objectAtIndex:0]);
        }else{
            NSLog(@"No database exists");
        }
    }
    return obj;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"inside viewDidAppear of  otherProfile");
    savedContentLocation = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSManagedObject* obj = [self fetchLoggedInObject];
    NSLog(@"got %@",obj);
    if (obj != nil){
        NSLog(@"%@",[obj valueForKey:@"username"]);
        label_userName.text = [obj valueForKey:@"username"];
        navigationBarItem_topBar.title = [obj valueForKey:@"username"];
        imageView_userProfilePic.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@profilePicture",savedContentLocation,[obj valueForKey:@"username"]]];
        label_userFollowers.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"followersNumber"]];
        label_userFollowings.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"followingsNumber"]];
        label_userPosts.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"postsNumber"]];
        imagesData = (NSMutableArray * )[[obj valueForKey:@"pictures"] componentsSeparatedByString:@"@"];
        [imagesData removeObjectAtIndex:0];
        [imagesData removeObjectAtIndex:imagesData.count -1];
        NSLog(@"%@",imagesData);
        [collectionView_images setHidden:FALSE];
        [collectionView_images setUserInteractionEnabled:TRUE];
        [collectionView_images reloadData];
    }
    
    
    NSManagedObject* originallyOnlineUser =[self fetchOriginallyLoggedIn];
    if (originallyOnlineUser != nil){
        NSLog(@"fetched original online userr - %@",originallyOnlineUser);
        NSArray* followings = [[originallyOnlineUser valueForKey:@"followings"] componentsSeparatedByString:@"@"];
        NSLog(@"following array is %@",followings);
        for (NSString* str in followings){
            NSLog(@"checking for follow relation");
            if ([str isEqualToString:[obj valueForKey:@"username"]]){
                [button_follow setTitle:@"Unfollow" forState:UIControlStateNormal];
                NSLog(@"button set to unfollow");
                break;
            }else{
                [button_follow setTitle:@"Follow" forState:UIControlStateNormal];
            }
        }
    }else{
        NSLog(@" while fetching originalOnlinUser was nil" );
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//function
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Inside numberOfSectionsInCollectionView");
    return imagesData.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"inside cellForItemAtIndexPath");
    static NSString * collectionIdentifier = @"collectionCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    UIImageView *imageViewInCell = (UIImageView * ) [cell viewWithTag:100];
    
    imageViewInCell.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",savedContentLocation,[imagesData objectAtIndex:indexPath.row ]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 349.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"inside numberOfRowsInSection");
    return postsTimelineData.count /2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* tableCellIdentifier = @"tableCellHome";
    
    postCell * cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil){
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"postCellForTable" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    NSManagedObject* obj = [self fetchLoggedInObject];
    if (obj != nil){
        cell.label_postMakerUsername.text = [obj valueForKey:@"username"];
        cell.imageView_postMakerProfile.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@profilePicture",savedContentLocation,[obj valueForKey:@"username"]]];
    }else{
        NSLog(@"logged in obj was nil");
    }
    cell.imageView_postImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",savedContentLocation,[postsTimelineData objectAtIndex:(indexPath.row *2)+1]]];
    cell.label_postText.text =[postsTimelineData objectAtIndex:(indexPath.row *2)];
    
    return cell;
    
}


- (IBAction)button_mediaClicked:(id)sender {
    NSLog(@"media button tapped");
    
    postsTimelineData = [[NSMutableArray alloc] init];
    
    NSManagedObject* obj = [self fetchLoggedInObject];
    if (obj != nil){
        NSLog(@"%@",[obj valueForKey:@"username"]);
        imagesData = (NSMutableArray * )[[obj valueForKey:@"pictures"] componentsSeparatedByString:@"@"];
        [imagesData removeObjectAtIndex:0];
        [imagesData removeObjectAtIndex:imagesData.count -1];
        NSLog(@"%@",imagesData);
    }
    
    [tableView_timeline setHidden:TRUE];
    [collectionView_images setHidden:FALSE];
    [tableView_timeline setUserInteractionEnabled:FALSE];
    [collectionView_images setUserInteractionEnabled:TRUE];
    [collectionView_images reloadData];
    
}



- (IBAction)button_timelineClicked:(id)sender {
    NSLog(@"timeline button tapped");
    
    imagesData = [[NSMutableArray alloc] init];
    
    NSManagedObject* obj = [self fetchLoggedInObject];
    if (obj != nil){
        NSLog(@"%@",[obj valueForKey:@"username"]);
        postsTimelineData = (NSMutableArray* )[[obj valueForKey:@"posts"] componentsSeparatedByString:@"@"];
    }
    NSLog(@"post data fetched - %@",postsTimelineData);
    [postsTimelineData removeObjectAtIndex:0];
    [postsTimelineData removeObjectAtIndex:postsTimelineData.count -1];
    NSLog(@"post data changed to  - %@",postsTimelineData);
    
    
    
    [tableView_timeline setHidden:FALSE];
    [collectionView_images setHidden:TRUE];
    [tableView_timeline setUserInteractionEnabled:TRUE];
    [collectionView_images setUserInteractionEnabled:FALSE];
    [tableView_timeline reloadData];
}


- (IBAction)button_backTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) setTheFakeOnlineUserName:(NSString*) fakeUsername {
    NSLog(@"received the fakeOnliner - %@",fakeUsername);
    userToFakeAsOnline = fakeUsername;
}

- (IBAction)button_followTapped:(id)sender {
    
    NSLog(@"clicked on follow/unfollow button");
    NSManagedObject* obj = [self fetchLoggedInObject];
    
    NSManagedObject* originallyOnlineUser = [self fetchOriginallyLoggedIn];
    
    NSLog(@"original user was %@ \nand fake was %@",originallyOnlineUser,obj);
    
    [originallyOnlineUser setValue:[NSString stringWithFormat:@"%@%@@",[originallyOnlineUser valueForKey:@"followings"],[obj valueForKey:@"username"]] forKey:@"followings"];
    
    [originallyOnlineUser setValue:[NSNumber numberWithInt:[[originallyOnlineUser valueForKey:@"followingsNumber"] integerValue] + 1 ] forKey:@"followingsNumber"];
    
    [obj setValue:[NSString stringWithFormat:@"%@%@@",[obj valueForKey:@"followers"],[originallyOnlineUser valueForKey:@"username"]] forKey:@"followers"];
    
    [obj setValue:[NSNumber numberWithInt:[[obj valueForKey:@"followersNumber"] integerValue] + 1 ] forKey:@"followersNumber"];
    
    label_userFollowers.text = [NSString stringWithFormat:@"%d",[[obj valueForKey:@"followersNumber"] integerValue]  ] ;
    
    [[self managedObjectContext] save:nil] ;
    
    
    NSLog(@"OriginalUser changed to %@ \n and fake to %@",[self fetchOriginallyLoggedIn],[self fetchLoggedInObject]);
    
    [button_follow setTitle:@"Unfollow" forState:UIControlStateNormal];
    
}


@end
