//
//  PWEMainIconViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEMainIconViewController.h"
#import "PWESecondLevelViewController.h"
#import "PWEViewController.h"
#import "UIViewController+SaveConstraints.h"
#define segue_identifier @"main to second"
#define kAnimationKey @"move key"

@interface PWEMainIconViewController ()


@property (nonatomic, strong) NSMutableDictionary *defaultConstraintsDictionary;
@property (nonatomic, strong) NSArray *notificationObservers;
@property (nonatomic, assign, getter = isInCorner) BOOL inCorner;

- (void)touchedType:(PWEHexagonType)cellType;


@end

@implementation PWEMainIconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)saveInitialConstraints
{
    _defaultConstraintsDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self saveConstraintsToDictionary];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_mainIcon setOriginalSize:_mainIcon.bounds.size];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (!_defaultConstraintsDictionary) {
        [self saveInitialConstraints];
    }
    
    
    
    if (self.initialFoldedType) {
        // start off folded
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.mainIcon || constraint.secondItem == self.mainIcon) {
                [self.view removeConstraint:constraint];
            }
        }
        
        [self.mainIcon removeConstraints:_mainIcon.constraints];
        
        UIView *view = self.mainIcon;
        UIView *bigView = self.view;
    
        [bigView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [bigView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.mainIcon foldIconToHexagonType:self.initialFoldedType];
        [self setInCorner:YES];
    }
}
- (NSMutableDictionary *)dictionaryForSavingConstraint
{
    if (!_defaultConstraintsDictionary) {
        _defaultConstraintsDictionary = [NSMutableDictionary new];
    }
    return _defaultConstraintsDictionary;
}
- (void)viewWillAppear:(BOOL)animated
{
    _notificationObservers = @[];
    [self.view setNeedsLayout];
}

- (void)viewDidDisappear:(BOOL)animated
{
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    _notificationObservers = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWEHexagonType cellType = [sender intValue];
    PWESecondLevelViewController *secondVC = segue.destinationViewController;
    [secondVC setCellType:cellType];
    [(PWEViewController *)self.parentViewController setSecondViewLevelController:segue.destinationViewController];
    
    // shrink animation
    float scale;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        scale = kCornerViewHeightiPad/_mainIcon.frame.size.height;
    }else {
        scale = kCornerViewHeightiPhone/_mainIcon.frame.size.height;
    }
    
    CABasicAnimation *scaleAnimationx = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimationx.fromValue = @1.0f;
    scaleAnimationx.toValue = @(scale);
    
    CABasicAnimation *scaleAnimationy = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleAnimationy.fromValue = @1.0f;
    scaleAnimationy.toValue = @(scale);
    
    // translation animation
    CGFloat cornerWidth;
    CGFloat cornerHeight;
    cCornerDims(cornerWidth, cornerHeight)
    
//    CABasicAnimation *translateAnimationx = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//    translateAnimationx.toValue = [NSNumber numberWithFloat:-1.0 * (_mainIcon.frame.origin.x + 0.5 * (_mainIcon.frame.size.width - cornerWidth))];
//    
//    CABasicAnimation *translateAnimationy = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    translateAnimationy.toValue = [NSNumber numberWithFloat:-1.0 * (_mainIcon.frame.origin.y + 0.5 * (_mainIcon.frame.size.height - cornerHeight))];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:@[scaleAnimationx, scaleAnimationy]];
    animationGroup.duration = kAnimationTime;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    animationGroup.delegate = self;
    
    [_mainIcon.layer addAnimation:animationGroup forKey:kAnimationKey];    
}

- (void)touchedType:(PWEHexagonType)cellType
{
    [_mainIcon foldIconToHexagonType:cellType];
    switch (self.isInCorner) {
        case YES:
        {
            [(PWEViewController *)self.parentViewController unwindCurrentView];

            [self setInCorner:NO];
            
//            // force redraw
//            for (UIView *subviews in _mainIcon.subviews)
//            {
//                [subviews removeFromSuperview];
//            }
//            [_mainIcon setNeedsDisplay];
            
            
            // grow animation
            float scale;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                scale = _mainIcon.originalSize.height/kCornerViewHeightiPad;
            }else {
                scale = _mainIcon.originalSize.height/kCornerViewHeightiPhone;
            }
            
            CABasicAnimation *scaleAnimationx = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
            scaleAnimationx.fromValue = @1.0f;
            scaleAnimationx.toValue = @(scale);
            
            CABasicAnimation *scaleAnimationy = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            scaleAnimationy.fromValue = @1.0f;
            scaleAnimationy.toValue = @(scale);
            
            // translation animation
            CGFloat width;
            CGFloat height;
            cDims(self.parentViewController, width, height)
            
            CABasicAnimation *translateAnimationx = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translateAnimationx.toValue = @((_mainIcon.originalSize.width * scale - _mainIcon.originalSize.width)/2);

            CABasicAnimation *translateAnimationy = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            translateAnimationy.toValue = @((_mainIcon.originalSize.height * scale - _mainIcon.originalSize.height)/2);
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations:@[translateAnimationx, translateAnimationy, scaleAnimationx, scaleAnimationy]];
            animationGroup.duration = kAnimationTime;
            animationGroup.removedOnCompletion = NO;
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            animationGroup.delegate = self;
            
            [_mainIcon.layer addAnimation:animationGroup forKey:@"12"];
            break;
        }
            
        default:
        {
            [self performSegueWithIdentifier:segue_identifier sender:@(cellType)];
            [self setInCorner:YES];
            break;
        }
    }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_mainIcon.layer animationForKey:kAnimationKey])
    {
        // after shrinking
        CGFloat cornerWidth;
        CGFloat cornerHeight;
        cCornerDims(cornerWidth, cornerHeight)
        
        [_mainIcon.layer removeAnimationForKey:kAnimationKey];
        
        // force redraw
        for (UIView *subviews in _mainIcon.subviews)
        {
            [subviews removeFromSuperview];
        }
        [_mainIcon setNeedsDisplay];
        
        // adjust constraints
//        [self.view removeConstraints:self.view.constraints];
        
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.mainIcon || constraint.secondItem == self.mainIcon) {
                [self.view removeConstraint:constraint];
            }
        }
        
        [self.mainIcon removeConstraints:_mainIcon.constraints];
        
        UIView *view = self.mainIcon;
        UIView *bigView = self.view;
        
        
        [bigView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [bigView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        
    }
    else
    {
        // set frame
        CGFloat width;
        CGFloat height;
        cDims(self.parentViewController, width, height)
        
        // force redraw
        for (UIView *subviews in _mainIcon.subviews)
        {
            [subviews removeFromSuperview];
        }
        [_mainIcon setNeedsDisplay];
        
        [_mainIcon.layer removeAllAnimations];
    }
}
- (IBAction)unwindToMain:(UIStoryboardSegue *)sender
{
    
}
#pragma Mark standard hexagon protocol
- (void)touchedLearn
{
    [self touchedType:PWEHexagonTypeLearn];
}
- (void)touchedDo
{
    [self touchedType:PWEHexagonTypeDo];
}
- (void)touchedConnect
{
    [self touchedType:PWEHexagonTypeConnect];
}

@end
