//
//  PWEDataModelLibrary.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEDataModelLibrary.h"
#import "PWEAppDelegate.h"
#import "Second_Lev_Object.h"
#import "Club.h"
#import "Club_Details.h"
#import "Course.h"
#import "Course_Details.h"
#import "Competition.h"
#import "Competition_Details.h"
#import "Funding.h"
#import "Funding_Details.h"
#import "Internship.h"
#import "Internship_Details.h"
#import "Trip.h"
#import "Trip_Details.h"
#import "Workshop.h"
#import "Workshop_Details.h"

@interface PWEDataModelLibrary()

@property (nonatomic, strong) NSManagedObjectContext *updateContext;
+(void)saveContext:(NSManagedObjectContext *)context;
-(void)saveJSONData:(NSData *)jsonData;
-(void)saveLearnDictionary:(NSDictionary *)learnDict;
-(void)saveDoDictionary:(NSDictionary *)doDictionary;
-(void)saveConnectDictionary:(NSDictionary *)connectDictionary;
-(void)fetchAndUpdateEntityNamed:(NSString *)entityName withArray:(NSArray *)array withSearchBlock:(SearchBlock)searchBlock withUpdateBlock:(UpdateBlock)updateBlock;

// learn
-(void)saveCoursesFromArray:(NSArray *)coursesArray;
-(void)saveWorkshopsFromArray:(NSArray *)workshopsArray;

// do
-(void)saveCompetitionsFromArray:(NSArray *)competitionsArray;
-(void)saveFundingFromArray:(NSArray *)fundingArray;
-(void)saveInternshipsFromArray:(NSArray *)internshipsArray;

// connect
-(void)saveClubsFromArray:(NSArray *)clubsArray;
-(void)saveTripsFromArray:(NSArray *)tripsArray;

@end


@implementation PWEDataModelLibrary
- (void)downloadWithCompletionHandler:(CompletionBlock)completion
{
    BOOL notFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"not first launch"];
    if (!notFirst) {
        [self saveLocalJSONData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"not first launch"];
        if (completion) {
            completion(YES);
        }
    }
    
    NSURL *url = [NSURL URLWithString:URL_JSON];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Connection Error");
            // connection error
            if (completion) {
                completion(NO);
            }
            return;
        }
        [self saveJSONData:data];
        if (completion) {
            completion(YES);
        }
    }];
}

-(void)saveLocalJSONData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"all_data_test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self saveJSONData:data];
}
-(void)saveJSONData:(NSData *)jsonData
{
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"Error parsing JSON Data. Error: %@", error);
        return;
    }
    for (NSDictionary *dict in jsonArray)
    {
        if ([dict[@"name"] isEqualToString:@"Learn"])
        {
            [self saveLearnDictionary:dict];
        }
        else if ([dict[@"name"] isEqualToString:@"Do"])
        {
            [self saveDoDictionary:dict];
        }
        else if ([dict[@"name"] isEqualToString:@"Connect"])
        {
            [self saveConnectDictionary:dict];
        }
    }
    
//    [self saveLearnDictionary:jsonDict[@"Learn"]];
//    [self saveDoDictionary:jsonDict[@"Do"]];
//    [self saveConnectDictionary:jsonDict[@"Connect"]];
    [self.class saveContext:self.updateContext];
}


/*****************Learn*******************************/


