//
//  Faculty.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Course;

@interface Faculty : Third_Lev_Object

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * office;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Faculty (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
