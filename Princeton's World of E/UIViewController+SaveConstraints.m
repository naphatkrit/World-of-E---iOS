//
//  UIViewController+SaveConstraints.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "UIViewController+SaveConstraints.h"

@implementation UIViewController (SaveConstraints)
-(NSMutableDictionary *)dictionaryForSavingConstraint
{
    return nil;
}
- (void)saveConstraintsToDictionary;
{
    // save default constraints
    NSMutableDictionary *dictionary = self.dictionaryForSavingConstraint;
    dictionary[[NSNumber numberWithInt:self.view.hash]] = self.view.constraints;
    for (UIView *subviews in self.view.subviews) {
        dictionary[[NSNumber numberWithInt:subviews.hash]] = subviews.constraints;
    }
}
- (void)adjustConstraintsFromDictionary;
{
    NSMutableDictionary *dictionary = self.dictionaryForSavingConstraint;
    [self.view removeConstraints:self.view.constraints];
    [self.view addConstraints:dictionary[[NSNumber numberWithInt:self.view.hash]]];
    for (UIView *subview in self.view.subviews)
    {
        [subview removeConstraints:subview.constraints];
        [subview addConstraints:dictionary[[NSNumber numberWithInt:subview.hash]]];
    }
    
}
@end
