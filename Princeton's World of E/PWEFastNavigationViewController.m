//
//  PWEFastNavigationViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/19/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEFastNavigationViewController.h"
#import "PWESecondLevelViewController.h"
#import "PWEGenericHexagon.h"
#import "PWEHexagonCell.h"
#import "PWERestorationPointIndex.h"

@interface PWEFastNavigationViewController ()

@property (nonatomic, weak) PWESecondLevelViewController *secondLevelViewController;
@property (weak, nonatomic) IBOutlet PWEMainIcon *mainIcon;
@property (nonatomic, strong) NSArray *notificationObservers;
@property (nonatomic, strong, readwrite) PWERestorationPointIndex *selectedIndex;

@end

@implementation PWEFastNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setBackgroundView:(UIView *)backgroundView
{
    if (self.view) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self.view insertSubview:_backgroundView atIndex:0];
    } else {
        _backgroundView = backgroundView;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view insertSubview:self.backgroundView atIndex:0];
    
    [self.mainIcon setFolded:YES];
    self.initialTopType = 0 ? PWEHexagonTypeLearn : self.initialTopType;
    [self.mainIcon setTopType:self.initialTopType];
    self.selectedIndex = [[PWERestorationPointIndex alloc] init];
//    [self.mainIcon setHidden:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.notificationObservers = @[];
   
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.mainIcon foldIconToHexagonType:nil];
    CGFloat cornerWidth, cornerHeight;
    cCornerDims(cornerWidth, cornerHeight);
    self.mainIcon.frame = CGRectMake(self.view.bounds.size.width + cornerWidth/3.5 - self.mainIcon.bounds.size.width, self.view.bounds.size.height + cornerHeight/3.0 - self.mainIcon.bounds.size.height, self.mainIcon.frame.size.width, self.mainIcon.frame.size.height);
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.mainIcon layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
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
    if ([segue.identifier isEqualToString:fast_navigation_embed_segue_identifier]) {
        self.secondLevelViewController = segue.destinationViewController;
    }
}

- (void)handleTouchAtPoint:(CGPoint)point
{
    CGPoint pointInMainIcon = CGPointMake(point.x - self.mainIcon.frame.origin.x, point.y - self.mainIcon.frame.origin.y);
    UIView *view = [self.mainIcon hitTest:pointInMainIcon withEvent:nil];
    if ([view isKindOfClass:[PWEStandardHexagon class]]) {
        PWEHexagonType type = [(PWEStandardHexagon *)view type];
        [self.secondLevelViewController setCellType:type];
        self.selectedIndex.hexagonType = type;
        return;
    }
    NSIndexPath *index = [self.secondLevelViewController.collectionView indexPathForItemAtPoint:point];
    if (index) {
        self.selectedIndex.secondLevelIndexPath = index;
        self.selectedIndex.hexagonType = self.secondLevelViewController.cellType;
        return;
    }
    self.selectedIndex.hexagonType = PWEHexagonTypeNone;
    self.selectedIndex.secondLevelIndexPath = nil;
}
- (void)prepareForDisappearing
{
    if (self.selectedIndex && !self.willDisappear) {
        self.willDisappear = YES;
        [self.mainIcon foldIconToHexagonType: self.selectedIndex.hexagonType];
        
        CGFloat cornerWidth, cornerHeight;
        cCornerDims(cornerWidth, cornerHeight);
       
        [UIView animateWithDuration:kAnimationTime/1.5 animations:^{
             self.mainIcon.frame = CGRectMake(self.view.bounds.size.width + cornerWidth/3.5 - self.mainIcon.bounds.size.width, self.view.bounds.size.height + cornerHeight/3.0 - self.mainIcon.bounds.size.height, self.mainIcon.frame.size.width, self.mainIcon.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark Standard Hexagon Delegate
- (void)touchedLearn
{
    
}
- (void)touchedDo
{
    
}
- (void)touchedConnect
{
    
}

@end
