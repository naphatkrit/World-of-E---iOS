//
//  PWEMainBackgroundView.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEMainBackgroundView.h"

@implementation PWEMainBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews)
    {
        CGPoint newCoord = CGPointMake(point.x - subview.frame.origin.x, point.y - subview.frame.origin.y);
        if ([subview hitTest:newCoord withEvent:event] != nil)
        {
            return [super hitTest:point withEvent:event];
        }
    }
    return nil;
}
@end
