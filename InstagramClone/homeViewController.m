//
//  homeViewController.m
//  InstagramClone
//
//  Created by Mac-Mini Mtn on 10/6/15.
//  Copyright (c) 2015 zeekhuge. All rights reserved.
//

#import "homeViewController.h"
#import "postCell.h"

@interface homeViewController (){
    NSMutableArray* tableData ;
    NSString* savedLocation ;
    BOOL justOnce;
    UIRefreshControl* refreshController;
}

-(void ) refreshTable ;
@end

@implementation homeViewController



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
    NSFetchRequest* requests = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"loggedIn == %d", TRUE];
    [requests setPredicate:predicate];
    [requests setReturnsObjectsAsFaults:FALSE];
    NSArray * fetchedResults = [[self managedObjectContext] executeFetchRequest:requests error:&errorObject];
    
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

-(void)refreshTable{
    
    NSMutableArray* localVarTableData = [[NSMutableArray alloc] init];
    NSManagedObject* loggedInObj = [self fetchLoggedInObject];
    NSMutableArray *followingsArr;
    
    if (loggedInObj != nil){
        NSLog(@"%@",[loggedInObj valueForKey:@"username"]);
        followingsArr = [[[loggedInObj valueForKey:@"followings"] componentsSeparatedByString:@"@"] mutableCopy];
    }
    NSLog(@"following data fetched - %@",followingsArr);
    [followingsArr removeObjectAtIndex:0];
    [followingsArr removeObjectAtIndex:followingsArr.count -1];
    NSLog(@"following data changed to  - %@",followingsArr);
    
    for (NSString* user in followingsArr){
        
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"UsernameInfo"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"username == %@",user];
        [req setPredicate:pred];
        [req setReturnsObjectsAsFaults:FALSE];
        NSError* errorObj = nil;
        NSManagedObject* obj = [[[self managedObjectContext] executeFetchRequest:req error:&errorObj] objectAtIndex:0];
        NSUInteger removeStart ;
        if (errorObj == nil){
            if (obj != nil && [[obj valueForKey:@"postsNumber"] integerValue] > 0){
                removeStart = localVarTableData.count;
                NSLog(@"%@ - %@",[obj valueForKey:@"username"], obj);
                NSMutableArray* tempArr = [[[obj valueForKey:@"posts"] componentsSeparatedByString:@"@"] mutableCopy];
                [tempArr removeObjectAtIndex:0];
                [tempArr removeObjectAtIndex:tempArr.count -1];
                [localVarTableData addObjectsFromArray:tempArr];
                NSLog(@"removeStart = %d ",removeStart);
                NSLog (@"tableData data fetched - %@ ",localVarTableData);
                if (localVarTableData.count > 0){
                    for (NSUInteger i = removeStart; i < tempArr.count + removeStart + 3  ; i+=3){
                        [localVarTableData insertObject:user atIndex:i];
                    }
                    NSLog(@"tableData changed to  - %@",localVarTableData);
                }
            }else{
                NSLog(@"obj was nil");
            }
        }else{
            NSLog(@"ther was an error while fetching - %@ %@",errorObj,[errorObj localizedDescription]);
        }
    }
    
    [refreshController endRefreshing];
    tableData =  localVarTableData;
    [tableView_home reloadData];
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
    NSLog(@"inside viewDidLoad of home");
    justOnce =FALSE;
    tableData = [[NSMutableArray alloc] init];
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [refreshController setBackgroundColor:[UIColor redColor]];
    [tableView_home addSubview:refreshController];
    
//
//    [tableView_home reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"inside viewDidAppear of home");
    
    savedLocation = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (justOnce == FALSE) {
         [self refreshTable];
        justOnce = TRUE;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 349.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",(tableData.count/3));
    return (tableData.count/3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"INSIDE cellForRowAtIndexPat");
    static NSString* tableCellIdentifier = @"tableCellHome";
    
    postCell * cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil){
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"postCellForTable" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    cell.imageView_postMakerProfile.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@profilePicture",savedLocation,[tableData objectAtIndex:indexPath.row *3]]];
    NSLog(@"ProfImg - %@",[NSString stringWithFormat:@"%@%@profilePicture",savedLocation,[tableData objectAtIndex:indexPath.row *3]]);
    cell.imageView_postImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",savedLocation,[tableData objectAtIndex:(indexPath.row *3)+2]]];
    NSLog(@"PostImg - %@",[NSString stringWithFormat:@"%@%@",savedLocation,[tableData objectAtIndex:(indexPath.row *3)+2]]);
    cell.label_postMakerUsername.text = [NSString stringWithFormat:@"%@",[tableData objectAtIndex:(indexPath.row *3)]];
    cell.label_postText.text =[NSString stringWithFormat:@"%@",[tableData objectAtIndex:(indexPath.row *3)+1]];
    
    return cell;
    
}



@end
