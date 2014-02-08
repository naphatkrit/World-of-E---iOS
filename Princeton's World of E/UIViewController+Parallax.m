//
//  UIViewController+Parallax.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/24/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "UIViewController+Parallax.h"

@implementation UIViewController (Parallax)

- (void)addParallaxEffectToView:(UIView *)view withDepth:(int) depth
{
    if (![UIMotionEffect class]) return;
    float SCALE = kParallaxScale;
    float xSCALE = kParallaxXScale;
    float rotSCALE = kParallaxRotScale;
    for (UIMotionEffect *effects in view.motionEffects)
    {
        [view removeMotionEffect:effects];
    }
    if (depth == 0) return;
    
//    UIInterpolatingMotionEffect *xRot = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.transform" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//    
//    int sign = cSignInt(depth);
//    xRot.minimumRelativeValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-1 * sign * xSCALE * rotSCALE, 0, 1, 0)];
//    xRot.maximumRelativeValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1 * sign * xSCALE * rotSCALE, 0, 1, 0)];
//    
//    UIInterpolatingMotionEffect *yRot = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.transform" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//    yRot.minimumRelativeValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-1 * sign * rotSCALE, 1, 0, 0)];
//    yRot.maximumRelativeValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1 * sign * rotSCALE, 1, 0, 0)];
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(xSCALE * SCALE * depth);
    xAxis.maximumRelativeValue = @(-1 * xSCALE* SCALE * depth);
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(SCALE * depth);
    yAxis.maximumRelativeValue = @(-1 * SCALE * depth);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    [view addMotionEffect:group];
    view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, 0, -1 * depth * 100);
}

@end
