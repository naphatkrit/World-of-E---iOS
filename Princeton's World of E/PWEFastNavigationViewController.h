//
//  PWEFastNavigationViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/19/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEMainIcon.h"
@class PWERestorationPointIndex;
@interface PWEFastNavigationViewController : UIViewController<PWEStandardHexagonDelegate>
@property (nonatomic, readonly) PWERestorationPointIndex *selectedIndex;
@property (nonatomic) BOOL willDisappear;
@property (nonatomic) PWEHexagonType initialTopType;
@property (nonatomic, strong) UIView *backgroundView;
- (void)handleTouchAtPoint:(CGPoint)point;
- (void)prepareForDisappearing;
@end
