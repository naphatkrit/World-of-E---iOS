//
//  PWESingleLayout.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 4/7/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEThirdLevelLayout.h"

@interface PWESingleLayout : PWEThirdLevelLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) BOOL startRight;

@end
