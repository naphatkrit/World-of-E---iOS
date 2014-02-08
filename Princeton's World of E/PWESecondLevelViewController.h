//
//  PWESecondLevelViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/30/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface PWESecondLevelViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@property (nonatomic) PWEHexagonType cellType;

// core data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *topIndexForFoldedLayout;

- (IBAction)unwindToSecond:(UIStoryboardSegue *)sender;
- (NSString *)entityNameForItemAtIndexPath:(NSIndexPath *)indexPath;


@end
