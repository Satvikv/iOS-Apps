//
//  CustomNavBar.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 12/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar
-(id)init
{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(0, 20, 0, 0);
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20,320,20)];
        statusBarImage.image=[UIImage imageNamed:@"status_bar"];
        [self addSubview:statusBarImage];
        [self setBarStyle:UIBarStyleBlack];
        [self setTranslucent:NO];
        [self setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 24)];
        [titleLabel setText:@"MULTI DEVIS-DEM"];
        [titleLabel setFont:[UIFont fontWithName:@"System" size:17]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
//        NavigationBarFrame=CGRectMake(0, 40,NavigationBarFrame.size.width, NavigationBarFrame.size.height);
//        //Adding status Bar image
//        UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, NavigationBarFrame.size.width, 20)];
//        statusBarImage.image=[UIImage imageNamed:@"status_bar"];
//        [self.navigationController.navigationBar addSubview:statusBarImage];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
