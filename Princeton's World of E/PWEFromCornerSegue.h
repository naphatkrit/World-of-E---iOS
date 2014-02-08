//
//  PWEFromCornerSegue.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/26/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWECornerSegueDelegate.h"

@interface PWEFromCornerSegue : UIStoryboardSegue

@property (nonatomic, weak) id<PWECornerSegueDelegate> delegate;

@end
