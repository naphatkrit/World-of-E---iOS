//
//  PWEFoldedLayout.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/1/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWEFoldedLayout : UICollectionViewLayout

@property (nonatomic) UIInterfaceOrientation currentOrientation;
@property (nonatomic) CGSize itemSize;
@property (nonatomic, strong) NSIndexPath *topIndex;

- (id)init;
@end
