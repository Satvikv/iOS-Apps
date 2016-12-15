//
//  SQLiteDbController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 18/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "SQLiteDbController.h"

@implementation SQLiteDbController
-(void)openConnection
{
    _dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Customer.db"];
    sqlite3_open([_dbPath UTF8String], &(_customerDb));
    NSString *createStmt=@"create table if not exists Customer_master (customer_id INTEGER primary key AUTOINCREMENT,civility TEXT,name TEXT,address TEXT,postcode TEXT,city TEXT,telephone TEXT,email TEXT,loading_address TEXT,loading_postcode TEXT,loading_city TEXT,loading_access TEXT,loading_floor INTEGER,loading_standup_needed BOOL,loading_existence_elevator BOOL,loading_elevator INTEGER,new_house_address TEXT,new_house_postcode TEXT,new_house_city TEXT,new_house_access TEXT,new_house_floor INTEGER,new_house_standup_needed BOOL,new_house_existence_elevator BOOL,new_house_elevator INTEGER,delivery_comment TEXT,moving_date DATE,customer_create_date DATE)";
    const char *createQuery=[createStmt UTF8String];
    sqlite3_stmt *createStatement;
    char *errMsg;
    sqlite3_prepare_v2(_customerDb, createQuery, -1, &(createStatement), NULL);
    if(sqlite3_exec(_customerDb,createQuery , NULL, NULL, &errMsg)!=SQLITE_OK)
    {
        NSLog(@"Error occurred While Opening error %s",errMsg);
    }
    
}

-(void)closeConnection
{
    sqlite3_close(_customerDb);
}

-(void)insertIntoTable
{
    [self openConnection];
    NSString *insertString=[NSString stringWithFormat:@"INSERT INTO Customer_master (name,civility,address,postcode,city,telephone,email,loading_access,loading_existence_elevator,loading_standup_needed,loading_elevator,loading_floor,loading_address,loading_postcode,loading_city,new_house_access,new_house_existence_elevator,new_house_standup_needed,new_house_elevator,new_house_floor,new_house_address,new_house_postcode,new_house_city,delivery_comment,moving_date,customer_create_date) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%i,%i,%i,%i,\"%@\",\"%@\",\"%@\",\"%@\",%i,%i,%i,%i,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",self.customer_name,self.customer_civility,self.customer_address,self.codepostal,self.customer_city,self.telephone,self.customer_email,self.loading_access,self.loading_existence_elevator,self.loading_standup_needed,(int)self.loading_elevator,self.loading_floor,self.loading_address,self.loading_postcode,self.loading_city,self.other_house_access,self.other_house_existence_elevator,self.other_house_standup_needed,self.other_house_elevator,self.other_house_floor,self.other_house_address,self.other_house_postcode,self.other_house_city,self.delivery_comment,self.moving_date,self.customer_create_date];
    const char *insertQuery=[insertString UTF8String];
    char *errMsg;
    sqlite3_stmt *insert_stmt;
    sqlite3_prepare_v2(_customerDb, insertQuery, -1, &insert_stmt, NULL);
    ;
    if (sqlite3_exec(_customerDb,insertQuery,NULL, NULL,&errMsg)==SQLITE_OK) {
       
        _Cust_Id=[NSNumber numberWithLongLong:sqlite3_last_insert_rowid(_customerDb)];
    }
    
 
}
-(void) updateTableWithRowId : (int) customerId
{
    _dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Customer.db"];
    sqlite3_open([_dbPath UTF8String], &(_customerDb));
    NSString *updateString=[NSString stringWithFormat:@"UPDATE Customer_master SET name = \"%@\",civility =\"%@\",address=\"%@\",postcode=\"%@\",city=\"%@\",telephone=\"%@\",email=\"%@\",loading_access=\"%@\",loading_existence_elevator=%i,loading_standup_needed=%i,loading_elevator=%i,loading_floor=%i,loading_address=\"%@\",loading_postcode=\"%@\",loading_city=\"%@\",new_house_access=\"%@\",new_house_existence_elevator=%i,new_house_standup_needed=%i,new_house_elevator=%i,new_house_floor=%i,new_house_address=\"%@\",new_house_postcode=\"%@\",new_house_city=\"%@\",delivery_comment=\"%@\",moving_date=\"%@\",customer_create_date=\"%@\" WHERE customer_id=%i",self.customer_name,self.customer_civility,self.customer_address,self.codepostal,self.customer_city,self.telephone,self.customer_email,self.loading_access,self.loading_existence_elevator,self.loading_standup_needed,(int)self.loading_elevator,self.loading_floor,self.loading_address,self.loading_postcode,self.loading_city,self.other_house_access,self.other_house_existence_elevator,self.other_house_standup_needed,self.other_house_elevator,self.other_house_floor,self.other_house_address,self.other_house_postcode,self.other_house_city,self.delivery_comment,self.moving_date,self.customer_create_date,customerId];
    const char *updateQuery=[updateString UTF8String];
    char *errMsg;
    sqlite3_stmt *update_stmt;
    sqlite3_prepare_v2(_customerDb, updateQuery, -1, &update_stmt, NULL);
    ;
    if (sqlite3_exec(_customerDb,updateQuery,NULL, NULL,&errMsg)==SQLITE_OK) {
        NSLog(@"Updated Successfully");
    }
    else
    {
        NSLog(@"Not updated successfully and message is %s",errMsg);
    }
}
-(void) createOrderTable
{
    _dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Customer.db"];
    sqlite3_open([_dbPath UTF8String], &(_customerDb));
    NSString *createString=[NSString stringWithFormat:@"create table if not exists order_master (id INTEGER primary key AUTOINCREMENT,items_csv TEXT,photo_csv TEXT,video_csv TEXT,tasks_csv TEXT,customer_signature TEXT,agent_signature TEXT,agent_name TEXT,total_volume REAL,category TEXT,customer_id INTEGER,order_create_date DATE, FOREIGN KEY(customer_id) references Customer_master(customer_id))"];
    const char *createQuery=[createString UTF8String];
    sqlite3_stmt *statement;
    char *errMsg1;
    sqlite3_prepare_v2(_customerDb, createQuery, -1, &statement, NULL);
    if (sqlite3_exec(_customerDb, createQuery, NULL, NULL,&(errMsg1))==SQLITE_OK) {
        NSLog(@" the order master table created ");
    }
    else
    {
        NSLog(@" the order master table not created,the error is");
    }
}
-(void) insertIntoOrdersTableWithCustomerId:(int) customerId
{
    NSString *insertString=[NSString stringWithFormat:@"INSERT INTO order_master (items_csv,photo_csv,video_csv,tasks_csv,total_volume,category,customer_id,order_create_date) values (\"%@\",\"%@\",\"%@\",\"%@\",%f,\"%@\",%i,\"%@\")",_items_csv,_photo_csv,_video_csv,_tasks_csv,_total_volume,_category,customerId,_order_create_date];
    const char *insertQuery=[insertString UTF8String];
    sqlite3_stmt *insertStatement;
    char *errMsg;
    sqlite3_prepare_v2(_customerDb, insertQuery, -1, &insertStatement, NULL);
    if(sqlite3_exec(_customerDb, insertQuery, NULL, NULL, &errMsg)==SQLITE_OK)
    {
       
        _order_Id=[NSNumber numberWithLongLong:sqlite3_last_insert_rowid(_customerDb)];
    }
    else
    {
        NSLog(@"not inserted into order_mster ,the error is %s",errMsg);
    }
}

