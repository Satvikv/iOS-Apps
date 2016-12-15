//
//  MDDWebServiceRequestor.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/03/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SQLiteDbController;
@interface MDDWebServiceRequestor : NSObject

@property (strong,nonatomic) SQLiteDbController *dbController;
@property int customer_id;
-(BOOL) uploadCustomerInfo :(int) customer_id error:(NSError**)err;
//-(BOOL) uploadRoomsInfo :(NSString *) quote_id :(NSMutableDictionary *)roomsInfo error:(NSError **)err;
@end
