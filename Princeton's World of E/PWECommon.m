//
//  PWECommon.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWECommon.h"
#import "UIImage+ImageEffects.h"

CGMutablePathRef drawHexagonPath(CGFloat edgeSize, CGPoint center)
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    //start at the left point on the top edge
    
    CGPathMoveToPoint(path, NULL, center.x - edgeSize/2, center.y-edgeSize * sqrtf(3)/2);
    for (int i = 0; i < 6; i++)
    {
        CGFloat x = edgeSize *cosf(i * 2.0 * M_PI / 6);
        CGFloat y = edgeSize *sinf(i * 2.0 * M_PI / 6);
        CGPoint currentPoint = CGPathGetCurrentPoint(path);
        CGPathAddLineToPoint(path, NULL, currentPoint.x + x, currentPoint.y + y);
    }
    return path;
}
CGMutablePathRef drawHexagonWithColor(CGContextRef context,CGPoint center, float edgeSize, CGColorRef color)
{
    CGContextSaveGState(context);
    CGMutablePathRef path = drawHexagonPath(edgeSize, center);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillPath(context);
    
    // border
    CGContextAddPath(context, path);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor);
    CGContextSetLineWidth(context, 0.4);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    return path;
}
CGMutablePathRef drawHexagonWithInvertedColor(CGContextRef context,CGPoint center, float edgeSize, CGColorRef color)
{
    CGContextSaveGState(context);
    CGMutablePathRef path = drawHexagonPath(edgeSize, center);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    // border
    CGContextAddPath(context, path);
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor);
    CGContextSetLineWidth(context, 0.4);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    return path;
}

#import "PWEStandardHexagon.h"
#import "PWEMainIcon.h"

@implementation PWECommonCommands


+ (UIBezierPath *)drawHexagonWithContext: (CGContextRef)context at:(CGPoint)center withEdgeSize:(float)edgeSize withColor:(UIColor *)color withText:(NSString *)textForHexagon forView:(UIView *)view withDrawType:(PWEHexagonDrawType)drawType
{    
    CGMutablePathRef path;
    UILabel *label = [[UILabel alloc]init];
    switch (drawType) {
        case PWEHexagonDrawTypeInvertColor:
            path = drawHexagonWithInvertedColor(context, center, edgeSize, color.CGColor);
            label.textColor = color;
            break;
            
        default:
            path = drawHexagonWithColor(context, center, edgeSize, color.CGColor);
            label.textColor = [UIColor whiteColor];
            break;
    }
    //hexagons
    
    
    //text
    
    label.textAlignment = NSTextAlignmentCenter;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:kFontName size:edgeSize * 1.0/2.0];
    
    label.text = textForHexagon;
    [view insertSubview:label atIndex:0];
    
    [label sizeToFit];
    
    label.frame = CGRectMake(center.x - label.frame.size.width/2, center.y - label.frame.size.height/2.5, label.frame.size.width, label.frame.size.height);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    return bezierPath;
}

+ (NSArray *)drawLearnDoConnectForView: (UIView *)view withContext: (CGContextRef)context
{
    view.backgroundColor = [UIColor clearColor];
    view.opaque = NO;
    
    CGPoint origin1;
    CGPoint correction1;
    
    float edgeSize;
    if (view.bounds.size.width < view.bounds.size.height) {
        //width shorter than height, icon will fit to width and center around height
        edgeSize = (view.bounds.size.width-2.0)/3.5;
        origin1 = CGPointMake(0, (view.bounds.size.height - edgeSize*sqrtf(3.0)*2.0 - 2.0)/2);
        correction1 = CGPointMake(edgeSize, (view.bounds.size.height - edgeSize*sqrtf(3.0)*2.0 - 2.0)/2 + edgeSize*sqrtf(3.0)/2);
    } else {
        //height shorter than width, icon will fit to height and center around width
        edgeSize = (view.bounds.size.height-2.0)/(sqrtf(3.0)*2);
        origin1  = CGPointMake( (view.bounds.size.width - 3.5*edgeSize - 2.0)/2, 0);
        correction1 = CGPointMake(edgeSize+(view.bounds.size.width - 3.5*edgeSize - 2.0)/2, edgeSize*sqrtf(3.0)/2);
    }
    CGPoint origin2 = CGPointMake(origin1.x, origin1.y + sqrtf(3)*edgeSize+2.0);
    CGPoint origin3 = CGPointMake(origin1.x + 1.5*edgeSize+2.0, origin1.y + sqrtf(3)/2.0*edgeSize+1.0);
    CGPoint correction2 = CGPointMake(correction1.x, correction1.y + sqrtf(3)*edgeSize+2.0);
    CGPoint correction3 = CGPointMake(correction1.x + 1.5*edgeSize+2.0, correction1.y + sqrtf(3)/2.0*edgeSize+1.0);
    
    PWEStandardHexagon *learnHexagon = [[PWEStandardHexagon alloc] initWithFrame:CGRectMake(origin1.x, origin1.y, edgeSize*2, edgeSize*sqrtf(3.0)) withEdgeSize:edgeSize ofType:PWEHexagonTypeLearn];
    PWEStandardHexagon *doHexagon = [[PWEStandardHexagon alloc] initWithFrame:CGRectMake(origin2.x, origin2.y, edgeSize*2, edgeSize*sqrtf(3.0)) withEdgeSize:edgeSize ofType:PWEHexagonTypeDo];
    PWEStandardHexagon *connectHexagon = [[PWEStandardHexagon alloc] initWithFrame:CGRectMake(origin3.x, origin3.y, edgeSize*2, edgeSize*sqrtf(3.0)) withEdgeSize:edgeSize ofType:PWEHexagonTypeConnect];
    [view addSubview:learnHexagon];
    [view addSubview:doHexagon];
    [view addSubview:connectHexagon];
    NSArray *array = @[[NSValue valueWithCGPoint:correction1], [NSValue valueWithCGPoint:correction2], [NSValue valueWithCGPoint:correction3]];
    return array;
}
+ (UIImageView *)getBlurredSnapshotOfView:(UIView *)view;
{
    UIGraphicsBeginImageContext(view.bounds.size);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIColor *color = [UIColor colorWithWhite:0 alpha:0.85];
//    image = [image applyBlurWithRadius:20 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
    image = [image applyDarkEffect];
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
    
    
}

@end