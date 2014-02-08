//
//  PWERootViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/24/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PWERootViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate>
- (void)saveState;
@end
