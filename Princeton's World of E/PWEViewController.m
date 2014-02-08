//
//  PWEViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEViewController.h"
#import "PWEMainIcon.h"
#import "PWEBackground.h"
#import "PWEHexagonCell.h"
#import "PWEGenericHexagon.h"
#import "PWEThirdLevelViewController.h"
#import "PWEContentViewController.h"
#import "PWEMainIconViewController.h"
#import "PWEFromCornerSegue.h"
#import "PWEFastNavigationViewController.h"
#import "PWEMainBackgroundView.h"
#import "PWERestorationPointIndex.h"
#import "UIViewController+Parallax.h"

@interface PWEViewController ()

@property (nonatomic, weak) PWEFastNavigationViewController *fastNavigationViewController;

@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *fastNavigationPanGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *fastNavigationLongPressGestureRecognizer;
@property (nonatomic, strong) NSArray *notificationObservers;
- (IBAction)handleLongPress:(id)sender;
- (void)adjustForRotation:(NSNotification *)notification;
- (IBAction)handlePan:(id)sender;

- (void)beginFastNavigation;
- (void)endFastNavigation:(UIGestureRecognizer *)gestureRecognizer;
- (NSString *)filePath;

@end

@implementation PWEViewController
- (void)viewDidLoad
{
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.wantsFullScreenLayout = YES;
    self.inFastNavigation = NO;
    [super viewDidLoad];

//    [self.view  setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.cornerViews = [NSMutableArray array];
    _mainIconViewController = (self.childViewControllers)[0];
    _mainView = _mainIconViewController.view;
    
    int depth = kParallaxBGDepth;
    [self addParallaxEffectToView:_backgroundView withDepth:depth];
    depth = kParallaxMainDepth;
    [self addParallaxEffectToView:_mainView withDepth:depth];
    
    [self restoreState];
    self.shouldFadeCornerView = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
//    // uncomment to send image of bg to an email
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    picker.mailComposeDelegate = self;
//    
//    // Set the subject of email
//    [picker setSubject:@"MI FOTO FINAL"];
//    
//    // Fill out the email body text
//    NSString *emailBody = @"Foto final";
//    
//    // This is not an HTML formatted email
//    [picker setMessageBody:emailBody isHTML:NO];
//    
//    UIGraphicsBeginImageContextWithOptions(self.mainIconViewController.mainIcon.bounds.size, NO, 4.0);
//    [self.mainIconViewController.mainIcon.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    NSData *data = UIImagePNGRepresentation(viewImage);
//    
//    [picker addAttachmentData:data  mimeType:@"image/png" fileName:@"main hexagon"];
//    
//    
//    // Show email view
//    [self presentViewController:picker animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
//    [self restoreState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForRotation:) name:kNotificationWillChangeOrientation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeCornerView) name:@"scrollStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unfadeCornerView) name:@"scrollStop" object:nil];
    self.notificationObservers = @[self];
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
-(void)saveState
{
    NSString *filePath = self.filePath;
    [NSKeyedArchiver archiveRootObject:self.visiblePageIndex toFile:filePath];
}
-(PWERestorationPointIndex *)visiblePageIndex
{
    if (!_visiblePageIndex) {
        _visiblePageIndex = [[PWERestorationPointIndex alloc] init];
        _visiblePageIndex.hexagonType = PWEHexagonTypeNone;
    }
    return _visiblePageIndex;
}
-(void)restoreState
{
    if (self.visiblePageIndex) {
        [self goToViewForIndex:self.visiblePageIndex animated:NO];
    }
//    NSString *filePath = self.filePath;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        PWERestorationPointIndex *restoredIndex = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//        NSLog(@"restored %@", restoredIndex);
//        if (!self.visiblePageIndex || ![self.visiblePageIndex isEqual:restoredIndex]) {
//            self.visiblePageIndex = restoredIndex;
//            [self goToViewForIndex:self.visiblePageIndex animated:NO];
//        }
//    } else {
//        if (!self.visiblePageIndex) {
//            self.visiblePageIndex = [[PWERestorationPointIndex alloc] init];
//            self.visiblePageIndex.hexagonType = PWEHexagonTypeNone;
//        }
//    }
    

}
-(NSString *)filePath
{
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [libraryDir stringByAppendingString:@"/restoration_index.res"];
    return filePath;
}
-(void)fadeCornerView
{
    if (self.cornerViews.count == 0) return;
    if ([(self.cornerViews)[0] alpha] != 1.0)return;
    if (!self.shouldFadeCornerView) return;
    [[(self.cornerViews)[0] layer] removeAnimationForKey:@"alpha"];
    [(self.cornerViews)[0] setAlpha: kCornerViewAlphaValue];
    [(self.cornerViews)[0] setUserInteractionEnabled:NO];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1.0f;
    alphaAnimation.toValue = [NSNumber numberWithFloat:kCornerViewAlphaValue];
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = YES;
    alphaAnimation.duration = kAnimationTime/2.0;
    [[(self.cornerViews)[0] layer] addAnimation:alphaAnimation forKey:@"alpha"];
}
-(void)unfadeCornerView
{
    if (self.cornerViews.count == 0) return;
    if ([(self.cornerViews)[0] alpha] == 1.0) return;
    
    [(self.cornerViews)[0] setUserInteractionEnabled:YES];
    [[(self.cornerViews)[0] layer] removeAnimationForKey:@"alpha"];
    
    [(self.cornerViews)[0] setAlpha: 1.0];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.toValue = @1.0f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:kCornerViewAlphaValue];
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = YES;
    alphaAnimation.duration = kAnimationTime/2.0;
    [[(self.cornerViews)[0] layer] addAnimation:alphaAnimation forKey:@"alpha"];
}
- (void)setMainView:(UIView *)mainView
{
    if (_mainView != mainView) _mainView = mainView;
    if (mainView == nil) return;
//    if ([self.view.subviews containsObject:mainView]) return;
    
    if (![_containerView.subviews containsObject:mainView])[_containerView insertSubview:mainView belowSubview:[_containerView.subviews lastObject]];
//    mainView.frame = _containerView.bounds;
    UIView *view = mainView;
    for (NSLayoutConstraint *constraint in _containerView.constraints) {
        if (constraint.secondItem == view || constraint.firstItem == view) {
            [_containerView removeConstraint:constraint];
            
        }
    }
    
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self addParallaxEffectToView:_mainView withDepth:kParallaxMainDepth];
}
- (void)addToCornerView:(UIView *)view
{
    if ([_cornerViews containsObject:view]) return;
    [_cornerViews insertObject:view atIndex:0];
    for (int i = 1; i < self.cornerViews.count; i++) {
        [(self.cornerViews)[i] setHidden:YES];
        [(self.cornerViews)[i] setUserInteractionEnabled:NO];
    }
    [self addParallaxEffectToView:view withDepth:kParallaxCornerDepth];
    
    if (view == self.mainIconViewController.view) {
        // main icon went into corner
        self.visiblePageIndex.hexagonType = self.mainIconViewController.mainIcon.topType;
    } else if (view == self.secondViewLevelController.view) {
        // second level went into corner
        self.visiblePageIndex.secondLevelIndexPath = self.secondViewLevelController.topIndexForFoldedLayout;
    } else if (view == self.thirdViewLevelController.view) {
        // third level went into corner
        self.visiblePageIndex.thirdLevelIndexPath = self.thirdViewLevelController.topIndexForFoldedLayout;
    }
}
-(void)removeFromCornerView:(UIView *)view
{
    if (view == self.mainIconViewController.view) {
        // main icon went out of corner
        self.visiblePageIndex.hexagonType = PWEHexagonTypeNone;
    } else if (view == self.secondViewLevelController.view) {
        // second level went out of corner
        self.visiblePageIndex.hexagonType = self.mainIconViewController.mainIcon.topType;
        self.visiblePageIndex.secondLevelIndexPath = nil;
    } else if (view == self.thirdViewLevelController.view) {
        // third level went out of corner
        self.visiblePageIndex.secondLevelIndexPath = self.secondViewLevelController.topIndexForFoldedLayout;
        self.visiblePageIndex.thirdLevelIndexPath = nil;
    }
    
    
    if (![_cornerViews containsObject:view]) return;
    [_cornerViews removeObject:view];
    [view setHidden:NO];
    [view setUserInteractionEnabled:YES];
    
    if (_cornerViews.count == 0) return;
    view = _cornerViews[0];
    [view setHidden:NO];
    [view setUserInteractionEnabled:YES];
}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"willChangeOrientation" object:self userInfo:@{@"orientation": [NSNumber numberWithInt: toInterfaceOrientation]}];
//}