-(void)saveLearnDictionary:(NSDictionary *)learnDict
{
    // make sure the necessary learn objects exist
    NSArray *learnObjects = @[
                              @{@"name":@"Courses"},
                              @{@"name":@"Workshops"}
                              ];
    [self fetchAndUpdateEntityNamed:@"Learn_Object" withArray:learnObjects withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Second_Lev_Object *learnObject = (Second_Lev_Object *)obj;
        if ([learnObject.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Second_Lev_Object *learnObject = (Second_Lev_Object *)managedObject;
        learnObject.name = dict[@"name"];
        learnObject.lastModified = [NSDate date];
    }];
    
    for (NSDictionary *section in learnDict[@"sections"]) {
        if ([section[@"name"] isEqualToString:@"Courses"])
        {
            [self saveCoursesFromArray:section[@"content"]];
        }
        else if ([section[@"name"] isEqualToString:@"Workshops"])
        {
            [self saveWorkshopsFromArray:section[@"content"]];
        }
    }
//
//    // Courses
//    [self saveCoursesFromArray:learnDict[@"Courses"]];
//    
//    // Workshops
//    [self saveWorkshopsFromArray:learnDict[@"Workshops"]];
    
}
- (void)saveCoursesFromArray:(NSArray *)coursesArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOCourses"];
    
    NSError *error;
    Second_Lev_Object *coursesEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    [self fetchAndUpdateEntityNamed:@"Course" withArray:coursesArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        NSString *prefix =targetDict[@"prefix"];
        NSNumber *number = [NSNumber numberWithInteger:[targetDict[@"number"] integerValue]];
        Course *fetchedCourse = (Course *)obj;
        if ([fetchedCourse.prefix isEqualToString:prefix] && [fetchedCourse.number isEqualToNumber:number]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Course *fetchedCourse = (Course *)managedObject;
        fetchedCourse.name = dict[@"name"];
        fetchedCourse.prefix = dict[@"prefix"];
        fetchedCourse.number = [NSNumber numberWithInteger:[dict[@"number"] integerValue]];
        
        if (!fetchedCourse.details) {
            fetchedCourse.details = [NSEntityDescription insertNewObjectForEntityForName:@"Course_Details" inManagedObjectContext:self.updateContext];
        }
        fetchedCourse.details.details = dict[@"details"];
        fetchedCourse.details.url = dict[@"url"];
        fetchedCourse.lastModified = [NSDate date];
        if (!fetchedCourse.secondLevel) {
            [coursesEntity addThirdLevelObject:fetchedCourse];
        }
        
    }];
}
-(void)saveWorkshopsFromArray:(NSArray *)workshopsArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOWorkshops"];
    
    NSError *error;
    Second_Lev_Object *workshopsEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    [self fetchAndUpdateEntityNamed:@"Workshop" withArray:workshopsArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Workshop *fetchedObject = (Workshop *)obj;
        if ([fetchedObject.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Workshop *fetchedObject = (Workshop *)managedObject;
        fetchedObject.name = dict[@"name"];
        if (!fetchedObject.details) {
            fetchedObject.details = [NSEntityDescription insertNewObjectForEntityForName:@"Workshop_Details"inManagedObjectContext:self.updateContext];
        }
        fetchedObject.details.details = dict[@"details"];
        fetchedObject.details.url = dict[@"url"];
        if (!fetchedObject.secondLevel) {
            [workshopsEntity addThirdLevelObject:fetchedObject];
        }
    }];
}

/*****************Do*******************************/

