//
//  PWEFoldedLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/1/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEFoldedLayout.h"
#import "PWEHexagonCell.h"

@interface PWEFoldedLayout()
@property (nonatomic, assign) CGFloat scrollViewOffset;
@property (nonatomic, strong) NSDictionary *layoutInfo;

-(void)setup;
-(CGRect)frameForHexagonForIndexPath:(NSIndexPath*)indexPath;

@end

@implementation PWEFoldedLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setCurrentOrientation:(UIInterfaceOrientation)currentOrientation{
    if (_currentOrientation != currentOrientation) {
        _currentOrientation = currentOrientation;
        [self setup];
        [self invalidateLayout];
    }
}
- (void)setTopIndex:(NSIndexPath *)topIndex
{
    if (![_topIndex isEqual:topIndex]) {
       
        _topIndex = topIndex;
        [self invalidateLayout];
    }
}
- (void)setup
{
    self.scrollViewOffset = self.collectionView.contentOffset.y;
    //    CGFloat size;
    //    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
    //        size = [UIScreen mainScreen].bounds.size.width*2/3.5;
    //    } else {
    //        size = ([UIScreen mainScreen].bounds.size.width-20)/2;
    //    }
    CGFloat width;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        width = kCornerViewHeightiPad * 680/716;
    } else {
        width = kCornerViewHeightiPhone * 280/314;
    }
    CGFloat size = width*2/3.5;
    self.itemSize = CGSizeMake(size,size/2.0*sqrtf(3.0));
}

- (void)prepareLayout
{
    [self.collectionView setScrollEnabled:NO];
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath;
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++)
        {
            
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //specify locations, etc, here
            
            itemAttributes.frame = [self frameForHexagonForIndexPath:indexPath];
            PWEHexagonCell *cell = (PWEHexagonCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            if (![indexPath isEqual:self.topIndex]) {
                
                itemAttributes.alpha = 0;
            } else {
                [cell setNeedsDisplay];
                cell.gotDescription = NO;
                itemAttributes.zIndex = 1;
            }
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    newLayoutInfo[PWEHexagonCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForHexagonForIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat cornerHeight, cornerWidth;
    cCornerDims(cornerWidth, cornerHeight);
    //    PWEHexagonCell *cell = (PWEHexagonCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return CGRectMake(self.itemSize.width * 3/8, self.scrollViewOffset - self.itemSize.height *1/2 + cornerHeight/2, self.itemSize.width, self.itemSize.height);
    //    if (cell.gotSelected == YES) {
    //        return CGRectMake(self.itemSize.width * 3/8, self.scrollViewOffset + self.itemSize.height *1/2, self.itemSize.width, self.itemSize.height);
    //    }
    //    else {
    //        if ([self.collectionView.visibleCells containsObject:[self.collectionView cellForItemAtIndexPath:indexPath]]) {
    //            return CGRectMake(0, 0, 0, 0);
    ////            return CGRectMake(self.itemSize.width * 3/8, self.itemSize.height *1/2, self.itemSize.width, self.itemSize.height);
    //        }
    //        else
    //        {
    ////            return CGRectMake(self.itemSize.width * 3/8, self.itemSize.height *1/2, self.itemSize.width, self.itemSize.height);
    //            return CGRectMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height, self.itemSize.width, self.itemSize.height);
    //        }
    //    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementInfo, BOOL *stop)
     {
         [elementInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerstop)
          {
              if (CGRectIntersectsRect(rect, attributes.frame)) {
                  [allAttributes addObject:attributes];
              }
          }];
     }];
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.layoutInfo)[PWEHexagonCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

@end
