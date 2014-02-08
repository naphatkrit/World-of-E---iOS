//
//  PWECornerSegueDelegate.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PWECornerSegueDelegate <NSObject>
- (void)animationWillBegin;
- (void)animationDidComplete;
@end
