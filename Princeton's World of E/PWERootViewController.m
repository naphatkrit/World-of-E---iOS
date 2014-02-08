//
//  PWERootViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/24/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWERootViewController.h"
#import "PWEViewController.h"
#import "PWEBackground.h"
#import "UIViewController+Parallax.h"
#import "PWERestorationPointIndex.h"

#import "PWEMainIconViewController.h"

@interface PWERootViewController ()

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *restorationIndices;
@property (weak, nonatomic) IBOutlet PWEBackground *backgroundView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL reportScrolling;
- (NSString *)filePath;

- (void)instantiateRestorationIndices;
- (void)updateScrollViewTransitionAnimation:(UIScrollView *)scrollView;
@end

@implementation PWERootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reportScrolling = YES;
    [self setWantsFullScreenLayout:YES];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self instantiateRestorationIndices];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(INTER_PAGE_SPACING)}];
    
    PWEViewController *currentViewController = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    if ([self.restorationIndices firstObject]) {
        currentViewController.visiblePageIndex = self.restorationIndices.firstObject;
    } else {
    }
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pageViewController setViewControllers:@[currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.view insertSubview:self.pageViewController.view aboveSubview:self.backgroundView];
    [self addChildViewController:self.pageViewController];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.pageViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.pageViewController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.pageViewController.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pageViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.pageViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    
    for (UIView *subview in self.pageViewController.view.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView *)subview;
            self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
            self.scrollView.delegate = self;
            break;
        }
    }
    [self addParallaxEffectToView:self.backgroundView withDepth:kParallaxBGDepth];
    
    
    currentViewController.pageIndex = 0;
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationFastNavigationDidBegin object:Nil queue:nil usingBlock:^(NSNotification *note) {
        [self.scrollView setScrollEnabled:NO];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationFastNavigationDidEnd object:Nil queue:nil usingBlock:^(NSNotification *note) {
        [self.scrollView setScrollEnabled:YES];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationNewPage object:Nil queue:nil usingBlock:^(NSNotification *note) {
        PWERestorationPointIndex *index = note.userInfo[kPageIndexKey];
        PWEViewController *viewController = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        int pageIndex = [[self.pageViewController.viewControllers lastObject] pageIndex];
        if (pageIndex < (self.restorationIndices.count - 1) && [index isEqual:self.restorationIndices[pageIndex + 1]])
        {
            pageIndex++;
        }
        else if (pageIndex >= 1 && [index isEqual:self.restorationIndices[pageIndex - 1]])
        {
            pageIndex--;
            [viewController setPageIndex:pageIndex];
            [viewController setVisiblePageIndex:index];
            [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                
            }];
            return;
        } else {
            if (pageIndex < kMaxPages) {
                pageIndex++;
                [self.restorationIndices insertObject:index atIndex:pageIndex];
                while (self.restorationIndices.count > kMaxPages + 1) {
                    [self.restorationIndices removeLastObject];
                }
                
            } else {
                [[self.pageViewController.viewControllers lastObject] setPageIndex:pageIndex - 1];
                [self.restorationIndices addObject:index];
                [self.restorationIndices removeObjectAtIndex:0];
            }
        }
        
        
        [viewController setPageIndex:pageIndex];
        [viewController setVisiblePageIndex:index];
        
        [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)updateScrollViewTransitionAnimation:(UIScrollView *)scrollView
{
    CGFloat center = scrollView.contentOffset.x + scrollView.bounds.size.width/2.0;
    CGFloat maxDist = scrollView.bounds.size.width/2;
    for (UIView *subview in scrollView.subviews) {
        // calculate distance from center
        CGFloat location = subview.frame.origin.x + subview.bounds.size.width/2.0;
        CGFloat dist = center - location;
//        CGFloat distAbs = ABS(dist);
//        subview.alpha = 1.0 - MIN(distAbs/maxDist, 1.0);
        for (PWEViewController *vc in self.pageViewController.childViewControllers) {
            if (vc.view.superview == subview) {
                [vc adjustForContentOffset:dist withMaxDistance:maxDist];
                break;
            }
        }
    }
//    for (UIViewController *vc in self.pageViewController.viewControllers) {
//        UIView *subview = vc.view.superview;
//        CGFloat location = subview.frame.origin.x + subview.bounds.size.width/2.0;
//        CGFloat dist = center - location;
//        CGFloat distAbs = ABS(dist);
//        subview.alpha = 1.0 - MIN(distAbs/maxDist, 1.0);
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [self updateScrollViewTransitionAnimation:self.scrollView];
    
//    PWEViewController *viewController = self.pageViewController.viewControllers[0];
    
    
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
//    UIGraphicsBeginImageContextWithOptions(_backgroundView.bounds.size, YES, 2.0);
//    [_backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    NSData *data = UIImagePNGRepresentation(viewImage);
//    
//    [picker addAttachmentData:data  mimeType:@"image/png" fileName:@"main hexagon"];
//    
//    [picker addAttachmentData:data mimeType:nil fileName:nil];
//    
//    
//    // Show email view
//    [self presentViewController:picker animated:YES completion:nil];
}
- (void)instantiateRestorationIndices
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        self.restorationIndices = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
        return;
    }
    self.restorationIndices = [[NSMutableArray alloc] initWithCapacity:kMaxPages];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int currentIndex = [(PWEViewController *)viewController pageIndex];
    if (currentIndex >= kMaxPages) {
        return nil;
    }
    PWEViewController *toBeReturned = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [toBeReturned setPageIndex:(currentIndex + 1)];
    
    if (toBeReturned.pageIndex < self.restorationIndices.count) {
        [toBeReturned setVisiblePageIndex:self.restorationIndices[toBeReturned.pageIndex]];
    }
    
    return toBeReturned;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int currentIndex = [(PWEViewController *)viewController pageIndex];
    if (currentIndex <= 0) {
        return nil;
    }
    PWEViewController *toBeReturned = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    [toBeReturned setPageIndex:(currentIndex - 1)];
    
    if (toBeReturned.pageIndex < self.restorationIndices.count) {
        PWERestorationPointIndex *index = self.restorationIndices[toBeReturned.pageIndex];
        if (index) {
            [toBeReturned setVisiblePageIndex:index];
        }
        
    }
    
    return toBeReturned;
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for (PWEViewController *viewController in pendingViewControllers) {
        [viewController setShouldFadeCornerView:NO];
    }
    for (PWEViewController *viewController in pageViewController.childViewControllers) {
        [viewController setShouldFadeCornerView:NO];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
//    if (completed) {
    for (PWEViewController *viewController in previousViewControllers) {
        if (viewController.visiblePageIndex) {
            self.restorationIndices[viewController.pageIndex] = viewController.visiblePageIndex;
        }
    }
    for (PWEViewController *viewController in pageViewController.childViewControllers) {
        [viewController setShouldFadeCornerView:YES];
    }
//    }
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWillChangeOrientation object:self userInfo:@{@"orientation": [NSNumber numberWithInt: toInterfaceOrientation]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
    self.reportScrolling = NO;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidChangeOrientation object:self userInfo:@{@"orientation": [NSNumber numberWithInt: self.interfaceOrientation]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollStop" object:nil];
    self.reportScrolling = YES;
}
- (BOOL)shouldAutorotate
{
    PWEViewController *viewController = self.pageViewController.viewControllers.lastObject;
    return !viewController.inFastNavigation;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)filePath
{
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [libraryDir stringByAppendingString:@"/restoration_index.res"];
    return filePath;
}
-(void)saveState
{
    for (PWEViewController *viewController in self.pageViewController.viewControllers) {
        if (viewController.visiblePageIndex) {
            self.restorationIndices[viewController.pageIndex] = viewController.visiblePageIndex;
        }
    }
    [NSKeyedArchiver archiveRootObject:self.restorationIndices toFile:self.filePath];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.reportScrolling) {
        return;
    }
    [self updateScrollViewTransitionAnimation:scrollView];
}

@end