-(void)saveDoDictionary:(NSDictionary *)doDictionary
{
    NSArray *doObjects = @[
                           @{@"name":@"Competitions"},
                           @{@"name":@"Funding"},
                           @{@"name":@"Internships"}
                           ];
    
    [self fetchAndUpdateEntityNamed:@"Do_Object" withArray:doObjects withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Second_Lev_Object *fetched = (Second_Lev_Object *)obj;
        if ([fetched.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Second_Lev_Object *doObject = (Second_Lev_Object *)managedObject;
        doObject.name = dict[@"name"];
        doObject.lastModified = [NSDate date];
    }];
    
    for (NSDictionary *section in doDictionary[@"sections"]) {
        if ([section[@"name"] isEqualToString:@"Competitions"])
        {
            [self saveCompetitionsFromArray:section[@"content"]];
        }
        else if ([section[@"name"] isEqualToString:@"Funding"])
        {
            [self saveFundingFromArray:section[@"content"]];
        }
        else if ([section[@"name"] isEqualToString:@"Internships"])
        {
            [self saveInternshipsFromArray:section[@"content"]];
        }
    }
}
-(void)saveCompetitionsFromArray:(NSArray *)competitionsArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOCompetitions"];
    
    NSError *error;
    Second_Lev_Object *compEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [self fetchAndUpdateEntityNamed:@"Competition" withArray:competitionsArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Competition *competitionObj = (Competition *)obj;
        if ([competitionObj.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Competition *competitionObject = (Competition *)managedObject;
        competitionObject.name = dict[@"name"];
        if (![dict[@"date"] isEqualToString:@"NULL"]) {
            competitionObject.date = [dateFormatter dateFromString:dict[@"date"]];
        }
        
        competitionObject.organizer = dict[@"organizer"];
        competitionObject.onCampus = [NSNumber numberWithBool:[dict[@"on campus"] boolValue]];
        if (!competitionObject.details) {
            competitionObject.details = [NSEntityDescription insertNewObjectForEntityForName:@"Competition_Details" inManagedObjectContext:self.updateContext];
        }
        competitionObject.details.details = dict[@"details"];
        
        competitionObject.details.url = dict[@"url"];
        competitionObject.lastModified = [NSDate date];
        if (!competitionObject.secondLevel) {
            [compEntity addThirdLevelObject:competitionObject];
        }
    }];
}
-(void)saveFundingFromArray:(NSArray *)fundingArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOFunding"];
    NSError *error;
    Second_Lev_Object *fundingEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    [self fetchAndUpdateEntityNamed:@"Funding" withArray:fundingArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Funding *fundingObj = (Funding *)obj;
        if ([fundingObj.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Funding *fundingObj = (Funding *)managedObject;
        fundingObj.name = dict[@"name"];
        if (!fundingObj.details) {
            fundingObj.details = [NSEntityDescription insertNewObjectForEntityForName:@"Funding_Details" inManagedObjectContext:self.updateContext];
        }
        fundingObj.details.details = dict[@"details"];
        fundingObj.details.url = dict[@"url"];
        fundingObj.lastModified = [NSDate date];
        if (!fundingObj.secondLevel) {
            [fundingEntity addThirdLevelObject:fundingObj];
        }
    }];
}
-(void)saveInternshipsFromArray:(NSArray *)internshipsArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOInternships"];
    NSError *error;
    Second_Lev_Object *internshipsEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    
    [self fetchAndUpdateEntityNamed:@"Internship" withArray:internshipsArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Internship *internObj = (Internship *)obj;
        if ([internObj.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Internship *internObj = (Internship *)managedObject;
        internObj.name = dict[@"name"];
        if (!internObj.details) {
            internObj.details = [NSEntityDescription insertNewObjectForEntityForName:@"Internship_Details" inManagedObjectContext:self.updateContext];
        }
        internObj.details.details = dict[@"details"];
        internObj.details.url = dict[@"url"];
        internObj.lastModified = [NSDate date];
        if (!internObj.secondLevel) {
            [internshipsEntity addThirdLevelObject:internObj];
        }
    }];
}

/*****************Connect*******************************/

-(void)saveConnectDictionary:(NSDictionary *)connectDictionary
{
    NSArray *doObjects = @[
                           @{@"name":@"Clubs"},
                           @{@"name":@"Trips"}
//                           ,@{@"name": @"Campus Map"}
                           ];
    
    [self fetchAndUpdateEntityNamed:@"Connect_Object" withArray:doObjects withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Second_Lev_Object *fetched = (Second_Lev_Object *)obj;
        if ([fetched.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Second_Lev_Object *doObject = (Second_Lev_Object *)managedObject;
        doObject.name = dict[@"name"];
        doObject.lastModified = [NSDate date];
    }];
    for (NSDictionary *section in connectDictionary[@"sections"]) {
        if ([section[@"name"] isEqualToString:@"Clubs"])
        {
            [self saveClubsFromArray:section[@"content"]];
        }
        else if ([section[@"name"] isEqualToString:@"Trips"])
        {
            [self saveTripsFromArray:section[@"content"]];
        }
       
    }
}
-(void)saveClubsFromArray:(NSArray *)clubsArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOClubs"];
    NSError *error;
    Second_Lev_Object *clubsEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    [self fetchAndUpdateEntityNamed:@"Club" withArray:clubsArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Club *clubObj = (Club *)obj;
        if ([clubObj.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Club *clubObj = (Club *)managedObject;
        clubObj.name = dict[@"name"];
        clubObj.shortName = dict[@"short_name"];
        if (!clubObj.details) {
            clubObj.details = [NSEntityDescription insertNewObjectForEntityForName:@"Club_Details" inManagedObjectContext:self.updateContext];
        }
        clubObj.details.details = dict[@"details"];
        clubObj.details.url = dict[@"url"];
        clubObj.lastModified = [NSDate date];
        if (!clubObj.secondLevel) {
            [clubsEntity addThirdLevelObject:clubObj];
        }
    }];
}
-(void)saveTripsFromArray:(NSArray *)tripsArray
{
    NSFetchRequest *fetchRequest = [self.updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOTrips"];
    NSError *error;
    Second_Lev_Object *tripsEntity = [self.updateContext executeFetchRequest:fetchRequest error:&error][0];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [self fetchAndUpdateEntityNamed:@"Trip" withArray:tripsArray withSearchBlock:^BOOL(id obj, NSUInteger idx, BOOL *stop, NSDictionary *targetDict) {
        Trip *tripObj = (Trip *)obj;
        if ([tripObj.name isEqualToString:targetDict[@"name"]]) {
            return YES;
        }
        return NO;
    } withUpdateBlock:^(NSDictionary *dict, id managedObject) {
        Trip *tripObj = (Trip *)managedObject;
        tripObj.name = dict[@"name"];
        if (![dict[@"date"] isEqualToString:@"NULL"]) {
            tripObj.date = [dateFormatter dateFromString:dict[@"date"]];
        }
        tripObj.organizer = dict[@"organizer"];
        if (!tripObj.details) {
            tripObj.details = [NSEntityDescription insertNewObjectForEntityForName:@"Trip_Details" inManagedObjectContext:self.updateContext];
        }
        tripObj.details.details = dict[@"details"];
        tripObj.details.location = dict[@"location"];
        tripObj.details.url = dict[@"url"];
        tripObj.lastModified = [NSDate date];
        if (!tripObj.secondLevel) {
            [tripsEntity addThirdLevelObject:tripObj];
        }
    }];
}

-(void)fetchAndUpdateEntityNamed:(NSString *)entityName withArray:(NSArray *)array withSearchBlock:(SearchBlock)searchBlock withUpdateBlock:(UpdateBlock)updateBlock
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetch setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    NSError *error;
    NSArray *fetchedArray = [self.updateContext executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Error fetching. Error: %@", error.description);
        return;
    }
    NSMutableSet *unusedSet = [NSMutableSet setWithArray:fetchedArray];
    for (NSDictionary *dict in array) {
        // get index
        NSUInteger index = NSNotFound;
        if (fetchedArray) {
            index = [fetchedArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return searchBlock(obj, idx, stop, dict);
            }];
        }
        
        NSManagedObject *fetchedObject;
        
        if (index == NSNotFound)
        {
            // create new
            fetchedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.updateContext];
        }
        else
        {
            // update existing
            fetchedObject = fetchedArray[index];
            [unusedSet removeObject:fetchedObject];
        }
        updateBlock(dict, fetchedObject);
    }
    for (NSManagedObject *unusedObject in unusedSet) {
        [self.updateContext deleteObject:unusedObject];
    }
}
+ (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *err;
    [context save:&err];
    if (err) {
        NSLog(@"Error saving. Error: %@",err.description);
    }
    NSManagedObjectContext *parentContext = context.parentContext;
    [parentContext performBlockAndWait:^{
        NSError *err;
        [parentContext save:&err];
        if (err) {
            NSLog(@"Error saving to parent context. Error: %@", err.description);
        }
    }];
    
}

