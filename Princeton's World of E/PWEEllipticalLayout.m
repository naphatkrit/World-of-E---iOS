//
//  PWEEllipticalLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEEllipticalLayout.h"
#import "PWEHexagonCell.h"

@interface PWEEllipticalLayout()
@property (nonatomic, strong) NSDictionary *layoutInfo;
- (CGRect) frameForHexagonAtIndexPath: (NSIndexPath *)indexPath;
- (void) setup;
@end

@implementation PWEEllipticalLayout

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
    CGFloat size;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        size = 300;
    } else {
        size = 130;
    }
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 40.0f);
    self.itemSize = CGSizeMake(size,size/2.0*sqrtf(3.0));
}

- (void)prepareLayout
{
    [self.collectionView setScrollEnabled:YES];
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
            switch (item) {
                case 3:
                {
                    CGRect cell1Frame = [cellLayoutInfo[[NSIndexPath indexPathForItem:1 inSection:0]] frame];
                    CGRect cell2Frame = [cellLayoutInfo[[NSIndexPath indexPathForItem:2 inSection:0]] frame];
                    itemAttributes.frame = CGRectMake(cell1Frame.origin.x, cell2Frame.origin.y - cell1Frame.origin.y + cell2Frame.origin.y, self.itemSize.width, self.itemSize.height);
                    break;
                }
                case 4:
                {
                    CGRect cell1Frame = [cellLayoutInfo[[NSIndexPath indexPathForItem:0 inSection:0]] frame]; // want x position
                    CGRect cell2Frame = [cellLayoutInfo[[NSIndexPath indexPathForItem:1 inSection:0]] frame]; // used to get delta y
                    CGRect cell3Frame = [cellLayoutInfo[[NSIndexPath indexPathForItem:3 inSection:0]] frame]; // used to get y
                    itemAttributes.frame = CGRectMake(cell1Frame.origin.x, cell3Frame.origin.y - cell1Frame.origin.y + cell2Frame.origin.y, self.itemSize.width, self.itemSize.height);
                    break;
                }
                    //                case 3:
                    //                {
                    //                    CGRect sampleFrame = [self frameForHexagonAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                    //                    sampleFrame = CGRectMake(sampleFrame.origin.x, self.collectionView.bounds.size.height*2.0 -sampleFrame.origin.y-self.itemSize.height*2.0, sampleFrame.size.width, sampleFrame.size.height);
                    //                    itemAttributes.frame = sampleFrame;
                    //                    break;
                    //                }
                    //                case 4:
                    //                {
                    //                    CGRect sampleFrame = [self frameForHexagonAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                    //                    sampleFrame = CGRectMake(sampleFrame.origin.x, self.collectionView.bounds.size.height*2.0 -sampleFrame.origin.y-self.itemSize.height, sampleFrame.size.width, sampleFrame.size.height);
                    //                    itemAttributes.frame = sampleFrame;
                    //                    break;
                    //                }
                default:
                    itemAttributes.frame = [self frameForHexagonAtIndexPath:indexPath];
                    break;
            }
            
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[PWEHexagonCellKind] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
    [self.collectionView reloadData];
}

- (CGRect)frameForHexagonAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    CGFloat height;
//    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
//        width = [[UIScreen mainScreen] bounds].size.width;
//        height = [[UIScreen mainScreen] bounds].size.height - 20.0;
//        self.numberOfColumns = 1;
//    } else {
//        width = [[UIScreen mainScreen] bounds].size.height;
//        height = [[UIScreen mainScreen] bounds].size.width - 20.0;
//        self.numberOfColumns = 2;
//    }
    width = self.collectionView.bounds.size.width;
    height = self.collectionView.bounds.size.height;
    
    NSInteger itemCount  = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        itemCount += [self.collectionView numberOfItemsInSection:i];
    }
    
    CGFloat deltaTheta;
    
    if (itemCount >= 3) {
        deltaTheta = M_PI/6;
    } else {
        deltaTheta = M_PI/2/(itemCount);
    }
    NSInteger itemsInPreviousSections = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        itemsInPreviousSections = itemsInPreviousSections + [self.collectionView numberOfItemsInSection:i];
    }
    CGFloat itemNumber = indexPath.item + itemsInPreviousSections+1.0f/2.0f;
    
    CGFloat b = height - self.itemInsets.top - self.itemInsets.bottom - self.itemSize.height/2.0;
    CGFloat a = width - self.itemInsets.right - self.itemInsets.left - self.itemSize.width/2.0;
    
    
    // formula: x = b/((tan theta)^2 + b^2/a^2)
    // formula: y = b/((cot theta)^2*b^2/a^2 + 1)
    if (indexPath.item == 1) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (a < b) {
                itemNumber -= 0.2;
            }
            else
            {
                itemNumber += 0.2;
            }
        }
        else
        {
            if (a < b) {
                itemNumber -= 0.1;
            }
            else
            {
                itemNumber += 0.1;
            }
        }
    }
    CGFloat tanValue = tanf(M_PI/2 - deltaTheta * itemNumber);
    CGFloat originX = width -b/sqrtf((tanValue*tanValue+(b*b)/(a * a))) - self.itemInsets.right - self.itemSize.width/2.0;
    CGFloat originY = height -b/sqrtf((1/(tanValue*tanValue)*(b*b)/(a*a) + 1.0)) - self.itemInsets.bottom - self.itemSize.height/2.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom ]== UIUserInterfaceIdiomPhone && b>a) {
        originY -= 50.0;
    }
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
//    if (UIInterfaceOrientationIsPortrait(self.currentOrientation)) {
//        width = [[UIScreen mainScreen] bounds].size.width;
//        height = [[UIScreen mainScreen] bounds].size.height - 20.0;
//        self.numberOfColumns = 1;
//    } else {
//        width = [[UIScreen mainScreen] bounds].size.height;
//        height = [[UIScreen mainScreen] bounds].size.width - 20.0;
//        self.numberOfColumns = 2;
//    }
    width = self.collectionView.bounds.size.width;
    height = self.collectionView.bounds.size.height;
    NSInteger itemCount  = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        itemCount += [self.collectionView numberOfItemsInSection:i];
    }
    if (itemCount < 4) {
        return CGSizeMake(width, height);
    } else if (itemCount == 4) {
        return CGSizeMake(width, height*1.5);
    } else {
        return CGSizeMake(width, height*1.8);
    }
}
@end
