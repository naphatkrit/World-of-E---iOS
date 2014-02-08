//
//  PWEStandardHexagon.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/29/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEStandardHexagon.h"

@implementation PWEStandardHexagon

- (id)initWithFrame:(CGRect)frame withEdgeSize:(float)edgeSize ofType:(PWEHexagonType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.edgeSize = edgeSize;
        self.clipsToBounds = NO;
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
    
    NSArray *textArray = resources[@"Texts"];
    self.path = [PWECommonCommands drawHexagonWithContext:context at:CGPointMake(self.edgeSize, self.edgeSize*sqrtf(3.0)/2) withEdgeSize:self.edgeSize withColor:color withText:textArray[self.type-1] forView:self withDrawType:PWEHexagonDrawTypeNormal];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        if (CGPathContainsPoint(self.path.CGPath, NULL, [((UITouch *)(touches.allObjects)[0]) locationInView:self], true))
        {
            switch (self.type)
            {
                case PWEHexagonTypeLearn:
                    [self.classDelegate touchedLearn];
                    break;
                case PWEHexagonTypeDo:
                    [self.classDelegate touchedDo];
                    break;
                case PWEHexagonTypeConnect:
                    [self.classDelegate touchedConnect];
                    break;
                default:
                    break;
            }
        }
    }
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGPathContainsPoint(self.path.CGPath, NULL, point, true)) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}

@end
