//
//  PWEFromCornerSegue.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEFromCornerSegue.h"
#import "PWEViewController.h"
#import "UIViewController+SaveConstraints.h"
#define kAnimationKey @"anim key"

@implementation PWEFromCornerSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    UIView *view = destinationViewController.view;
    PWEViewController *parentViewController = (PWEViewController *) sourceViewController.parentViewController;
    [sourceViewController willMoveToParentViewController:nil];
    [sourceViewController removeFromParentViewController];
    [parentViewController removeFromCornerView:view];
    [parentViewController setMainView:nil];
    
    CGFloat width;
    CGFloat height;
    cDims(parentViewController, width, height)
    
    if (parentViewController.cornerViews.count > 0) {
        [view.superview bringSubviewToFront:(parentViewController.cornerViews)[0]];
    }
    
    [destinationViewController adjustConstraintsFromDictionary];
    [parentViewController setMainView:view];
    [self.delegate animationWillBegin];
    [UIView animateWithDuration:kAnimationTime animations:^{
        [parentViewController.view layoutIfNeeded];
        destinationViewController.view.transform = CGAffineTransformIdentity;
        
        // main
        sourceViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        // main
        [sourceViewController.view removeFromSuperview];
        [self.delegate animationDidComplete];
    }];
}

@end
