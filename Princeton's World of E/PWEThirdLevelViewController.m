//
//  PWEThirdLevelViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/3/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEThirdLevelViewController.h"
#import "PWEHexagonCell.h"
#import "PWEViewController.h"
#import "PWEThirdLevelLayout.h"
#import "PWECollectionViewBGView.h"
#import "PWEFoldedLayout.h"
#import "Course.h"
#import "Club.h"
#import "PWESectionLayout.h"
#import "PWEEllipticalLayout.h"
#import "PWEAppDelegate.h"
#import "PWESingleLayout.h"
#import "UIViewController+SaveConstraints.h"
#import "PWEContentViewController.h"
#import "PWEToCornerSegue.h"
#define segue_identifier @"third to content"

@interface PWEThirdLevelViewController ()

@property (nonatomic, strong) PWEThirdLevelLayout *thirdLevelLayout;
@property (nonatomic, strong) PWEFoldedLayout *foldedLayout;
@property (nonatomic, strong) NSMutableDictionary *defaultConstraintsDictionary;
@property (nonatomic, strong) NSArray *notificationObservers;
@property (nonatomic, assign) BOOL reportScrolling;

-(PWEThirdLevelLayout *)determineLayout;
-(void)updateCell:(PWEHexagonCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setUp;
-(void)validateAllCells;
-(void)setFoldedLayoutForIndexPath:(NSIndexPath *)indexPath;
-(BOOL)entityNameShouldHaveDescription;

@end

@implementation PWEThirdLevelViewController

-(PWEThirdLevelLayout *)determineLayout
{
    if ([self.fetchedResultsController sections].count > 1) {
        return [[PWESectionLayout alloc] init];
    } else {
        return [[PWESingleLayout alloc] init];
    }
    
}
-(PWEFoldedLayout *)foldedLayout
{
    if (_foldedLayout != nil) {
        return _foldedLayout;
    }
    _foldedLayout = [[PWEFoldedLayout alloc]init];
    return _foldedLayout;
}
- (void)setEntityName:(NSString *)entityName
{
    if (entityName != _entityName) _entityName = entityName;
    if (!_thirdLevelLayout) [self setUp];
}
- (void)setUp
{
    self.collectionView.collectionViewLayout = [self determineLayout];
    self.thirdLevelLayout = (PWEThirdLevelLayout *)self.collectionView.collectionViewLayout;
    if ([self.thirdLevelLayout isKindOfClass:[PWESectionLayout class]]) {
        [self.collectionView registerClass:[PWEHexagonCell class] forSupplementaryViewOfKind:@"header" withReuseIdentifier:@"header identifier"];
    }
    [self adjustForRotation:nil];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[PWEHexagonCell class] forCellWithReuseIdentifier:PWEHexagonCellKind];
    [self.collectionView setOpaque:NO];
    NSArray *constraints = self.view.constraints;
    self.view = [[PWECollectionViewBGView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:constraints];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _defaultConstraintsDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self saveConstraintsToDictionary];
    self.reportScrolling = self.thirdLevelLayout == self.collectionView.collectionViewLayout;
}

