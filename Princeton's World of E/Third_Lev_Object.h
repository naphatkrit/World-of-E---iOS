//
//  Third_Lev_Object.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 10/9/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Second_Lev_Object;

@interface Third_Lev_Object : NSManagedObject

@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Second_Lev_Object *secondLevel;

@end