-(NSManagedObjectContext *)updateContext
{
    if (!_updateContext) {
        _updateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_updateContext setParentContext:[(PWEAppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext]];
        [_updateContext setUndoManager:nil];
    }
    return _updateContext;
}
+(NSManagedObjectContext *)createUpdateContext
{
    NSManagedObjectContext *updateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [updateContext setParentContext:[(PWEAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [updateContext setUndoManager:nil];
    return updateContext;
}


+(void)updateAll;
{
    [self updateLearn];
    [self updateDo];
    [self updateConnect];
    
}

+(void)updateLearn
{
    NSString *entityName = @"Learn_Object";
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:updateContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedArray = [updateContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedArray.count == 2) {
        // update
    } else
    {
        // delete existing
        
        for (Second_Lev_Object *object in fetchedArray) {
            [updateContext deleteObject:object];
        }
        
        // create new
        Second_Lev_Object *object1 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        object1.name = @"Courses";
        object1.lastModified = [NSDate date];
        
        Second_Lev_Object *object2 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object2.name = @"Workshops";
        object2.lastModified = [NSDate date];
        
        [self saveContext:updateContext];
    }
    [self updateCourses];
    [self updateWorkshops];
}

+(void)updateDo
{
    NSString *entityName = @"Do_Object";
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:updateContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedArray = [updateContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedArray.count == 3) {
        // update
    } else
    {
        // delete existing
        
        for (Second_Lev_Object *object in fetchedArray) {
            [updateContext deleteObject:object];
        }
        
        // create new
        Second_Lev_Object *object1 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        object1.name = @"Internships";
        object1.lastModified = [NSDate date];
        
        Second_Lev_Object *object2 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object2.name = @"Competitions";
        object2.lastModified = [NSDate date];
        
        Second_Lev_Object *object3 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object3.name = @"Funding";
        object3.lastModified = [NSDate date];
        
        [self saveContext:updateContext];
    }
    
    [self updateCompetitions];
}

+(void)updateConnect
{
    NSString *entityName = @"Connect_Object";
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:updateContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedArray = [updateContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedArray.count == 5) {
        // update
    } else
    {
        // delete existing
        
        for (Second_Lev_Object *object in fetchedArray) {
            [updateContext deleteObject:object];
        }
        
        // create new
        Second_Lev_Object *object1 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        object1.name = @"Events";
        object1.lastModified = [NSDate date];
        
        Second_Lev_Object *object2 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object2.name = @"Clubs";
        object2.lastModified = [NSDate date];
        
        Second_Lev_Object *object3 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        object3.name = @"Alumni";
        object3.lastModified = [NSDate date];
        
        Second_Lev_Object *object4 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object4.name = @"Faculty";
        object4.lastModified = [NSDate date];
        
        Second_Lev_Object *object5 = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:updateContext];
        
        object5.name = @"Campus Map";
        object5.lastModified = [NSDate date];
        
        [self saveContext:updateContext];
    }
}

+(void)updateCourses
{
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOCourses"];
    
    NSError *error;
    Second_Lev_Object *coursesEntity = [updateContext executeFetchRequest:fetchRequest error:&error][0];
    if (coursesEntity.thirdLevel.count == 0)
    {
        NSArray *courseArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Courses" ofType:@"plist"]];
        for (NSDictionary *courseDict in courseArray) {
            Course *courseEntity1 = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:updateContext];
            courseEntity1.name = [courseDict valueForKey:@"name"];
            courseEntity1.lastModified = [NSDate date];
            courseEntity1.prefix = [courseDict valueForKey:@"prefix"];
            courseEntity1.number = [courseDict valueForKey:@"number"];
            Course_Details *courseDetails = [NSEntityDescription insertNewObjectForEntityForName:@"Course_Details" inManagedObjectContext:updateContext];
            [courseEntity1 setDetails:courseDetails];
            courseDetails.details = [courseDict valueForKey:@"details"];
            courseDetails.url = [courseDict valueForKey:@"url"];
            [coursesEntity addThirdLevelObject:courseEntity1];
        }
    }
    [self saveContext:updateContext];
}

+(void)updateWorkshops
{
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOWorkshops"];
    
    NSError *error;
    Second_Lev_Object *workshopEntity = [updateContext executeFetchRequest:fetchRequest error:&error][0];
    if (workshopEntity.thirdLevel.count == 0)
    {
        NSArray *workshopArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Workshops" ofType:@"plist"]];
        for (NSDictionary *workshopDict in workshopArray) {
            Workshop *workshopEntity1 = [NSEntityDescription insertNewObjectForEntityForName:@"Workshop" inManagedObjectContext:updateContext];
            workshopEntity1.name = [workshopDict valueForKey:@"name"];
            
            Workshop_Details *workshopDetails = [NSEntityDescription insertNewObjectForEntityForName:@"Workshop_Details" inManagedObjectContext:updateContext];
            [workshopEntity1 setDetails:workshopDetails];
            workshopDetails.details = [workshopDict valueForKey:@"details"];
            
            [workshopEntity addThirdLevelObject:workshopEntity1];
        }
    }
    [self saveContext:updateContext];
}

+(void)updateCompetitions
{
    NSManagedObjectContext *updateContext = [self createUpdateContext];
    
    NSFetchRequest *fetchRequest = [updateContext.persistentStoreCoordinator.managedObjectModel fetchRequestTemplateForName:@"FetchSLOCompetitions"];
    
    NSError *error;
    Second_Lev_Object *compEntity = [updateContext executeFetchRequest:fetchRequest error:&error][0];
    if (compEntity.thirdLevel.count == 0)
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSArray *compArray = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Competitions" ofType:@"plist"]];
        for (NSDictionary *compDict in compArray) {
            Competition *compEntity1 = [NSEntityDescription insertNewObjectForEntityForName:@"Competition" inManagedObjectContext:updateContext];
            compEntity1.name = [compDict valueForKey:@"name"];
            compEntity1.onCampus = [compDict valueForKey:@"on campus"];
            compEntity1.organizer = [compDict valueForKey:@"organizer"];
            if (![compDict[@"date"] isEqualToString:@"NULL"]) {
                compEntity1.date = [dateFormatter dateFromString:compDict[@"date"]];
            }
            Competition_Details *compDetails = [NSEntityDescription insertNewObjectForEntityForName:@"Competition_Details" inManagedObjectContext:updateContext];
            compDetails.details = [compDict valueForKey:@"details"];
            [compEntity1 setDetails:compDetails];
            
            [compEntity addThirdLevelObject:compEntity1];
        }
    }
    [self saveContext:updateContext];
}

@end
