//
//  PWESingleLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 4/7/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWESingleLayout.h"
#import "PWEHexagonCell.h"

@interface PWESingleLayout()
@property (nonatomic, strong) NSDictionary *layoutInfo;
- (CGRect) frameForHexagonAtIndexPath: (NSIndexPath *)indexPath;
- (void) setup;
@end

@implementation PWESingleLayout

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

- (void)setStartRight:(BOOL)startRight
{
    if (startRight != _startRight) {
        _startRight = startRight;
        [self invalidateLayout];
    }
}

- (void)setup
{
    
    CGFloat width;
    CGFloat scale;
    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
        width = [[UIScreen mainScreen] bounds].size.width;
        scale = 0.8;
    } else {
        width = [[UIScreen mainScreen] bounds].size.height;
        scale = 0.6;
    }
//    width = self.collectionView.bounds.size.width;
    self.itemInsets = UIEdgeInsetsMake(22.0f, 0, 13.0f, 0);
    CGFloat size = (width - self.itemInsets.right - self.itemInsets.left) * 2.0 / 3.5;
    
    size *= scale;
    self.itemSize = CGSizeMake(floor(size), floor(size/2.0*sqrtf(3.0)));
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
            
            itemAttributes.frame = [self frameForHexagonAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[PWEHexagonCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForHexagonAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height;
    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height - 20.0;
    } else {
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width - 20.0;
    }
//    width = self.collectionView.bounds.size.width;
//    height = self.collectionView.bounds.size.height;

    NSInteger itemsInPreviousSections = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        itemsInPreviousSections += [self.collectionView numberOfItemsInSection:i];
    }
    int shiftRight = 0;
    if (self.startRight == YES) shiftRight = 1;
    
    CGFloat delX = (width - self.itemInsets.right - self.itemInsets.left)/3.5 * 1.5; // horizontal distance
    CGFloat delY = sqrtf(3.0)/4.0 * (delX/1.5 * 2.0); // vertical distance
    
    CGFloat xpos = self.itemInsets.left + ((delX/1.5 * 2.0) - self.itemSize.width)/2.0 + ((itemsInPreviousSections + indexPath.row+ shiftRight) % 2) * (delX);
    CGFloat ypos = floorf(self.itemInsets.top + (itemsInPreviousSections +indexPath.row) * delY);
    
    return CGRectMake(xpos, ypos, self.itemSize.width, self.itemSize.height);
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
              CGRect bigRect = CGRectInset(rect, -100.0, -100.0);
              if (CGRectIntersectsRect(bigRect, attributes.frame)) {
                  
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
    CGFloat width;
    CGFloat height;
    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height - 20.0;
    } else {
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width - 20.0;
    }
    CGFloat cornerHeight, cornerWidth;
    cCornerDims(cornerWidth, cornerHeight);
    

    NSInteger numSections = self.collectionView.numberOfSections;
   
    CGRect frame = [self frameForHexagonAtIndexPath:[NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:numSections - 1] -1 inSection:numSections - 1]];

    CGFloat contentH = frame.size.height + frame.origin.y + cornerHeight;
    return CGSizeMake(width, contentH);
}
@end
