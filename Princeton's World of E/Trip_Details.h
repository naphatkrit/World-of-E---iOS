//
//  Trip_Details.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/28/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trip;

@interface Trip_Details : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Trip *main;

@end