- (void)validateAllCells
{
    for (PWEHexagonCell *cell in self.collectionView.visibleCells) {
        [self updateCell:cell atIndexPath:[self.collectionView indexPathForCell:cell]];
    }
    
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
    
    
//    [self adjustForRotation];
}
- (Third_Lev_Object *)entityForIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}
- (void)setFoldedLayoutForIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView setCollectionViewLayout:self.foldedLayout animated:NO];
    [self validateAllCells];
}
- (NSMutableDictionary *)dictionaryForSavingConstraint
{
    if (!_defaultConstraintsDictionary) {
        _defaultConstraintsDictionary = [NSMutableDictionary new];
    }
    return _defaultConstraintsDictionary;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForRotation:) name:kNotificationWillChangeOrientation object:nil];
    id observer1 = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationWillChangeOrientation object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.reportScrolling = NO;
    }];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDidChangeOrientation object:Nil queue:nil usingBlock:^(NSNotification *note) {
        [self.collectionView reloadData];
        for (PWEHexagonCell *cell in self.collectionView.visibleCells) {
            [self updateCell:cell atIndexPath:[self.collectionView indexPathForCell:cell]];
        }
        self.reportScrolling = self.thirdLevelLayout == self.collectionView.collectionViewLayout;
    }];
    _notificationObservers = @[self, observer, observer1];
    if (self.topIndexForFoldedLayout) {
        self.reportScrolling = NO;
        [self setFoldedLayoutForIndexPath:self.topIndexForFoldedLayout];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [self adjustForRotation:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    _notificationObservers = nil;
}

- (void)updateCell:(PWEHexagonCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        // don't know indexPath, ask collectionView (cell must already be visible)
        indexPath = [self.collectionView indexPathForCell:cell];
    }
    Third_Lev_Object *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.type != self.cellType) {
        cell.type = self.cellType;
        [cell setNeedsDisplay];
    }
        
    if ([(cell.subviews)[0] frame].size.width != [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].frame.size.width) {
        [cell setNeedsDisplay];
    }
    
    if (self.collectionView.collectionViewLayout == self.foldedLayout) {
        if (cell.gotDescription) {
            cell.gotDescription = NO;
            [cell setNeedsDisplay];
        }
    } else {
        if (cell.gotDescription != self.entityNameShouldHaveDescription) {
            cell.gotDescription = self.entityNameShouldHaveDescription;
            [cell setNeedsDisplay];
        }
    }
    if ([self.entityName isEqualToString:@"Course"])
    {
        Course *courseEntity = (Course *)entity;
//        if (cell.gotDescription != YES) {
//            cell.gotDescription = YES;
//            [cell setNeedsDisplay];
//        }
        if (cell.gotDescription) {
            [cell updateDescriptionWithText:courseEntity.name];
        }
        
        if (self.collectionView.collectionViewLayout == self.thirdLevelLayout) {
            [cell updateTextWithText:[NSString stringWithFormat:@"%i", courseEntity.number.intValue]];
        } else {
            [cell updateTextWithText:[NSString stringWithFormat:@"%@ %i", courseEntity.prefix, courseEntity.number.intValue]];
        }
    }
    else if ([self.entityName isEqualToString:@"Club"])
    {
//        cell.gotDescription = YES;
        if (cell.gotDescription) {
            [cell updateDescriptionWithText:entity.name];
        }
        [cell updateTextWithText:[(Club *)entity shortName]];
        
    }
    else
    {
        
        
        [cell updateTextWithText:entity.name];
    }
}


