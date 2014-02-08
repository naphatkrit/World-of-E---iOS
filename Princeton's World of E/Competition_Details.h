//
//  Competition_Details.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Competition;

@interface Competition_Details : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * prizes;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Competition *main;

@end
