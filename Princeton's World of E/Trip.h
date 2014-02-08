//
//  Trip.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/28/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Trip_Details;

@interface Trip : Third_Lev_Object

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) Trip_Details *details;

@end
