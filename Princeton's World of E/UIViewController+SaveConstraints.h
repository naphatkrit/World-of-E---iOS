//
//  UIViewController+SaveConstraints.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SaveConstraints)

- (NSMutableDictionary *)dictionaryForSavingConstraint;
- (void)saveConstraintsToDictionary;
- (void)adjustConstraintsFromDictionary;

@end
