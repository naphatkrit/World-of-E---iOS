//
//  Workshop.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Workshop_Details;

@interface Workshop : Third_Lev_Object

@property (nonatomic, retain) Workshop_Details *details;

@end
