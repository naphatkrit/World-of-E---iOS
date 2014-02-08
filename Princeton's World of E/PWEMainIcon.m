//
//  PWEMainIcon.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEMainIcon.h"

@implementation PWEMainIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setMultipleTouchEnabled:NO];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.animating = NO;
    if (self.subviews.count != 0)
    {
        //the hexagons already exist, rearrange accordingly
        if (self.folded == YES)
        {
            for (UIView *view in self.subviews)
            {
                view.frame = CGRectMake(self.bounds.size.width/2 - view.frame.size.width/2, self.bounds.size.height/2 - view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
            }
        }
        else
        {
            for (PWEStandardHexagon *view in self.subviews)
            {
                CGPoint origin = ((NSValue *)(self.origins)[view.type-1]).CGPointValue;
                view.frame = CGRectMake(origin.x - view.frame.size.width/2, origin.y - view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
            }
        }
    }
    else
    {
        //this is the first time this method is called, draw the hexagons
        CGContextRef context = UIGraphicsGetCurrentContext();
        self.origins = [PWECommonCommands drawLearnDoConnectForView:self withContext:context];
        for (PWEStandardHexagon *view in self.subviews)
        {
            view.classDelegate = self.standardHexagonDelegate;
        }
        if (self.folded == YES)
        {
            PWEStandardHexagon *frontView = (self.subviews)[self.topType-1];
            
//            UIColor *shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
//            UIColor *shadowColor = [UIColor redColor];
//            
//            frontView.layer.shadowColor = shadowColor.CGColor;
//            frontView.layer.shadowOffset = CGSizeMake(0, 3);
//            frontView.layer.shadowOpacity = kShadowOpacity;
//            frontView.layer.shadowRadius = 10.0;
//            frontView.layer.shouldRasterize = YES;
            [self bringSubviewToFront:frontView];
            
            for (PWEStandardHexagon *view in self.subviews)
            {
                view.frame = CGRectMake(self.bounds.size.width/2 - view.frame.size.width/2, self.bounds.size.height/2 - view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
                if (view.type != self.topType) {
                    [view setHidden:YES];
                }
            }
        }
    }
}

-(void)foldIconToHexagonType:(PWEHexagonType)type
{
    self.animating = YES;
    self.topType = type;
    
    if (self.folded == NO)
    {
        NSMutableArray *toBeHidden = [[NSMutableArray alloc] init];
        [self setUserInteractionEnabled:NO];
        for (PWEStandardHexagon *view in self.subviews)
        {
            //folding
            [view.layer removeAllAnimations];
            CABasicAnimation *alphaAnimation;
            view.layer.shouldRasterize = NO;
            if (view.type == type)
            {
//                UIColor *shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
//                UIColor *shadowColor = [UIColor redColor];
//                view.layer.shadowColor = shadowColor.CGColor;
//                view.layer.shadowOffset = CGSizeMake(0, 3);
//                view.layer.shadowOpacity = kShadowOpacity;
//                view.layer.shadowRadius = 10.0;
                [self bringSubviewToFront:view];
                alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            }
            else
            {
                alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                alphaAnimation.toValue = @0.5f;
                alphaAnimation.fromValue = @1.0f;
                
//                UIColor *shadowColor = [UIColor redColor];
//                view.layer.shadowColor = shadowColor.CGColor;
//                view.layer.shadowOffset = CGSizeMake(0, 3);
//                view.layer.shadowRadius = 10.0;
//                view.layer.shadowOpacity = 0.0;
                
                [toBeHidden addObject:view];
            }
            CABasicAnimation *moveAnimation1 = [CABasicAnimation animationWithKeyPath:@"position"];
            
            moveAnimation1.fromValue = (self.origins)[view.type-1];
            moveAnimation1.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            
            [animationGroup setAnimations:@[moveAnimation1, alphaAnimation]];
            
            animationGroup.duration = kAnimationTime;
            animationGroup.removedOnCompletion = NO;
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [view.layer addAnimation:animationGroup forKey:@"move1"];
        }
        self.folded = YES;
        [NSTimer scheduledTimerWithTimeInterval:kAnimationTime target:^{
            [self setNeedsDisplay];
            
            for (UIView *hexagons in toBeHidden) {
                [hexagons setHidden:YES];
            }
            [self setUserInteractionEnabled:YES];
            if (self.inFastNavigation == YES) {
                self.inFastNavigation = NO;
            }
            self.animating = NO;
        }selector:@selector(invoke) userInfo:nil repeats:NO];
    }
    else
    {
        [self setUserInteractionEnabled:NO];
        for (PWEStandardHexagon *view in self.subviews)
        {
            [view.layer removeAllAnimations];
            CABasicAnimation *alphaAnimation;
            
            //remove shadow
            for (UIView *subview in view.subviews) {
                view.layer.shadowOpacity = 0;
                [view setHidden:NO];
            }
            
            //animate alpha
            alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            if (view.type != type) {
                alphaAnimation.fromValue = @0.5f;
                alphaAnimation.toValue = @1.0f;
            }
            CABasicAnimation *moveAnimation2 = [CABasicAnimation animationWithKeyPath:@"position"];
            
            moveAnimation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
            moveAnimation2.toValue = (self.origins)[view.type-1];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations:@[moveAnimation2, alphaAnimation]];

            animationGroup.duration = kAnimationTime;
            animationGroup.removedOnCompletion = NO;
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [view.layer addAnimation:animationGroup forKey:@"move2"];
        }
        self.folded = NO;
        [NSTimer scheduledTimerWithTimeInterval:kAnimationTime target:^{
            [self setNeedsDisplay];
            [self setUserInteractionEnabled:YES];
            self.animating = NO;
        }selector:@selector(invoke) userInfo:nil repeats:NO];
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL touched = NO;
    for (PWEStandardHexagon *hexagon in self.subviews) {
        CGPoint pointBounds = CGPointMake(point.x-hexagon.frame.origin.x, point.y - hexagon.frame.origin.y);
        if (CGPathContainsPoint(hexagon.path.CGPath, NULL, pointBounds, true)) {
            touched = YES;
        }
    }
    if (touched == YES) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}
@end
