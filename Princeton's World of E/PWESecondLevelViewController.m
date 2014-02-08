//
//  PWESecondLevelViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/30/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWESecondLevelViewController.h"
#import "PWESecondLevelLayout.h"
#import "PWEHexagonCell.h"
#import "PWEViewController.h"
#import "PWEFoldedLayout.h"
#import "PWEFastNavigationLayout.h"
#import "PWECollectionViewBGView.h"
#import "Second_Lev_Object.h"
#import "PWEAppDelegate.h"
#import "PWEContentViewController.h"
#import "UIViewController+SaveConstraints.h"

#define segue_to_third_id @"second to third"
#define segue_to_content_id @"second to content"

@interface PWESecondLevelViewController ()

@property (nonatomic, strong) PWEFoldedLayout *foldedLayout;
@property (nonatomic, assign) BOOL reportScrolling;
@property (nonatomic, strong) IBOutlet PWEFastNavigationLayout *fastNavigationLayout;
@property (nonatomic, strong) IBOutlet PWESecondLevelLayout *secondLevelLayout;
@property (nonatomic, strong) NSMutableDictionary *defaultConstraintsDictionary;
@property (nonatomic, strong) NSArray *notificationObservers;

- (void)adjustForRotation:(NSNotification *)notification;
- (void)setFoldedLayoutForIndexPath:(NSIndexPath *)indexPath;
- (void)updateCell:(PWEHexagonCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PWESecondLevelViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}
-(PWEFoldedLayout *)foldedLayout
{
    if (_foldedLayout != nil) {
        return _foldedLayout;
    }
    _foldedLayout = [[PWEFoldedLayout alloc]init];
    return _foldedLayout;
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(PWEAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    NSString *entityName;
    switch (self.cellType) {
        case PWEHexagonTypeLearn:
            entityName = @"Learn_Object";
            break;
        case PWEHexagonTypeDo:
            entityName = @"Do_Object";
            break;
        case PWEHexagonTypeConnect:
            entityName = @"Connect_Object";
            break;
        default:
            return nil;
            break;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    [fetchRequest setFetchBatchSize:20];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Error fetching in second level: %@", error.description);
    }
    
    return _fetchedResultsController;
}
- (void)setTopIndexForFoldedLayout:(NSIndexPath *)topIndexForFoldedLayout
{
    if (![_topIndexForFoldedLayout isEqual:topIndexForFoldedLayout]) {
        _topIndexForFoldedLayout = topIndexForFoldedLayout;
        self.foldedLayout.topIndex = _topIndexForFoldedLayout;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView setOpaque:NO];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[PWEHexagonCell class] forCellWithReuseIdentifier:PWEHexagonCellKind];
    
    NSArray *constraints = self.view.constraints;
    self.view = [[PWECollectionViewBGView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:constraints];
    [self setSecondLevelLayout:(PWESecondLevelLayout *)self.collectionView.collectionViewLayout];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
   
    [self adjustForRotation:nil];
    
    _defaultConstraintsDictionary = [[NSMutableDictionary alloc] initWithCapacity:5];
    [self saveConstraintsToDictionary];
    self.reportScrolling = self.secondLevelLayout == self.collectionView.collectionViewLayout;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForRotation:) name:kNotificationWillChangeOrientation object:nil];
    id observer1 = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationWillChangeOrientation object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.reportScrolling = NO;
    }];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDidChangeOrientation object:nil queue:nil usingBlock:^(NSNotification *note) {\
        for (PWEHexagonCell *cell in self.collectionView.visibleCells) {
            [cell setNeedsDisplay];
        }
        self.reportScrolling = self.secondLevelLayout == self.collectionView.collectionViewLayout;
    }];
    //    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationSegueFrom object:nil queue:nil usingBlock:^(NSNotification *note) {
    //        if ([note userInfo][kNotificationKeyForView] == self.view) {
    //            [self adjustConstraintsFromDictionary:_defaultConstraintsDictionary];
    //        }
    //    }];
    _notificationObservers = @[self, observer, observer1];
    [self adjustForRotation:nil];
    if (self.topIndexForFoldedLayout) {
        [self setFoldedLayoutForIndexPath:self.topIndexForFoldedLayout];
        self.reportScrolling = NO;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (NSString *)entityNameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Second_Lev_Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *thirdLevelEntityName = [[[object.thirdLevel anyObject] entity] name];
    if (!thirdLevelEntityName) {
        thirdLevelEntityName = [NSString stringWithFormat:@"none, %@", object.name];
    }
    return thirdLevelEntityName;
}

- (void)setFoldedLayoutForIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView setCollectionViewLayout:self.foldedLayout animated:NO];
}

