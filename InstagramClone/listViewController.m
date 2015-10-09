//
//  listViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/8/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "listViewController.h"
#import "followCellCustomCell.h"

@interface listViewController (){
    NSString* savedLocation ;
    NSMutableArray* tableData ;
    NSString* userToShowOnline;
}


@end

@implementation listViewController


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
	// Do any additional setup after loading the view.
    NSLog(@"inside ViedDidLoad of listView");
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"inside ViedDidAppear of listView");
    savedLocation = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [imageView_arrowFollowers setHidden:TRUE];
    [imageView_arrowFollowing setHidden:FALSE];
    NSManagedObject* obj = [self fetchLoggedInObject];
    tableData = (NSMutableArray*)[[obj valueForKey:@"followings"] componentsSeparatedByString:@"@"];
    [tableData removeObjectAtIndex:0];
    [tableData removeObjectAtIndex:tableData.count -1];
    [tableView_lists reloadData];
    NSLog(@"%@",tableData);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"inside heightForRowAtindex");
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     NSLog(@"inside numberOfRowsInSection");
    return tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"inside cellForRowAtIndexPath");
    static NSString* tableCellIdentifier = @"tableCellList";
    
    followCellCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil){
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"followCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    
    cell.label_username.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView_profile.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@profilePicture",savedLocation,cell.label_username.text]];
    
    return cell;
    
}

- (IBAction)button_followingsClicked:(id)sender {
    [imageView_arrowFollowers setHidden:TRUE];
    [imageView_arrowFollowing setHidden:FALSE];
    NSManagedObject* obj = [self fetchLoggedInObject];
    tableData = (NSMutableArray*)[[obj valueForKey:@"followings"] componentsSeparatedByString:@"@"];
    [tableData removeObjectAtIndex:0];
    [tableData removeObjectAtIndex:tableData.count -1];
    NSLog(@"%@",tableData);
    [tableView_lists reloadData];
}

- (IBAction)button_followers:(id)sender {
    [imageView_arrowFollowers setHidden:FALSE];
    [imageView_arrowFollowing setHidden:TRUE];
    NSManagedObject* obj = [self fetchLoggedInObject];
    tableData = (NSMutableArray*)[[obj valueForKey:@"followers"] componentsSeparatedByString:@"@"];
    [tableData removeObjectAtIndex:0];
    [tableData removeObjectAtIndex:tableData.count -1];
    NSLog(@"%@",tableData);
    [tableView_lists reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    followCellCustomCell* cell = (followCellCustomCell *)[tableView_lists cellForRowAtIndexPath:indexPath];
    userToShowOnline = cell.label_username.text;
    [self performSegueWithIdentifier:@"segue_listToOther" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController performSelector:@selector(setTheFakeOnlineUserName:) withObject:userToShowOnline];
}
@end
