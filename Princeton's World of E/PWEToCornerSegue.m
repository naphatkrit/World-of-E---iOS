//
//  PWEToCornerSegue.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEToCornerSegue.h"
#import "PWEViewController.h"

#define kAnimationKey @"move animation key"

@implementation PWEToCornerSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    UIView *view = sourceViewController.view;
    
    PWEViewController *parentViewController = (PWEViewController *) sourceViewController.parentViewController;
    [destinationViewController willMoveToParentViewController:parentViewController];
    [parentViewController addChildViewController:destinationViewController];
    [view.superview insertSubview:destinationViewController.view belowSubview:view];
    [parentViewController setMainView:destinationViewController.view];
    [view.superview bringSubviewToFront:view];
    
    CGFloat width;
    CGFloat height;
    cDims(parentViewController, width, height)
    
//    [parentViewController addToCornerView:view];
    
    CGFloat cornerWidth;
    CGFloat cornerHeight;
    cCornerDims(cornerWidth, cornerHeight)
    // set frame correctly
    [view.layer removeAnimationForKey:kAnimationKey];
    
    // adjust constraints
    UIView *containerView = view.superview;
    
    
    
    for (NSLayoutConstraint *constraint in containerView.constraints) {
        if (constraint.secondItem == view || constraint.firstItem == view) {
            [containerView removeConstraint:constraint];
        }
    }
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:cornerWidth/3.5]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:cornerHeight/3]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerHeight]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerWidth]];
    
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[view(%f)]",cornerWidth] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(%f)]",cornerHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    destinationViewController.view.alpha = 0;
    [self.delegate animationWillBegin];
    [UIView animateWithDuration:kAnimationTime animations:^{
//        [containerView layoutIfNeeded];
        [view layoutIfNeeded];
        view.transform = CGAffineTransformMakeRotation(kCornerRotateAngleRad);
        destinationViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [parentViewController addToCornerView:view];
        [self.delegate animationDidComplete];
    }];
}

@end
