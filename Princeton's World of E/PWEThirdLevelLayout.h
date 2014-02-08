//
//  PWEThirdLevelLayout.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/3/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWEThirdLevelLayout : UICollectionViewLayout

@property (nonatomic) UIInterfaceOrientation currentOrientation;
@property (nonatomic) CGRect prevBounds;
-(void)setup;

@end
