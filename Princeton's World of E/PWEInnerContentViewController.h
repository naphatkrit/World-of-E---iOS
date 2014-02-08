//
//  PWEInnerContentViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Third_Lev_Object.h"

@interface PWEInnerContentViewController : UIViewController

@property (nonatomic, assign) BOOL noScrollInset;
@property (weak, nonatomic) Third_Lev_Object *entity;

+ (Class)getSubClassForEntity:(NSString *)entityName;

- (id)initWithEntity:(Third_Lev_Object *)entity;
- (void)adjustHeightForOrientation:(UIInterfaceOrientation)orientation;

@end
