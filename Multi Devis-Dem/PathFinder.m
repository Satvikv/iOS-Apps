//
//  PathFinder.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "PathFinder.h"

@implementation PathFinder
+(NSString *) getPlistDirectoryPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
+(NSString *) getItemsPlistDirectoryPath
{
    return [[NSBundle mainBundle] pathForResource:@"Updated_french_items" ofType:@"plist"];
}
+(NSString *) getTaskPlistDirectoryPath
{
    return [[NSBundle mainBundle] pathForResource:@"Tasks" ofType:@"plist"];
}
+(NSString *)getHtmlPath
{
    return [[NSBundle mainBundle] pathForResource:@"Economique_fr" ofType:@"html"];;
}

+(NSString *)getDetailsPlistDirectoryPath
{
    return [[NSBundle mainBundle] pathForResource:@"CustomerDetails" ofType:@"plist"];
}
@end
