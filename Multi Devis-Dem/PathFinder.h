//
//  PathFinder.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathFinder : NSObject
@property NSString *plistPath;
+(NSString *) getPlistDirectoryPath;

+(NSString *) getItemsPlistDirectoryPath;
+(NSString *) getTaskPlistDirectoryPath;
+(NSString *) getHtmlPath;
+(NSString *) getDetailsPlistDirectoryPath;
@end
