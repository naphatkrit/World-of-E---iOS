//
//  PWEBackground.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEBackground.h"

@implementation PWEBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
void MyDrawPattern (void *info, CGContextRef context){
    CGFloat edgeSize = kBackgroundHexagonEdgeSize;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSaveGState(context);
    UIColor *blackColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, edgeSize/2.0, 0);
    CGPathAddLineToPoint(path, NULL, edgeSize, edgeSize*sqrtf(3.0)/2.0);
    CGPathAddLineToPoint(path, NULL, edgeSize/2.0, edgeSize*sqrtf(3.0));
    
    CGPathMoveToPoint(path, NULL, edgeSize, edgeSize*sqrtf(3.0)/2.0);
    CGPathAddLineToPoint(path, NULL, edgeSize*2.0, edgeSize*sqrtf(3.0)/2.0);
    
    CGPathMoveToPoint(path, NULL, edgeSize*3.0, 0);
    CGPathAddLineToPoint(path, NULL, edgeSize*2.5, 0);
    CGPathAddLineToPoint(path, NULL, edgeSize*2.0, edgeSize*sqrtf(3.0)/2.0);
    CGPathAddLineToPoint(path, NULL, edgeSize*2.5, edgeSize*sqrtf(3.0));
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    CGContextRestoreGState(context);
}
- (void)setNeedsDisplay
{
    if (!CGRectIsEmpty(self.drawnBounds) && CGRectEqualToRect(self.drawnBounds, self.bounds)) {
        return;
    }
    [super setNeedsDisplay];
    self.drawnBounds = self.bounds;
}
- (void)drawRect:(CGRect)rect
{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    static const CGPatternCallbacks callbacks = {0, &MyDrawPattern, NULL};
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL, rect, CGAffineTransformIdentity, kBackgroundHexagonEdgeSize*3.0, kBackgroundHexagonEdgeSize * sqrtf(3.0), kCGPatternTilingConstantSpacing, true, &callbacks);
    
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, self.bounds);
    CGContextRestoreGState(context);
    
}
- (void)layoutSubviews
{
    [self setNeedsDisplay];
}


@end
