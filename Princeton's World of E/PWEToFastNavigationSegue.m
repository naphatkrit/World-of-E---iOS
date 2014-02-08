//
//  PWEToFastNavigationSegue.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/19/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEToFastNavigationSegue.h"

@implementation PWEToFastNavigationSegue

-(void)perform
{
    UIViewController *destinationViewController = self.destinationViewController;
    UIViewController *sourceViewController = self.sourceViewController;
    [destinationViewController willMoveToParentViewController:sourceViewController];
    [sourceViewController addChildViewController:destinationViewController];
    [sourceViewController.view addSubview:destinationViewController.view];
    [sourceViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:sourceViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:destinationViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [sourceViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:sourceViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:destinationViewController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [sourceViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:sourceViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:destinationViewController.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [sourceViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:sourceViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:destinationViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [sourceViewController.view layoutIfNeeded];
    [destinationViewController.view setAlpha:0];
    [UIView animateWithDuration:kFastNavigationAnimationTime animations:^{
        [destinationViewController.view setAlpha:1];
    } completion:^(BOOL finished) {
        [destinationViewController.view setAlpha:1];
    }];
}

@end
