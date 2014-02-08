//
//  PWEGenericHexagon.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/30/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEGenericHexagon.h"

@implementation PWEGenericHexagon

- (id)initWithFrame:(CGRect)frame withEdgeSize:(float)edgeSize withText:(NSString *)text ofType:(PWEHexagonType)type invertColor:(BOOL)invertColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.text = text;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.edgeSize = edgeSize;
        self.clipsToBounds = NO;
        self.invertColor = invertColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
    NSDictionary *resources = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *colorArray = resources[@"Colors"][self.type-1];
    UIColor *color = [UIColor colorWithRed:[colorArray[0] floatValue]/255.0 green:[colorArray[1] floatValue]/255.0 blue:[colorArray[2] floatValue]/255.0 alpha:1.0];
    PWEHexagonDrawType drawType = PWEHexagonDrawTypeNormal;
    if (self.invertColor) {
        drawType = PWEHexagonDrawTypeInvertColor;
    }
    
    self.path = [PWECommonCommands drawHexagonWithContext:context at:CGPointMake(self.edgeSize, self.edgeSize*sqrtf(3.0)/2) withEdgeSize:self.edgeSize withColor:color withText:self.text forView:self withDrawType:drawType];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGPathContainsPoint(self.path.CGPath, NULL, point, true)) {
        return self;
    } else {
        return nil;
    }
}
@end
