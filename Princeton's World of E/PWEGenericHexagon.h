//
//  PWEGenericHexagon.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/30/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWEGenericHexagon : UIView

@property PWEHexagonType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) UIBezierPath *path;
@property (nonatomic) float edgeSize;
@property (nonatomic) BOOL invertColor;

- (id)initWithFrame:(CGRect)frame withEdgeSize:(float)edgeSize withText:(NSString *)text ofType:(PWEHexagonType)type invertColor:(BOOL)invertColor;
@end
