//
//  Course.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Course_Details, Faculty;

@interface Course : Third_Lev_Object

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) Course_Details *details;
@property (nonatomic, retain) Faculty *faculty;

@end
