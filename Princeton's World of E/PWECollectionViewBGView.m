//
//  PWECollectionViewBGView.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/3/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWECollectionViewBGView.h"
#import "PWEFoldedLayout.h"
#import "PWEGenericHexagon.h"
#import "PWEHexagonCell.h"

@implementation PWECollectionViewBGView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UICollectionView *collectionView = [self.subviews lastObject];
    if ([collectionView.collectionViewLayout isMemberOfClass:[PWEFoldedLayout class]]) {
        
        BOOL touchedInHexagon = NO;
        for (PWEHexagonCell *hexagonCell in collectionView.visibleCells) {
            
            PWEGenericHexagon *hexagon = (hexagonCell.subviews)[0];
            CGPoint pointBounds = CGPointMake(point.x-hexagonCell.frame.origin.x, point.y - hexagonCell.frame.origin.y);
            if (CGPathContainsPoint(hexagon.path.CGPath, NULL, pointBounds, true)) {
                touchedInHexagon = YES;
            }
        }
        if (touchedInHexagon == YES) {
            return [super hitTest:point withEvent:event];
        } else {
            return nil;
        }
    }
    else{
        return [super hitTest:point withEvent:event];
    }
}

@end
