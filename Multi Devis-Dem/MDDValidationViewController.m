//
//  MDDValidationViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDValidationViewController.h"
#define NavigationBarFrame self.navigationController.navigationBar.frame
#import "PathFinder.h"
#import "SQLiteDbController.h"
#import "Reachability.h"
#import "MDDWebServiceRequestor.h"
@interface MDDValidationViewController ()<UIAlertViewDelegate>

@end
//
int count;
@implementation MDDValidationViewController
{
    NSMutableDictionary *validationDictionary;
    SQLiteDbController *dbCtrl;
    NSDictionary *quotationDictionary;
    NSMutableArray *columnsArray;
    NSMutableArray *columnDetailArray;
    UIActivityIndicatorView *uploadActivityView;
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
    validationDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:[PathFinder getDetailsPlistDirectoryPath]];
    dbCtrl=[[SQLiteDbController alloc]init];
    [dbCtrl openConnection];
      	// Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    // Assigning database values to a customer details Dictionary
    count=0;
    
    NSString *query=[NSString stringWithFormat:@"select * from Customer_master where customer_id=%i",[_customer_Id intValue]];
    NSString *orderQuery=[NSString stringWithFormat:@"select category,total_volume from order_master where customer_id=%i",[_customer_Id intValue]];
    const char *orderSelectQuery=[orderQuery UTF8String];
    const char *selectQuery=[query UTF8String];
    sqlite3_stmt *selectStmt;
    sqlite3_stmt *order_Stmt;
    //char *errMsg1,*errMsg2;
    sqlite3_prepare_v2(dbCtrl.customerDb, selectQuery, -1, &selectStmt, NULL);
    sqlite3_prepare_v2(dbCtrl.customerDb, orderSelectQuery, -1, &order_Stmt, NULL);    
    NSArray *dicKeys=[self getSortedKeys:validationDictionary];
    if (sqlite3_step(selectStmt)==SQLITE_ROW  && sqlite3_step(order_Stmt)==SQLITE_ROW)  {
        for (int i=0; i<[dicKeys count]; i++) {
            NSMutableDictionary *innerDic=[validationDictionary objectForKey:dicKeys[i]];
            NSArray *innnerDicKeys= [self getSortedKeys:innerDic];
            for (NSString *key in innnerDicKeys) {
                count++;
                NSMutableArray *array=[innerDic objectForKey:key];
                
                switch (count) {
                    case 1:  [array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%s. %s",sqlite3_column_text(selectStmt, count),sqlite3_column_text(selectStmt, count+1)]];
                        count++;break;
                    case 12:
                    case 15:
                    case 20:
                    case 23:
                        [array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%i",sqlite3_column_int(selectStmt, count)]];
                        break;
                    case 13:
                    case 14:
                    case 21:
                    case 22:
                        [array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",sqlite3_column_int(selectStmt, count) ? @"Qui" : @"Non"]]; break;
                    case 26:[array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(order_Stmt, 0)]];break;
                    case 27:[array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%0.2lf",sqlite3_column_double(order_Stmt, 1)]];break;
                    default:
                        [array replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(selectStmt, count)]];break;
                }
                
            }
            
        }
        
    }
   
    sqlite3_finalize(selectStmt);
    sqlite3_finalize(order_Stmt);
    
    [_quotationTable reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NavigationBarFrame=CGRectMake(0,40,320,44);
    //Adding status Bar image
    UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, 320, 20)];
    statusBarImage.image=[UIImage imageNamed:@"status_bar"];
    [self.navigationController.navigationBar addSubview:statusBarImage];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
    [dbCtrl closeConnection];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Sorting Keys for the sake of order
-(NSArray *) getSortedKeys :(NSDictionary *)dictionary
{
    return [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - table view data source
-(NSArray *)getEachDetailArray :(NSIndexPath *)indexPath
{
    NSMutableDictionary *innerDic=[validationDictionary objectForKey:[self getSortedKeys:validationDictionary][indexPath.section]];
    
    NSArray *innerDicKeys=[self getSortedKeys:innerDic];
    
    return [innerDic objectForKey:innerDicKeys[indexPath.row]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [validationDictionary allKeys].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *detailsArray=[self getEachDetailArray:indexPath];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ValidationCell"];
    UILabel *label1=(UILabel *)[cell viewWithTag:1];
    label1.text=detailsArray[0];
   
    UILabel *label2=(UILabel *)[cell viewWithTag:2];
    label2.text=detailsArray[1];
    
    if (indexPath.row %2==0)
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *innerDic=[validationDictionary objectForKey:[self getSortedKeys:validationDictionary][section]];
    return [[innerDic allKeys] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self getSortedKeys:validationDictionary][section] substringFromIndex:2];
}
- (IBAction)SubmitPress:(UIButton *)sender {
    [self startRequestingWebService];
}
-(void) startRequestingWebService
{
      
    MDDWebServiceRequestor *serviceRequestor=[[MDDWebServiceRequestor alloc]init];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        UIAlertView *noInternetAlert=[[UIAlertView alloc]initWithTitle:@"désolé" message:@"S'il vous plaît vérifier votre connexion Internet" delegate:self cancelButtonTitle:@"bien" otherButtonTitles: nil];
        noInternetAlert.tag=4;
        [noInternetAlert show];
    }
    else{
        __block  BOOL status;
        __block  NSError *err;
        dispatch_group_t uploadTaskGroup=dispatch_group_create();
        dispatch_queue_t uploadQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        uploadActivityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        uploadActivityView.center=self.view.center;
        [uploadActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [uploadActivityView setColor:[UIColor blackColor]];
        [self.view addSubview:uploadActivityView];
        [uploadActivityView startAnimating];
        self.view.userInteractionEnabled=NO;
        dispatch_group_async(uploadTaskGroup, uploadQueue, ^{
            status=[serviceRequestor uploadCustomerInfo:_customer_Id.intValue error:&err];
        });
        dispatch_group_notify(uploadTaskGroup, dispatch_get_main_queue(), ^{
            [uploadActivityView stopAnimating];
            [uploadActivityView removeFromSuperview];
            self.view.userInteractionEnabled=YES;
            UIAlertView *backEndFailureAlert=[[UIAlertView alloc]initWithTitle:@"Désolé pour le inconvinience" message:@"S'il vous plaît essayer de nouveau si vous souhaitez continuer"  delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Réessayer",nil];
            backEndFailureAlert.tag=2;
            if(err!=nil)
            {
                [backEndFailureAlert show];
            }
            else if(!status)
            {
                [backEndFailureAlert show];
            }
            else
            {
                UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"Succès" message:@"Votre devis a été envoyé, Merci d'utiliser nos services" delegate:self cancelButtonTitle:@"merci" otherButtonTitles:nil];
                successAlert.tag=3;
                [successAlert show];
            }
            
        });
    }
    
}
- (IBAction)annulerPress:(id)sender {
    UIAlertView *cancelAlert=[[UIAlertView alloc]initWithTitle:@"Etes-vous sûr?" message:@"Voulez-vous sortir?" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];
    cancelAlert.tag=1;
    [cancelAlert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"]) {
            __block  NSFileManager *imageDirectoryManager;
            [dbCtrl openConnection];
            [dbCtrl deleteCustomerInfo:_customer_Id.intValue];
            [dbCtrl closeConnection];
            [self.tabBarController dismissViewControllerAnimated:YES completion:^{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    imageDirectoryManager=[NSFileManager defaultManager];
                    BOOL isDir;
                    NSString *imagesDirectoryPath=[NSHomeDirectory() stringByAppendingFormat:@"/%i",[_customer_Id intValue]];
                    if ([imageDirectoryManager fileExistsAtPath:imagesDirectoryPath isDirectory:&isDir]) {
                        [imageDirectoryManager removeItemAtPath:imagesDirectoryPath error:nil];
                    }
                });
            }];
        }
    }
    if (alertView.tag==2)
    {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Réessayer"]) {
            [self startRequestingWebService];
            //  [self uploadAllDetailsWithCustomerId:_customer_Id.intValue];
        }
        else
        {
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if (alertView.tag==3) {
        if (buttonIndex==alertView.cancelButtonIndex) {
            [dbCtrl openConnection];
            [dbCtrl deleteCustomerInfo:_customer_Id.intValue];
            [dbCtrl closeConnection];
             int customer_id=[_customer_Id intValue];
            NSFileManager *imageDirectoryManager=[NSFileManager defaultManager];
            BOOL isDir;
            NSString *imagesDirectoryPath=[NSHomeDirectory() stringByAppendingFormat:@"/%i",customer_id];
            if ([imageDirectoryManager fileExistsAtPath:imagesDirectoryPath isDirectory:&isDir]) {
                [imageDirectoryManager removeItemAtPath:imagesDirectoryPath error:nil];
            }

           
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if (alertView.tag==4)
    {
        if(buttonIndex==alertView.cancelButtonIndex)
        {
            [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)backBarButtonPress:(UIBarButtonItem *)sender {
    self.tabBarController.selectedIndex=2;
}
@end
