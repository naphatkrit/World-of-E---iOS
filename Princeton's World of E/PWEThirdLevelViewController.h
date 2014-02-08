//
//  PWEThirdLevelViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/3/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"
#import "PWECornerSegueDelegate.h"

@interface PWEThirdLevelViewController : UICollectionViewController <NSFetchedResultsControllerDelegate,UIScrollViewDelegate, PWECornerSegueDelegate>

@property (nonatomic) PWEHexagonType cellType;

- (void)adjustForRotation:(NSNotification *)notification;
- (IBAction)unwindToThird:(UIStoryboardSegue *)sender;

// core data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *oldVisibleCells;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSIndexPath *topIndexForFoldedLayout;
- (Third_Lev_Object *)entityForIndexPath:(NSIndexPath *)indexPath;
@end
