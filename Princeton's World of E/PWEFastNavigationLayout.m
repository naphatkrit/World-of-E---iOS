//
//  PWEFastNavigationLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/2/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEFastNavigationLayout.h"

@interface PWEFastNavigationLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
- (void) setup;
- (CGRect)frameForHexagonAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PWEFastNavigationLayout
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
    CGFloat width;
    CGFloat size;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.radius = powf((powf(kCornerViewHeightiPad, 2.0)*(1+powf(680.0/716.0, 2.0))), 0.5)/1.2;
        self.radius = self.radius*1.2;
        width = kCornerViewHeightiPad * 680/716;
        size = width/2.5;
    } else {
        self.radius = powf((powf(kCornerViewHeightiPhone, 2.0)*(1+powf(680.0/716.0, 2.0))), 0.5);
        self.radius = self.radius*0.9;
        width = kCornerViewHeightiPhone * 280/314;
        size = width/2.5;
    }
    self.itemSize = CGSizeMake(size,size/2.0*sqrtf(3.0));
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [self.collectionView setScrollEnabled:NO];
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath;
    
    //max 5 items
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++)
        {
            
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //specify locations, etc, here
            
            itemAttributes.frame = [self frameForHexagonAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[PWEHexagonCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForHexagonAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount  = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        itemCount += [self.collectionView numberOfItemsInSection:i];
    }
    CGFloat deltaTheta = M_PI/2/(itemCount);
    NSInteger itemsInPreviousSections = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        itemsInPreviousSections = itemsInPreviousSections + [self.collectionView numberOfItemsInSection:i];
    }
    CGFloat itemNumber = indexPath.item + itemsInPreviousSections+1.0f/2.0f;
    deltaTheta = M_PI/2.0 - deltaTheta*itemNumber;
    CGFloat originX = self.collectionView.bounds.size.width -self.radius*cosf(deltaTheta) - self.itemSize.width;
    CGFloat originY = self.collectionView.bounds.size.height -self.radius*sinf(deltaTheta) - self.itemSize.height;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
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
