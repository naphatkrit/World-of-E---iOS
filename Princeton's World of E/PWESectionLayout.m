//
//  PWESectionLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWESectionLayout.h"
#import "PWEHexagonCell.h"

@interface PWESectionLayout()

@property (nonatomic, strong) NSDictionary *layoutInfo;
//@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
- (CGRect) frameForHexagonAtIndexPath: (NSIndexPath *)indexPath;

@end

@implementation PWESectionLayout

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

- (void)setup
{
    CGFloat rightMargin;
    CGFloat width;
    CGFloat height;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        rightMargin = kCornerViewHeightiPad/2.0;
        
    } else {
        rightMargin = kCornerViewHeightiPhone/7.2;
    }
    width = self.collectionView.bounds.size.width;
    height = self.collectionView.bounds.size.height;
    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height - 20.0;
        self.numberOfColumns = 1;
    } else {
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width - 20.0;
        self.numberOfColumns = 2;
    }
    
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, rightMargin);
    self.interSectionSpacing = 0.0;
    CGFloat size = (width-self.itemInsets.left-self.itemInsets.right-self.interSectionSpacing)/self.numberOfColumns/3.5*2.0;
    self.itemSize = CGSizeMake(size,size/2.0*sqrtf(3.0));
}

- (void)prepareLayout
{
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
            
            itemAttributes.frame = [self frameForHexagonAtIndexPath:indexPath];
            itemAttributes.alpha = 1;
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:-1 inSection:section];
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"header" withIndexPath:indexPath];
        itemAttributes.frame = [self frameForHexagonAtIndexPath:indexPath];
        itemAttributes.alpha = 1;
        cellLayoutInfo[indexPath] = itemAttributes;
    }
    
    newLayoutInfo[PWEHexagonCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
//    [self.collectionView reloadData];
    
//    // dynamics
//    if (!_dynamicAnimator) {
//        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
//        
//        for (UICollectionViewLayoutAttributes *layoutAttributes in cellLayoutInfo.allValues) {
//            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:layoutAttributes attachedToAnchor:[layoutAttributes center]];
//            
//            spring.length = 0;
//            spring.damping = 0.8;
//            spring.frequency = 0.9;
//            
//            [_dynamicAnimator addBehavior:spring];
//        }
//    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}
- (CGRect)frameForHexagonAtIndexPath:(NSIndexPath *)indexPath
{
    //first check if it's even or odd section. even section goes to the left. then handle the section separately. Calculate the height of the preceding section plus the interSectionSpacing
    //calculate height of preceding section, not including itemInset
    CGFloat precedingHeight = 0.0;
    for (int section = 0; section<indexPath.section; section++) {
        int numberOfItems = [self.collectionView numberOfItemsInSection:section] + 1;
        if (section % self.numberOfColumns == (indexPath.section %self.numberOfColumns)) {
            int extra = (numberOfItems)%2;
            precedingHeight += 0.5*(self.itemSize.height+1.0)*(numberOfItems +1+extra) +self.interSectionSpacing;
        }
    }
    int row = indexPath.row + 1;
    
    //now that we know where the section should start, calculate the position of the cell, relative to its section
    CGFloat cellOriginX = (row % 2)*(0.75*self.itemSize.width+2.0);
    CGFloat cellOriginY = (0.5*self.itemSize.height + 1.0)*row;
    
    //now put it all together
    CGFloat originX = self.itemInsets.left+cellOriginX + (self.itemSize.width*1.75 + self.interSectionSpacing)*(indexPath.section % self.numberOfColumns);
    CGFloat originY = self.itemInsets.top+precedingHeight+cellOriginY;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
//    return [_dynamicAnimator itemsInRect:rect];
    
    
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
//    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
    return (self.layoutInfo)[PWEHexagonCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    CGFloat leftHeight = 0.0;
    CGFloat rightHeight = 0.0;
    for (int section = 0; section<[self.collectionView numberOfSections]; section++) {
        int numberOfItems = [self.collectionView numberOfItemsInSection:section] + 1;
        int extra = (numberOfItems)%2;
        if (section % self.numberOfColumns == 0) {
            leftHeight += 0.5*(self.itemSize.height+1.0)*(numberOfItems +1+extra) +self.interSectionSpacing;
        }
        else {
            rightHeight += 0.5*(self.itemSize.height+1.0)*(numberOfItems +1+extra) +self.interSectionSpacing;
        }
    }
    CGFloat cornerHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cornerHeight = kCornerViewHeightiPad;
    } else {
        cornerHeight = kCornerViewHeightiPhone;
    }
    return CGSizeMake(self.collectionView.bounds.size.width, MAX(leftHeight, rightHeight)+cornerHeight);
    
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    UIScrollView *scrollView = self.collectionView;
//    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
//    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
//    
//    
//    
//    for (UIAttachmentBehavior *spring in _dynamicAnimator.behaviors) {
//        CGPoint anchorPoint = spring.anchorPoint;
//        CGFloat distFromTouch = fabsf(touchLocation.y - anchorPoint.y);
//        CGFloat scrollResistance = distFromTouch/1000.0;
//        
//        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
//        CGPoint center = item.center;
//        center.y += scrollDelta * MIN(1.0, scrollResistance);
//        item.center = center;
//        
//        [_dynamicAnimator updateItemFromCurrentState:item];
//    }
//    
//    return YES;
//}

@end
