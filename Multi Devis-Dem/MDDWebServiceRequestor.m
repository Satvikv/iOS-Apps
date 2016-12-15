//
//  MDDWebServiceRequestor.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/03/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDWebServiceRequestor.h"
#import "SQLiteDbController.h"
@implementation MDDWebServiceRequestor



-(BOOL) uploadCustomerInfo :(int) customer_id error:(NSError**)err
{
    SQLiteDbController *dbController=[[SQLiteDbController alloc]init];
    //[dbController openConnection];
    NSMutableDictionary *customerInfoDictionary= [dbController retrieveAllDetialsOfCustomer:customer_id];
    
    NSMutableDictionary *innerDictionary=[NSMutableDictionary dictionaryWithObject:customerInfoDictionary forKey:@"general_info"];
    NSString *selectQueryString=[NSString stringWithFormat:@"select tasks_csv from order_master where customer_id=%i",customer_id];
           const char *order_select_query=[selectQueryString UTF8String];
        sqlite3_stmt *order_select_stmt;
        sqlite3_prepare_v2(dbController.customerDb, order_select_query, -1, &order_select_stmt, NULL);
        if (sqlite3_step(order_select_stmt)==SQLITE_ROW) {
                NSString *tasks_CSV=[NSString stringWithFormat:@"%s",sqlite3_column_text(order_select_stmt, 0)];
                NSMutableArray *tasksArray=[NSMutableArray arrayWithArray:[tasks_CSV componentsSeparatedByString:@";"]];
                [tasksArray removeLastObject];
                [innerDictionary setObject:tasksArray forKey:@"tasks"];
        }
    sqlite3_finalize(order_select_stmt);
    NSDictionary *outerDictionary=[NSDictionary dictionaryWithObject:innerDictionary forKey:@"quote_info"];
    NSData *customerJsonData=[NSJSONSerialization dataWithJSONObject:outerDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *serviceURL=[NSURL URLWithString:@"http://demo.teleparadigm.com/Multidevis-Dem/quote_request_module_new.php"];
    NSMutableURLRequest *serviceRequest=[NSMutableURLRequest requestWithURL:serviceURL];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:customerJsonData];
     NSError *connectionError;
    __block NSMutableDictionary *roomsDictionary;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0),^{
        roomsDictionary= [dbController retrieveOrderTable:customer_id];
    });
     NSData *responseData;
     BOOL status=NO;
    
        responseData=[NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:nil error:&connectionError];
        *err=connectionError;
        if([responseData length]){
            NSDictionary *responseDictionary=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
          
            if([[responseDictionary objectForKey:@"statuscode"] isEqualToString:@"R001"])
            {
                NSString *quote_id=[responseDictionary objectForKey:@"idquote"];
                NSError *roomsConnectionError;
                status=[self uploadRoomsInfo :quote_id :roomsDictionary error:&roomsConnectionError];
            }
            else
                status=NO;
        }
  
  
    return status;
}

-(BOOL) uploadRoomsInfo :(NSString *) quote_id :(NSMutableDictionary *)roomsInfo error:(NSError **)err
{
    
    [roomsInfo setObject:quote_id forKey:@"quote_id"];
    NSData *roomsJsonData=[NSJSONSerialization dataWithJSONObject:roomsInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL *serviceURL=[NSURL URLWithString:@"http://demo.teleparadigm.com/Multidevis-Dem/media_parse.php"];
    NSMutableURLRequest *serviceRequest=[NSMutableURLRequest requestWithURL:serviceURL];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:roomsJsonData];
   NSData *responseData;
   BOOL status=NO;
        NSError *connectionError;
        responseData=[NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:nil error:&connectionError];
        *err=connectionError;
 
    
        if([responseData length]){
            NSDictionary *responseDictionary=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if([[responseDictionary objectForKey:@"statuscode"] isEqualToString:@"R001"])
            {
                status=YES;
                
            }
            else
                status=NO;
        }
    
    return status;
    
}
@end