-(void) updateOrderTableWithOrderId:(int) order_id
{
    _dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Customer.db"];
    sqlite3_open([_dbPath UTF8String], &(_customerDb));
    NSString *updateString=[NSString stringWithFormat:@"UPDATE order_master SET items_csv=\"%@\",photo_csv=\"%@\",video_csv=\"%@\",tasks_csv=\"%@\",total_volume=%f,category=\"%@\",order_create_date=\"%@\" where id=%i",_items_csv,_photo_csv,_video_csv,_tasks_csv,_total_volume,_category,_order_create_date,order_id];
    const char *updateQuery=[updateString UTF8String];
    sqlite3_stmt *updateStmt;
    sqlite3_prepare_v2(_customerDb, updateQuery, -1, &updateStmt, NULL);
    char * errMsg;
    if (sqlite3_exec(_customerDb, updateQuery, NULL, NULL, &errMsg)==SQLITE_OK) {
        NSLog(@"order table is updated successfully");
    }
    else
    {
        NSLog(@" updataion to order table not successful %s",errMsg);
    }
}
-(NSMutableDictionary *)retrieveAllDetialsOfCustomer :(int) customer_id
{
    [self openConnection];
    NSString *selectString=[NSString stringWithFormat:@"select * from customer_master where customer_id=%i",customer_id];
    const char *select_query=[selectString UTF8String];
    sqlite3_stmt *select_stmt;
    sqlite3_prepare_v2(_customerDb, select_query, -1, &select_stmt, NULL);
    NSString *selectOrderString=[NSString stringWithFormat:@"select category,total_volume from order_master where customer_id=%i",customer_id];
    const char *select_order_query=[selectOrderString UTF8String];
    sqlite3_stmt *select_order_stmt;
    sqlite3_prepare_v2(_customerDb, select_order_query, -1, &select_order_stmt, NULL);
    if (sqlite3_step(select_stmt)==SQLITE_ROW && sqlite3_step(select_order_stmt)==SQLITE_ROW) {
   
    NSMutableDictionary* personDetails_dict=[NSMutableDictionary dictionaryWithDictionary:@{@"Civility": [NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 1)],@"Name":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 2)],@"Address":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 3)],@"PostCode": [NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 4)],@"City": [NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 5)],@"Tel":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 6)],@"Email":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 7)],@"LoadingAddress":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 8)],@"LoadingPostCode":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 9)],@"LoadingCity":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 10)],@"LoadingAccess":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 11)],@"LoadingMonteFurniture":[NSString stringWithFormat:@"%@",sqlite3_column_int(select_stmt, 13) ? @"Qui" : @"Non"],@"LoadingFloor":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 12)],@"LoadingExistenceElevator":[NSString stringWithFormat:@"%@",sqlite3_column_int(select_stmt, 14) ? @"Qui" : @"Non"],@"LoadingElevator":[NSString stringWithFormat:@"%i",sqlite3_column_int(select_stmt, 15)],@"DeliveryAddress":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 16)],@"DeliveryPostCode":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 17)],@"DeliveryCity":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 18)],@"DeliveryComment":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 24)],@"DeliveryAccess":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 19)],@"DeliveryMonteFurniture":[NSString stringWithFormat:@"%@",sqlite3_column_int(select_stmt, 21) ? @"Qui" : @"Non"],@"DeliveryFloor":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 20)],@"DeliveryExistenceElevator":[NSString stringWithFormat:@"%@",sqlite3_column_int(select_stmt, 22) ? @"Qui" : @"Non"],@"DeliveryElevator":[NSString stringWithFormat:@"%i",sqlite3_column_int(select_stmt, 23)],@"DateDemenagement":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 25)],@"Category":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_order_stmt, 0)],@"Volume":[NSString stringWithFormat:@"%s",sqlite3_column_text(select_order_stmt, 1)],@"State":@"test source",@"Source":@"IPhone"}];
        [self closeConnection];
        sqlite3_finalize(select_stmt);
        sqlite3_finalize(select_order_stmt);
        return personDetails_dict;
    }
    
    return nil;
}
-(NSMutableDictionary *) retrieveOrderTable : (int) customer_id
{
    [self openConnection];
    NSString *selectString=[NSString stringWithFormat:@"select * from order_master where customer_id=%i",customer_id];
    const char *select_query=[selectString UTF8String];
    sqlite3_stmt *select_stmt;
    sqlite3_prepare_v2(_customerDb, select_query, -1, &select_stmt, NULL);
    
    if (sqlite3_step(select_stmt)==SQLITE_ROW) {
        
        NSString *itemsCSV=[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 1)];
        NSString *photosCSV=[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 2)];
        NSString *videoCSV=[NSString stringWithFormat:@"%s",sqlite3_column_text(select_stmt, 3)];
        
        NSArray *roomsItems=[itemsCSV componentsSeparatedByString:@";"];
        NSArray *roomPhotos=[photosCSV componentsSeparatedByString:@";"];
        NSArray *roomVideos=[videoCSV componentsSeparatedByString:@";"];
        
        NSMutableArray *allRoomsArray=[NSMutableArray array];
        for (int index=0; index<roomsItems.count; index++) {
         if ([roomsItems[index] isEqualToString:@""]==NO) {
            NSArray *itemsNamesArray=[roomsItems[index] componentsSeparatedByString:@"="];
            NSArray *itemsPhotosArray=[roomPhotos[index] componentsSeparatedByString:@"="];
            NSArray *itemsVideosArray=[roomVideos[index] componentsSeparatedByString:@"="];
           
            NSMutableDictionary *roomDic=[NSMutableDictionary dictionary];
            NSArray *item_volume_array=[itemsNamesArray[1] componentsSeparatedByString:@","];
            NSArray *item_image_array=[itemsPhotosArray[1] componentsSeparatedByString:@","];
            NSArray *item_video_array=[itemsVideosArray[1] componentsSeparatedByString:@","];
            
             NSMutableArray *itemDicObjectsArray=[NSMutableArray array];
            
            for (int inner_index=0; inner_index<item_volume_array.count; inner_index++) {
             if (![item_volume_array[inner_index] isEqualToString:@""]) {
                NSMutableDictionary *itemDic=[NSMutableDictionary dictionary];
                NSArray *item_volume=[item_volume_array[inner_index] componentsSeparatedByString:@"->"];
                NSArray *item_image=[item_image_array[inner_index] componentsSeparatedByString:@"->"];
                NSArray *item_video=[item_video_array[inner_index] componentsSeparatedByString:@"->"];
                [itemDic setObject:item_volume[0] forKey:@"itemname"];
                [itemDic setObject:item_volume[1] forKey:@"itemvolume"];
                
                if ([item_image[1] isEqualToString:@"EMPTY"] &&[item_video[1] isEqualToString:@"EMPTY"]) {
                    [itemDic setObject:@"No media" forKey:@"media_name"];
                    [itemDic setObject:@"No media" forKey:@"media_data"];
                }
                else if (![item_image[1] isEqualToString:@"EMPTY"])
                {
                    [itemDic setObject:item_image[1] forKey:@"media_name"];
                    NSString *imageFilePath=[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",customer_id,item_image[1]];
                    NSString *mediaData=[[NSData dataWithContentsOfFile:imageFilePath] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [itemDic setObject:mediaData forKey:@"media_data"];
                }
                else if (![item_video[1] isEqualToString:@"EMPTY"])
                {
                    [itemDic setObject:item_video[1] forKey:@"media_name"];
                    NSString *videoFilePath=[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",customer_id,item_video[1]];
                    NSLog(@"the path is %@",videoFilePath);
                    NSString *mediaData=[[NSData dataWithContentsOfFile:videoFilePath] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    [itemDic setObject:mediaData forKey:@"media_data"];

                }
                [itemDicObjectsArray addObject:itemDic];
             }
            }
            [roomDic setObject:itemsNamesArray[0] forKey:@"roomname"];
            [roomDic setObject:itemDicObjectsArray forKey:@"items"];
            [allRoomsArray addObject:roomDic];
         }

        }
        
        
        NSMutableDictionary *all_rooms_dictionary=[NSMutableDictionary dictionaryWithObject:allRoomsArray forKey:@"rooms"];
        sqlite3_finalize(select_stmt);
        [self closeConnection];
        return all_rooms_dictionary;
    }
    else
    {
        NSLog(@"unsuccessful");
    }
    return nil;
}
-(void)deleteCustomerInfo:(int) customer_id
{
//    _dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Customer.db"];
//    sqlite3_open([_dbPath UTF8String], &(_customerDb));
    NSString *deleteString=[NSString stringWithFormat:@"DELETE from customer_master where customer_id=%i",customer_id];
    NSString *deleteorderString=[NSString stringWithFormat:@"DELETE from order_master where customer_id=%i",customer_id];
    const char *delete_customer_query=[deleteString UTF8String];
    const char *delete_order_query=[deleteorderString UTF8String];
    sqlite3_stmt *customer_stmt;
    sqlite3_stmt *order_stmt;
    sqlite3_prepare_v2(_customerDb, delete_customer_query, -1, &customer_stmt, NULL);
    sqlite3_prepare_v2(_customerDb, delete_order_query, -1, &order_stmt, NULL);
    char *errMsg1,*errMsg2;
    if ((sqlite3_exec(_customerDb, delete_customer_query, NULL, NULL, &errMsg1)==SQLITE_OK)  ) {
        if ((sqlite3_exec(_customerDb, delete_order_query, NULL, NULL, &errMsg2)==SQLITE_OK)) {
           
        }
        else
        {
            NSLog(@"deletion not done in order master table error is %s",errMsg2);
        }
       
    }
    else
    {
        NSLog(@"deletin not done in customer master the errors is\n\n %s",errMsg1);
    }
}
-(NSMutableDictionary *) retrieveDetailsOfCustomer
{
    [self openConnection];
    NSString *selectQuery=@"select c.customer_id,name,moving_date,total_volume from order_master o,customer_master c  where c.customer_id =o.customer_id;";
    const char *select_query=[selectQuery UTF8String];
    sqlite3_stmt *select_details_stmt;
    NSMutableDictionary *customerDetailsDictionary=[NSMutableDictionary dictionary];
    sqlite3_prepare_v2(_customerDb, select_query, -1, &select_details_stmt, NULL);
    while (sqlite3_step(select_details_stmt)==SQLITE_ROW ) {
        NSMutableDictionary *customerDictionary=[NSMutableDictionary dictionary];
        [customerDictionary setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(select_details_stmt, 1)] forKey:@"CustomerName"];
        [customerDictionary setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(select_details_stmt, 2)] forKey:@"CustomerMovingDate"];
        [customerDictionary setObject:[NSString stringWithFormat:@"%0.2lf",sqlite3_column_double(select_details_stmt, 3)] forKey:@"Volume"];
        [customerDetailsDictionary setObject:customerDictionary forKey:[NSString stringWithFormat:@"%i",sqlite3_column_int(select_details_stmt, 0)]];
    }
    sqlite3_finalize(select_details_stmt);
    [self closeConnection];
    return customerDetailsDictionary;
}
@end