-(void)adjustForRotation:(NSNotification *)notification{
//    if (self.prevOrientation != self.interfaceOrientation || notification.userInfo.allValues[0] == 0) {
//        self.prevOrientation = self.interfaceOrientation;
//        [self.backgroundView setNeedsDisplay];
//    }
    
}
//-(BOOL) shouldAutorotate{
//    return !self.inFastNavigation;
//}
-(void)goToViewForIndex:(PWERestorationPointIndex *)visibleIndex animated:(BOOL)animated
{
    if (!visibleIndex || visibleIndex.hexagonType == PWEHexagonTypeNone) {
        return;
    }
    self.visiblePageIndex = visibleIndex;
    NSMutableArray *toBeRemovedViews = [NSMutableArray new];
    NSMutableArray *addedViews = [NSMutableArray new];
    if (self.mainView) [toBeRemovedViews addObject:self.mainView];
    [toBeRemovedViews addObjectsFromArray:self.cornerViews];
    UIView *containerView = self.containerView;
    CGFloat cornerWidth;
    CGFloat cornerHeight;
    cCornerDims(cornerWidth, cornerHeight);
    self.cornerViews = [NSMutableArray new];
    
    self.mainIconViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_main_icon_vc_identifier];
    
    [self.mainIconViewController setInitialFoldedType:self.visiblePageIndex.hexagonType];
    [self addChildViewController:self.mainIconViewController];
    [self addToCornerView:self.mainIconViewController.view];
    [containerView addSubview:self.mainIconViewController.view];
    
    UIView *cornerView = self.mainIconViewController.view;
    
    for (NSLayoutConstraint *constraint in containerView.constraints) {
        if (constraint.secondItem == cornerView || constraint.firstItem == cornerView) {
            [containerView removeConstraint:constraint];
        }
    }
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:cornerWidth/3.5]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:cornerHeight/3]];
    
    [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerHeight]];
    [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerWidth]];
    cornerView.transform = CGAffineTransformMakeRotation(kCornerRotateAngleRad);
    [addedViews addObject:cornerView];
    
    if (!self.visiblePageIndex.secondLevelIndexPath) {
        // second level as main view
        // set corner views
        
        // set main view
        self.secondViewLevelController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_second_level_vc_identifier];
        [self addChildViewController:self.secondViewLevelController];
        [self.secondViewLevelController setCellType:self.visiblePageIndex.hexagonType];
        [containerView insertSubview:self.secondViewLevelController.view belowSubview:cornerView];
        [self setMainView:self.secondViewLevelController.view];
        [addedViews addObject:self.secondViewLevelController.view];
        [containerView layoutIfNeeded];
    } else {
        // set second level as corner view
        self.secondViewLevelController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_second_level_vc_identifier];
        
        NSIndexPath *index = self.visiblePageIndex.secondLevelIndexPath;
        self.secondViewLevelController.topIndexForFoldedLayout = index;
        self.secondViewLevelController.cellType = self.visiblePageIndex.hexagonType;
        
        [self addChildViewController:self.secondViewLevelController];
        [containerView addSubview:self.secondViewLevelController.view];
        [self addToCornerView:self.secondViewLevelController.view];
        [containerView bringSubviewToFront:self.secondViewLevelController.view];
        
        cornerView = self.secondViewLevelController.view;
        
        for (NSLayoutConstraint *constraint in containerView.constraints) {
            if (constraint.secondItem == cornerView || constraint.firstItem == cornerView) {
                [containerView removeConstraint:constraint];
            }
        }
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:cornerWidth/3.5]];
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:cornerHeight/3]];
        
        [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerHeight]];
        [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerWidth]];
        cornerView.transform = CGAffineTransformMakeRotation(kCornerRotateAngleRad);
        [addedViews addObject:cornerView];
        
        if (!self.visiblePageIndex.thirdLevelIndexPath) {
            // set main view
            NSString *thirdLevelEntityName = [self.secondViewLevelController entityNameForItemAtIndexPath:index];
            UIViewController *mainViewController;
            if ([thirdLevelEntityName rangeOfString:@"none,"].location == NSNotFound) {
                mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_third_level_vc_identifier];
                self.thirdViewLevelController = (PWEThirdLevelViewController *)mainViewController;
                [self.thirdViewLevelController setCellType:self.visiblePageIndex.hexagonType];
                [self.thirdViewLevelController setEntityName:thirdLevelEntityName];
            } else {
                mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_content_view_vc_identifier];
                self.contentViewController = (PWEContentViewController *)mainViewController;
                [self.contentViewController setEntityName:thirdLevelEntityName];
            }
            [self addChildViewController:mainViewController];
            [containerView insertSubview:mainViewController.view belowSubview:cornerView];
            [self setMainView:mainViewController.view];
            [addedViews addObject:mainViewController.view];
            [containerView layoutIfNeeded];
        } else {
            // set third level in corner view
            NSString *thirdLevelEntityName = [self.secondViewLevelController entityNameForItemAtIndexPath:index];
            self.thirdViewLevelController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_third_level_vc_identifier];
            [self.thirdViewLevelController setCellType:self.visiblePageIndex.hexagonType];
            [self.thirdViewLevelController setEntityName:thirdLevelEntityName];
            [self.thirdViewLevelController setTopIndexForFoldedLayout:self.visiblePageIndex.thirdLevelIndexPath];
            
            [self addChildViewController:self.thirdViewLevelController];
            [containerView addSubview:self.thirdViewLevelController.view];
            [self addToCornerView:self.thirdViewLevelController.view];
            [containerView bringSubviewToFront:self.thirdViewLevelController.view];
            
            cornerView = self.thirdViewLevelController.view;
            
            for (NSLayoutConstraint *constraint in containerView.constraints) {
                if (constraint.secondItem == cornerView || constraint.firstItem == cornerView) {
                    [containerView removeConstraint:constraint];
                }
            }
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:cornerWidth/3.5]];
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:cornerHeight/3]];
            
            [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerHeight]];
            [cornerView addConstraint:[NSLayoutConstraint constraintWithItem:cornerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1.0 constant:cornerWidth]];
            cornerView.transform = CGAffineTransformMakeRotation(kCornerRotateAngleRad);
            [addedViews addObject:cornerView];
            
            // set content view as main view
            self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboard_content_view_vc_identifier];
            self.contentViewController.entity = [self.thirdViewLevelController entityForIndexPath:self.visiblePageIndex.thirdLevelIndexPath];
            self.contentViewController.entityName = thirdLevelEntityName;
            [self addChildViewController:self.contentViewController];
            [containerView insertSubview:self.contentViewController.view belowSubview:cornerView];
            [self setMainView:self.contentViewController.view];
            [addedViews addObject:self.contentViewController.view];
            [containerView layoutIfNeeded];
        }
    }
    
    
    if (animated) {
        NSMutableArray *finalAlphas = [[NSMutableArray alloc] initWithCapacity:addedViews.count];
        for (UIView *view in addedViews) {
            [finalAlphas addObject:@(view.alpha)];
            view.alpha = 0;
        }
        
        [UIView animateWithDuration:kAnimationTime animations:^{
            for (int i = 0; i < addedViews.count; i++) {
                UIView *view = addedViews[i];
                if (view.hidden) {
                    continue;
                }
                view.alpha = [finalAlphas[i] floatValue];
            }
            for (UIView *view in toBeRemovedViews) {
                if (view.hidden) {
                    continue;
                }
                view.alpha = 0;
            }
        } completion:^(BOOL finished) {
            for (UIView *view in toBeRemovedViews) {
                for (UIViewController *childVC in self.childViewControllers) {
                    if (childVC.view == view) {
                        [childVC removeFromParentViewController];
                        break;
                    }
                }
                [view removeFromSuperview];
            }
        }];
        
    } else {
        for (UIView *view in toBeRemovedViews) {
            for (UIViewController *childVC in self.childViewControllers) {
                if (childVC.view == view) {
                    [childVC removeFromParentViewController];
                    break;
                }
            }
            [view removeFromSuperview];
        }
    }
}

