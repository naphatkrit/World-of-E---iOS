//
//  Internship.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 10/9/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Internship_Details;

@interface Internship : Third_Lev_Object

@property (nonatomic, retain) Internship_Details *details;

@end
