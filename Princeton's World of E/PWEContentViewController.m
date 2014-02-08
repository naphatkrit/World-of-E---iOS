//
//  PWEContentViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 3/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEContentViewController.h"
#import "PWEAppDelegate.h"
#import "PWEInnerContentViewController.h"

@interface PWEContentViewController ()

@property (nonatomic, strong) NSArray *notificationObservers;
@property (nonatomic, assign) BOOL reportScrolling;
@property (nonatomic, weak) PWEInnerContentViewController *innerContentViewController;

@end

@implementation PWEContentViewController
-(void)viewWillLayoutSubviews
{
    
}
-(void)viewDidLayoutSubviews
{
//    [_scrollView setContentSize:CGSizeMake(320, 800)];
}
-(void)viewDidLoad
{
    self.reportScrolling = YES;
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (UIView *subviews in self.view.subviews) {
        [subviews setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    PWEInnerContentViewController *innerContentViewController = [[[PWEInnerContentViewController getSubClassForEntity:_entityName] alloc] initWithEntity:self.entity];
    __weak PWEContentViewController *wSelf = self;
    self.innerContentViewController = innerContentViewController;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDidChangeOrientation object:nil queue:nil usingBlock:^(NSNotification *note) {
        [innerContentViewController adjustHeightForOrientation:[note.userInfo[@"orientation"] intValue]];
        
        [wSelf.contentHeight setConstant:wSelf.contentViewInner.bounds.size.height];
        self.reportScrolling = YES;
    }];
    id observer2 = [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationWillChangeOrientation object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.reportScrolling = NO;
    }];
    _notificationObservers = @[observer, observer2];
   
    [self addChildViewController:innerContentViewController];
    _contentViewInner = innerContentViewController.view;
    [_contentHeight setConstant:_contentViewInner.bounds.size.height];
    // add shadow
//    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _contentView.layer.shadowOpacity = 0.5;
//    _contentView.layer.shadowRadius = 2.0;
//    _contentView.layer.shadowOffset = CGSizeMake(0, 0);
//    _contentView.layer.shouldRasterize = YES;
    
//    _contentViewInner.layer.shouldRasterize = NO;
    
    // add border
    [_contentView.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor];
    [_contentView.layer setBorderWidth:0.5];
    
    CGFloat cornerWidth, cornerHeight;
    cCornerDims(cornerWidth, cornerHeight);
    
    [_contentView addSubview:_contentViewInner];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInner attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInner attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInner attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentViewInner attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    if (innerContentViewController.noScrollInset) {
        [_bottomDistance setConstant:0];
//        [_scrollView setContentOffset:CGPointMake(0, -10)];
        [_scrollView setScrollEnabled:NO];
        for (UIGestureRecognizer *recognizer in _scrollView.gestureRecognizers) {
            [_scrollView removeGestureRecognizer:recognizer];
        }
        
    } else {
        [_bottomDistance setConstant:cornerHeight];
    }
    if (self.shouldAnimateIn) {
        [self animateIn];
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.innerContentViewController adjustHeightForOrientation:self.interfaceOrientation];
    self.contentHeight.constant = self.contentViewInner.bounds.size.height;
}
- (void)viewDidDisappear:(BOOL)animated
{
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    _notificationObservers = nil;
}

-(void)animateIn
{
    CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    moveUp.fromValue = [NSNumber numberWithFloat:self.view.bounds.size.height/2.0];
    moveUp.toValue = @0.0f;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @0.0f;
    fade.toValue = @1.0f;
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    [animationGroup setAnimations:@[moveUp,fade]];
    animationGroup.duration = kAnimationTime;
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.view.layer addAnimation:animationGroup forKey:@"move"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)formatView
{
    
}
#pragma scroll view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == YES) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStart" object:nil];
}
@end
