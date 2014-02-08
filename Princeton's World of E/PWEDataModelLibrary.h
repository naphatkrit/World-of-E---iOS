//
//  PWEDataModelLibrary.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionBlock)(BOOL completed);
typedef void(^UpdateBlock)(NSDictionary *dict, id managedObject);
typedef BOOL(^SearchBlock)(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict);

@interface PWEDataModelLibrary : NSObject

-(void)downloadWithCompletionHandler:(CompletionBlock)completion;
-(void)saveLocalJSONData;

+(void)updateAll;

+(void)updateLearn;
+(void)updateDo;
+(void)updateConnect;

+(void)updateCourses;
+(void)updateWorkshops;

+(void)updateCompetitions;
@end
