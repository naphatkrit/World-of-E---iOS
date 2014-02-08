//
//  PWEMainIcon.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PWEStandardHexagon.h"

@interface PWEMainIcon : UIView
@property PWEHexagonType topType;
@property BOOL folded;
@property BOOL inFastNavigation;
@property BOOL animating;
@property (nonatomic, weak) IBOutlet id<PWEStandardHexagonDelegate>standardHexagonDelegate;
@property (nonatomic, strong) NSTimer *fastNavigationTimer;
@property (nonatomic) CGPoint distanceFromCenter;
@property (nonatomic) NSArray *origins;

//this value will be assigned by the parentviewcontroller
@property (nonatomic) CGSize originalSize;

-(void)foldIconToHexagonType:(PWEHexagonType)type;
@end
