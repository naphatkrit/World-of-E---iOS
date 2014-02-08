//
//  Club.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 10/9/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"

@class Club_Details;

@interface Club : Third_Lev_Object

@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) Club_Details *details;

@end
