//
//  PWEContentViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 3/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Third_Lev_Object.h"
#import <QuartzCore/QuartzCore.h>

@interface PWEContentViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (nonatomic, strong) NSString *entityName;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIView *contentViewInner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic, strong) Third_Lev_Object *entity;
@property (nonatomic, assign) BOOL shouldAnimateIn;
-(void)animateIn;

@end