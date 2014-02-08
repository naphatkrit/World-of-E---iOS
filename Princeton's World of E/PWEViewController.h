//
//  PWEViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PWEMainIcon.h"
#import "PWESecondLevelViewController.h"
#import "PWEThirdLevelViewController.h"
@class PWESecondLevelViewController, PWEBackground, PWEThirdLevelViewController, PWEContentViewController, PWEMainIconViewController, PWEMainBackgroundView, PWERestorationPointIndex;

@interface PWEViewController : UIViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>
//if actions happen during animations, it crashes
@property (weak, nonatomic) IBOutlet PWEMainBackgroundView *containerView;
@property (weak, nonatomic) IBOutlet UIToolbar *statusBar;
@property (nonatomic, assign)BOOL shouldFadeCornerView;
@property (nonatomic, strong) UIView *blackView;
@property (weak, nonatomic) IBOutlet PWEBackground *backgroundView;
@property (strong, nonatomic) NSMutableArray *cornerViews;
@property (weak, nonatomic) UIView *mainView;
@property (weak, nonatomic) PWEMainIconViewController *mainIconViewController;
@property (weak, nonatomic) PWESecondLevelViewController *secondViewLevelController;
@property (weak, nonatomic) PWEThirdLevelViewController *thirdViewLevelController;
@property (weak, nonatomic) PWEContentViewController *contentViewController;
@property (nonatomic, strong) PWERestorationPointIndex *visiblePageIndex;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) BOOL inFastNavigation;

-(void)fadeCornerView;
-(void)unfadeCornerView;
-(void)addToCornerView:(UIView *)view;
-(void)removeFromCornerView:(UIView *)view;
-(void)unwindCurrentView;
-(void)goToViewForIndex:(PWERestorationPointIndex *)visibleIndex animated:(BOOL)animated;
-(void)saveState;
-(void)restoreState;
- (void)adjustForContentOffset:(CGFloat)offset withMaxDistance:(CGFloat)maxDist;

// core data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
