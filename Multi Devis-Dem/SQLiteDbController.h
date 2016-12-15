//
//  SQLiteDbController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 18/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQLiteDbController : NSObject

@property sqlite3 *customerDb;
@property NSString *dbPath;

@property (strong,nonatomic) NSNumber *Cust_Id;
@property (strong,nonatomic) NSNumber *order_Id;

@property (weak,nonatomic) NSString *customer_name;
@property (weak,nonatomic) NSString *customer_civility;
@property (weak,nonatomic) NSString *customer_address;
@property (weak,nonatomic) NSString *customer_city;
@property (weak,nonatomic) NSString *customer_email;
@property (weak,nonatomic) NSString *loading_access;
@property (weak,nonatomic) NSString *loading_address;
@property (weak,nonatomic) NSString *loading_city;
@property (weak,nonatomic) NSString *other_house_access;
@property (weak,nonatomic) NSString *other_house_address;
@property (weak,nonatomic) NSString *other_house_city;
@property (weak,nonatomic) NSString *delivery_comment;
@property (weak,nonatomic) NSString *telephone;
@property (weak,nonatomic) NSString *codepostal;
@property (weak,nonatomic) NSString *loading_postcode;
@property (weak,nonatomic) NSString *other_house_postcode;
@property NSInteger loading_elevator,loading_floor,other_house_elevator,other_house_floor;
@property BOOL other_house_existence_elevator,loading_existence_elevator,loading_standup_needed,other_house_standup_needed;
@property (weak,nonatomic) NSString *moving_date,*customer_create_date;

@property (weak,nonatomic) NSString *items_csv;
@property (weak,nonatomic) NSString *photo_csv;
@property (weak,nonatomic) NSString *video_csv;
@property (weak,nonatomic) NSString *tasks_csv;
@property float total_volume;
@property (weak,nonatomic) NSString *category;
@property (weak,nonatomic) NSString *order_create_date;

-(void) openConnection;
-(void) closeConnection;
-(void) insertIntoTable;
-(void) updateTableWithRowId : (int) customerId;
-(void) createOrderTable;
-(void) insertIntoOrdersTableWithCustomerId:(int) customerId;
-(void) updateOrderTableWithOrderId:(int) order_id;
-(NSMutableDictionary *) retrieveOrderTable : (int) customer_id;
-(void)deleteCustomerInfo:(int) customer_id;
-(NSMutableDictionary *) retrieveDetailsOfCustomer;
-(NSMutableDictionary *)retrieveAllDetialsOfCustomer :(int) customer_id;
@end
