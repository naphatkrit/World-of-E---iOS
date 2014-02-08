//
//  PWEThirdLevelLayout.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/3/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEThirdLevelLayout.h"

@interface PWEThirdLevelLayout()

@end

@implementation PWEThirdLevelLayout
@synthesize currentOrientation = _currentOrientation;

- (void)setCurrentOrientation:(UIInterfaceOrientation )currentOrientation
{
    if (_currentOrientation != currentOrientation) {
        _currentOrientation = currentOrientation;
//        [self setup];
//        [self invalidateLayout];
    }
}
-(void)setup
{
    
}
- (void)invalidateLayout
{
    [self setup];
    [super invalidateLayout];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (CGRectIsEmpty(self.prevBounds)) {
        self.prevBounds = newBounds;
        return YES;
    }
    return !CGSizeEqualToSize(newBounds.size, self.prevBounds.size);
}
@end
