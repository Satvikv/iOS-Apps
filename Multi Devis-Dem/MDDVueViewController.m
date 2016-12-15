//
//  MDDVueViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/03/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDVueViewController.h"
#import "SQLiteDbController.h"
#import "MDDWebServiceRequestor.h"
#import "Reachability.h"
@interface MDDVueViewController ()<UIAlertViewDelegate>

@end

@implementation MDDVueViewController
{
    UIActivityIndicatorView *uploadActivityView;
    SQLiteDbController *dbCtrl;
    int customer_id;
    NSIndexPath *indexPath_for_deletion;
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
	dbCtrl=[[SQLiteDbController alloc]init];
    //[dbCtrl openConnection];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_quotationDictionary allKeys].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:1];
    nameLabel.text=[_quotationDictionary objectForKey:[_quotationDictionary allKeys][indexPath.row]][@"CustomerName"];
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:2];
    dateLabel.text=[_quotationDictionary objectForKey:[_quotationDictionary allKeys][indexPath.row]][@"CustomerMovingDate"];
    UILabel *volumeLabel=(UILabel *)[cell viewWithTag:3];
    volumeLabel.text=[_quotationDictionary objectForKey:[_quotationDictionary allKeys][indexPath.row]][@"Volume"];
    if (indexPath.row %2==0)
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    customer_id=[[_quotationDictionary allKeys][indexPath.row] intValue];
    indexPath_for_deletion=indexPath;
    [self startRequestingWebService];
}

//Web service Request Method
-(void) startRequestingWebService
{
    
    //dispatch_group_async(uploadTaskGroup, uploadQueue, ^{ });
    MDDWebServiceRequestor *serviceRequestor=[[MDDWebServiceRequestor alloc]init];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        UIAlertView *noInternetAlert=[[UIAlertView alloc]initWithTitle:@"NO " message:@"Please check your internet Connectivity" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
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
            status=[serviceRequestor uploadCustomerInfo:customer_id error:&err];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2)
    {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Réessayer"]) {
            [self startRequestingWebService];
            //  [self uploadAllDetailsWithCustomerId:_customer_Id.intValue];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag==3) {
        if (buttonIndex==alertView.cancelButtonIndex) {
            __block  NSFileManager *imageDirectoryManager;
            [_quotationDictionary removeObjectForKey:[_quotationDictionary allKeys][indexPath_for_deletion.row]];
            [_quotationsTableView deleteRowsAtIndexPaths:@[indexPath_for_deletion] withRowAnimation:UITableViewRowAnimationAutomatic];
            [_quotationsTableView reloadData];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [dbCtrl openConnection];
                [dbCtrl deleteCustomerInfo:customer_id];
                [dbCtrl closeConnection];
                imageDirectoryManager=[NSFileManager defaultManager];
            });
            
        }
    }
    if (alertView.tag==4)
    {
        if(buttonIndex==alertView.cancelButtonIndex)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        customer_id=[[_quotationDictionary allKeys][indexPath.row] intValue];
        [_quotationDictionary removeObjectForKey:[_quotationDictionary allKeys][indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [dbCtrl openConnection];
        [dbCtrl deleteCustomerInfo:customer_id];
        [dbCtrl closeConnection];
        [tableView reloadData];
    }
}
@end