#pragma storyboard
-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    if ([identifier isEqualToString:unwind_segue_identifier] || [identifier isEqualToString:unwind_segue_identifier_second] || [identifier isEqualToString:unwind_segue_identifier_third]) {
        PWEFromCornerSegue *segue = [[PWEFromCornerSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
        if ([toViewController conformsToProtocol:@protocol(PWECornerSegueDelegate)]) {
            segue.delegate = (id<PWECornerSegueDelegate>)toViewController;
        }
        return segue;
    }
    return nil;
}

-(void)unwindCurrentView
{
    for (UIViewController *child in self.childViewControllers)
    {
        if (![_cornerViews containsObject:child.view])
        {
            if (![child isKindOfClass:[PWEContentViewController class]]) {
                [child performSegueWithIdentifier:unwind_segue_identifier sender:nil];
                child.view.transform = CGAffineTransformIdentity;
                return;
            }
            if ([_cornerViews firstObject] == self.secondViewLevelController.view) {
                
                [child performSegueWithIdentifier:unwind_segue_identifier_second sender:nil];
                child.view.transform = CGAffineTransformIdentity;
            } else {
                [child performSegueWithIdentifier:unwind_segue_identifier_third sender:nil];
                child.view.transform = CGAffineTransformIdentity;
            }
            return;
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:fast_navigation_segue_identifier]) {
        self.fastNavigationViewController = segue.destinationViewController;
        [self.fastNavigationViewController setInitialTopType:self.mainIconViewController.mainIcon.topType];
        
        UIView *parentView = self.parentViewController.parentViewController.view;
        [self.cornerViews[0] setHidden:YES];
        UIImageView *imageView = [PWECommonCommands getBlurredSnapshotOfView:parentView];
        [self.cornerViews[0] setHidden:NO];
        [self.fastNavigationViewController setBackgroundView:imageView];
    }
}
#pragma mark Fast Navigation
- (IBAction)handleLongPress:(id)sender {
    switch (self.fastNavigationLongPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginFastNavigation];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self endFastNavigation:self.fastNavigationLongPressGestureRecognizer];
            break;
        }
            
        default:
            break;
    }
    
}
- (IBAction)handlePan:(id)sender {
    switch (self.fastNavigationPanGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        {
            [self endFastNavigation:self.fastNavigationPanGestureRecognizer];
            break;
        }
        default:
        {
            CGPoint location = [self.fastNavigationPanGestureRecognizer locationInView:self.fastNavigationViewController.view];
            [self.fastNavigationViewController handleTouchAtPoint:location];
            break;
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.fastNavigationLongPressGestureRecognizer)
    {
        if (!self.cornerViews || self.cornerViews.count == 0 || self.inFastNavigation) {
            return NO;
        }
        UIView *topCornerView = self.cornerViews[0];
        CGPoint location = [gestureRecognizer locationInView:topCornerView];
        if ([topCornerView hitTest:location withEvent:nil]) {
            return YES;
        }
        return NO;
    }
    else if (gestureRecognizer == self.fastNavigationPanGestureRecognizer)
    {
        return self.inFastNavigation;
    }
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)beginFastNavigation
{
    if (self.inFastNavigation) {
        return;
    }
    self.inFastNavigation = YES;
    [self performSegueWithIdentifier:fast_navigation_segue_identifier sender:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFastNavigationDidBegin object:self];
}
- (void)endFastNavigation:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.inFastNavigation) {
        return;
    }
    if (self.fastNavigationViewController.willDisappear) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFastNavigationDidEnd object:self];
    __weak PWEViewController *wSelf = self;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = @0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:@[opacityAnimation]];
    animationGroup.duration = kFastNavigationAnimationTime;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.fastNavigationViewController.view.layer addAnimation:animationGroup forKey:@"end fast nav"];
    
    [self.fastNavigationViewController prepareForDisappearing];
    
    [NSTimer scheduledTimerWithTimeInterval:kFastNavigationAnimationTime target:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.inFastNavigation = NO;
            [wSelf.fastNavigationViewController willMoveToParentViewController:nil];
            [wSelf.fastNavigationViewController.view removeFromSuperview];
            [wSelf.fastNavigationViewController removeFromParentViewController];
        }];
        
    }selector:@selector(invoke) userInfo:nil repeats:NO];
    
    
    [self goToViewForIndex:self.fastNavigationViewController.selectedIndex animated:NO];
//    [UIView animateWithDuration:kAnimationTime animations:^{
//        [wSelf.fastNavigationViewController.view setAlpha:0];
//    } completion:^(BOOL finished) {
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [wSelf.fastNavigationViewController willMoveToParentViewController:nil];
//            [wSelf.fastNavigationViewController.view removeFromSuperview];
//            [wSelf.fastNavigationViewController removeFromParentViewController];
//        }];
//    }];
}
- (void)adjustForContentOffset:(CGFloat)offset withMaxDistance:(CGFloat)maxDist
{
    UIView *cornerView = [self.cornerViews firstObject];
    if (cornerView) {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-1 * offset/maxDist * self.view.bounds.size.width, 0);
        cornerView.transform = transform;
//        CALayer *layer = [CALayer layer];
//        layer.transform = CATransform3DMakeAffineTransform(transform);
//        [cornerView.layer addSublayer:layer];
    }
}
@end
