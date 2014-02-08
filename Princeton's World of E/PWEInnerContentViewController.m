//
//  PWEInnerContentViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEInnerContentViewController.h"
#import "PWECourseContentViewController.h"
#import "PWECampusMapViewController.h"
#import "PWECompetitionContentViewController.h"
#import "PWEGenericContentViewController.h"
#import "PWEWorkshopContentViewController.h"

@interface PWEInnerContentViewController ()

@end

@implementation PWEInnerContentViewController
- (id)initWithEntity:(Third_Lev_Object *)entity
{
    self = [super init];
    if (self) {
        [self setEntity:entity];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)adjustHeightForOrientation:(UIInterfaceOrientation)orientation
{
    
}
+ (Class)getSubClassForEntity:(NSString *)entityName
{
    if ([entityName isEqualToString:@"Course"]) return [PWECourseContentViewController class];
    else if ([entityName isEqualToString:@"Workshop"]) return [PWEWorkshopContentViewController class];
    else if ([entityName isEqualToString:@"Competition"]) return [PWECompetitionContentViewController class];
    else if ([entityName rangeOfString:@"Campus Map"].location != NSNotFound) return [PWECampusMapViewController class];
    else if ([entityName rangeOfString:@"None"].location == NSNotFound) return [PWEGenericContentViewController class];
    else return nil;
}
+ (NSString *)specifyNibName
{
    return nil;
}
@end
