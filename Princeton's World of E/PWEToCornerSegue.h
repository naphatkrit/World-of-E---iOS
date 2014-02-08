//
//  PWEToCornerSegue.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PWECornerSegueDelegate.h"

@interface PWEToCornerSegue : UIStoryboardSegue

@property (nonatomic, weak) id<PWECornerSegueDelegate> delegate;

@end
