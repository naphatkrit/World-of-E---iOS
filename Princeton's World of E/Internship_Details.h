//
//  Internship_Details.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 10/9/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Internship;

@interface Internship_Details : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Internship *main;

@end
