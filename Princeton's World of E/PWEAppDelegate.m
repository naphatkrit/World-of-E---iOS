//
//  PWEAppDelegate.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEAppDelegate.h"
#import "PWEDataModelLibrary.h"
#import "Second_Lev_Object.h"
#import "PWECampusMapViewController.h"
#import "PWERootViewController.h"

@interface PWEAppDelegate()

@property (nonatomic, strong, readwrite) PWERootViewController *viewController;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;
@property (nonatomic, assign) int currentPageIndex;

@end

@implementation PWEAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//        [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:note waitUntilDone:YES];
//    }];
//    [GMSServices provideAPIKey:@"AIzaSyBq4kEioFDbCsTeBM3xvEVIOuM8zuMj2Y4"];
//    [PWEDataModelLibrary updateAll];
    PWEDataModelLibrary *dataModel = [PWEDataModelLibrary new];
    [dataModel downloadWithCompletionHandler:^(BOOL completed) {
        
    }];
    
//    _visiblePageIndexArray = [NSMutableArray new];
//    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:0];
//    [self.pageViewController setDataSource:self];
//    [self.pageViewController setDelegate:self];
//    
//    NSString *storyboardName = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"Main_iPhone" : @"Main_iPad";
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
//    self.mainStoryboard = storyboard;
//    
//    PWEViewController *initialViewController = [self.mainStoryboard instantiateInitialViewController];
//    self.currentPageIndex = 0;
//    [self.visiblePageIndexArray insertObject:[NSIndexPath indexPathForItem:0 inSection:0] atIndex:self.currentPageIndex];
//    [self.pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
//        
//    }];
//    [self.pageViewController addChildViewController:initialViewController];
//    initialViewController.managedObjectContext = self.managedObjectContext;
//    [self.pageViewController setWantsFullScreenLayout:YES];
//    for (UIView *subview in self.pageViewController.view.subviews) {
//        if ([subview isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)subview;
//            [scrollView.panGestureRecognizer setEnabled:NO];
//            [scrollView.panGestureRecognizer setMinimumNumberOfTouches:2];
//        }
//    }
    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Learn_Object" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    for (Second_Lev_Object *info in fetchedObjects) {
//        NSLog(@"Name: %@", info.name);
//    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[PWERootViewController alloc] initWithNibName:ROOT_VIEW_CONTROLLER_NIB bundle:[NSBundle mainBundle]];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
//    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[PWEViewController alloc] initWithNibName:@"PWEViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[PWEViewController alloc] initWithNibName:@"PWEViewController_iPad" bundle:nil];
//    }
//    self.window.rootViewController = self.pageViewController;
//    self.viewController.managedObjectContext = self.managedObjectContext;
//    UIColor *bgColor;
//    if (![UIMotionEffect class]) bgColor = [UIColor whiteColor];
//    else bgColor = [UIColor clearColor];
//    [self.window setBackgroundColor:bgColor];
//    [self.window setOpaque:NO];
//    [self.window makeKeyAndVisible];
//    [[UIWindow appearance] setTintColor:kTintColor];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.viewController saveState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PWEDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PWEDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