- (void)setCellType:(PWEHexagonType)cellType
{
    if (_cellType != cellType) {
        _cellType = cellType;
        self.fetchedResultsController = nil;
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
//    if (self.collectionView.collectionViewLayout == self.thirdLevelLayout) {
    UIInterfaceOrientation orientation;
    
    if (notification == nil) orientation = self.interfaceOrientation;
    else orientation = [[[notification userInfo] valueForKey:@"orientation"] intValue];
    
    
    self.thirdLevelLayout.currentOrientation = orientation;
    [self.thirdLevelLayout invalidateLayout];
    [self.foldedLayout setCurrentOrientation:orientation];
    [self.collectionView reloadData];
//    }
}
- (BOOL)entityNameShouldHaveDescription
{
    if ([self.entityName isEqualToString:@"Course"] || [self.entityName isEqualToString:@"Club"]) {
        return YES;
    }
    return NO;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_entityName) return nil;
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(PWEAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSString *sectionKey;
    if ([self.entityName isEqualToString:@"Course"]) {
        sectionKey = @"prefix";
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"prefix" ascending:YES];
        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
        [fetchRequest setSortDescriptors:@[sort,sort2]];
    }
    else if ([self.entityName isEqualToString:@"Competition"])
    {
        sectionKey = @"sectionInfo";
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[sort, sort2]];
    }
    else if ([self.entityName isEqualToString:@"Trip"])
    {
        NSLog(@"Trip");
        sectionKey = @"sectionInfo";
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[sort, sort2]];
    }
    else
    {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[sort]];
    }
    
    
    
    [fetchRequest setFetchBatchSize:8];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKey cacheName:@"Second_Level"];
    _fetchedResultsController.delegate = self;
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    return _fetchedResultsController;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PWEHexagonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PWEHexagonCellKind forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // don't do anything when animating
    PWEHexagonCell *cell = (PWEHexagonCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Third_Lev_Object *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (collectionView.collectionViewLayout == self.thirdLevelLayout) {
        self.topIndexForFoldedLayout = indexPath;
        self.reportScrolling = NO;
        cell.gotDescription = NO;
        [collectionView setCollectionViewLayout:self.foldedLayout animated:YES];
        [self updateCell:cell atIndexPath:indexPath];
        [self performSegueWithIdentifier:segue_identifier sender:entity];
        [self adjustForRotation:nil];
        self.reportScrolling = NO;
        
    }else if (collectionView.collectionViewLayout == self.foldedLayout) {
        cell.gotDescription = self.entityNameShouldHaveDescription;
        
        if ([collectionView respondsToSelector:@selector(setCollectionViewLayout:animated:completion:)]) {
            __weak UICollectionView *collectionViewWeak = collectionView;
            [collectionView setCollectionViewLayout:self.thirdLevelLayout animated:YES completion:^(BOOL finished) {
                self.reportScrolling = YES;
                [self validateAllCells];
                [collectionViewWeak setScrollEnabled:YES];
            }];
        } else {
            [collectionView setCollectionViewLayout:self.thirdLevelLayout animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:kAnimationTime target:^{
                self.reportScrolling = YES;
                [self validateAllCells];
                [collectionView setScrollEnabled:YES];
            }selector:@selector(invoke) userInfo:nil repeats:NO];
        }
        
        CGFloat width, height;
        cDims(self.parentViewController, width, height);
        [self.view setBounds:CGRectMake(0, 0, width, height)];
        [(PWEViewController *)self.parentViewController unwindCurrentView];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [self adjustForRotation:nil];
        [self validateAllCells];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
        self.topIndexForFoldedLayout = nil;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PWEHexagonCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:@"header" withReuseIdentifier:@"header identifier" forIndexPath:indexPath];
    
    if (header.type != self.cellType) {
        header.type = self.cellType;
        header.gotDescription = NO;
        header.isHeader = YES;
        [header setNeedsDisplay];
    }
    if (floor(header.frame.size.width) != floor([[self.thirdLevelLayout layoutAttributesForSupplementaryViewOfKind:@"header" atIndexPath:indexPath] frame].size.width)) {
        [header setNeedsDisplay];
    }
    if ([self.entityName isEqualToString:@"Competition"]) {
        NSString *sectionName = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] name];
        if (sectionName && ![sectionName isEqualToString:@""]) {
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            NSDate *date = [formatter dateFromString: sectionName];
            [formatter setDateFormat:@"MMM yyyy"];
            [header updateTextWithText:[formatter stringFromDate:date]];
        } else {
            [header updateTextWithText:@"Unknown date"];
        }
        
    } else {
        NSString *name = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] name];
        [header updateTextWithText:name];
    }
    
    
    
    return header;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segue_identifier]) {
        PWEContentViewController *contentVC = (PWEContentViewController*) segue.destinationViewController;
        [contentVC setEntityName:self.entityName];
        [contentVC setEntity:sender];
        [contentVC setShouldAnimateIn:YES];
        [(PWEToCornerSegue *)segue setDelegate:self];
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
- (IBAction)unwindToThird:(UIStoryboardSegue *)sender
{
    
}
#pragma mark Corner Segue Delegate
- (void)animationDidComplete
{
}
- (void)animationWillBegin
{
}

@end
