//
//  PWESectionLayout.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEThirdLevelLayout.h"

@interface PWESectionLayout : PWEThirdLevelLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interSectionSpacing;
@property (nonatomic) NSInteger numberOfColumns;


@end
