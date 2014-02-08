//
//  Second_Lev_Object.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 10/9/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Third_Lev_Object;

@interface Second_Lev_Object : NSManagedObject

@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *thirdLevel;
@end

@interface Second_Lev_Object (CoreDataGeneratedAccessors)

- (void)addThirdLevelObject:(Third_Lev_Object *)value;
- (void)removeThirdLevelObject:(Third_Lev_Object *)value;
- (void)addThirdLevel:(NSSet *)values;
- (void)removeThirdLevel:(NSSet *)values;

@end