- (NSMutableDictionary *)dictionaryForSavingConstraint
{
    if (!_defaultConstraintsDictionary) {
        _defaultConstraintsDictionary = [NSMutableDictionary new];
    }
    return _defaultConstraintsDictionary;
}
- (void)viewDidDisappear:(BOOL)animated
{
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    _notificationObservers = nil;
}
- (void)setCellType:(PWEHexagonType)cellType
{
    if (_cellType != cellType) {
        _cellType = cellType;
        _fetchedResultsController = nil;
        [self.collectionView reloadData];
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)adjustForRotation:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation;
    
    if (notification == nil) orientation = self.interfaceOrientation;
    else orientation = [[[notification userInfo] valueForKey:@"orientation"] intValue];
//    if ([self.secondLevelLayout isKindOfClass:[PWESecondLevelLayout class]]) {
//        [self.secondLevelLayout setCurrentOrientation:orientation];
//    }
    [self.foldedLayout setCurrentOrientation:orientation];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id sectionInfo = [self.fetchedResultsController sections][0];
    return [sectionInfo numberOfObjects];
}

- (void)updateCell:(PWEHexagonCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (cell.type != self.cellType) {
        cell.type = self.cellType;
        [cell setNeedsDisplay];
    }
    if ([(cell.subviews)[0] frame].size.width != [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].frame.size.width) {
        [cell setNeedsDisplay];
    }
    
    Second_Lev_Object *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateTextWithText:object.name];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PWEHexagonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PWEHexagonCellKind forIndexPath:indexPath];
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PWEHexagonCell *cell = (PWEHexagonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *thirdLevelEntityName = [self entityNameForItemAtIndexPath:indexPath];
    if (collectionView.collectionViewLayout == self.secondLevelLayout) {
        self.topIndexForFoldedLayout = indexPath;
        
        self.reportScrolling = NO;
        [collectionView setCollectionViewLayout:self.foldedLayout animated:YES];
        
        // split case between two segues here
        if ([thirdLevelEntityName rangeOfString:@"none,"].location != NSNotFound) {
            [self performSegueWithIdentifier:segue_to_content_id sender:thirdLevelEntityName];
        } else {
            [self performSegueWithIdentifier:segue_to_third_id sender:thirdLevelEntityName];
        }
        
        [self adjustForRotation:nil];
        
        
        
    } else if (collectionView.collectionViewLayout == self.foldedLayout) {
        CGFloat width, height;
        cDims(self.parentViewController.parentViewController.parentViewController, width, height);
        [self.view setBounds:CGRectMake(0, 0, width, height)];
        __weak PWESecondLevelViewController *wSelf = self;
        [self.secondLevelLayout invalidateLayout];
        if ([collectionView respondsToSelector:@selector(setCollectionViewLayout:animated:completion:)]) {
            [collectionView setCollectionViewLayout:self.secondLevelLayout animated:YES completion:^(BOOL finished) {
                wSelf.reportScrolling = YES;
                for (PWEHexagonCell *cell in wSelf.collectionView.visibleCells) {
                    [cell setNeedsDisplay];
                }
            }];
        } else {
            [collectionView setCollectionViewLayout:self.secondLevelLayout animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:kAnimationTime target:^{
                wSelf.reportScrolling = YES;
                for (PWEHexagonCell *cell in wSelf.collectionView.visibleCells) {
                    [cell setNeedsDisplay];
                }
            }selector:@selector(invoke) userInfo:nil repeats:NO];
        }
        
        
        [(PWEViewController *)self.parentViewController unwindCurrentView];
        [self adjustForRotation:nil];
       
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:^{
            [cell setNeedsDisplay];
            [collectionView setScrollEnabled:YES];
        }selector:@selector(invoke) userInfo:nil repeats:NO];
        
        self.topIndexForFoldedLayout = nil;
    }
}


#pragma scroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == YES) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.reportScrolling) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStart" object:nil];
    }
}
#pragma storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:unwind_segue_identifier]) {
        [(PWEViewController *)self.parentViewController setSecondViewLevelController:nil];
    }
    else if ([segue.identifier isEqualToString:segue_to_third_id])
    {
        PWEThirdLevelViewController *thirdVC = segue.destinationViewController;
        [thirdVC setCellType:_cellType];
        [thirdVC setEntityName:sender];
        [(PWEViewController *)self.parentViewController setThirdViewLevelController:thirdVC];
    }
    else if ([segue.identifier isEqualToString:segue_to_content_id])
    {
        PWEContentViewController *contentVC = segue.destinationViewController;
        [contentVC setEntityName:sender];
        [contentVC setShouldAnimateIn:YES];
    }
}

- (IBAction)unwindToSecond:(UIStoryboardSegue *)sender
{
    
}

@end
