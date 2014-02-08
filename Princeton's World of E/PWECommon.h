//
//  PWECommon.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/27/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ROOT_VIEW_CONTROLLER_NIB (IS_IPAD() ? @"PWERootViewController_iPad" : @"PWERootViewController")
#define MAIN_STORYBOARD (IS_IPAD() ? @"Main_iPad" : @"Main_iPhone")
#define INTER_PAGE_SPACING 30.0

#define kAnimationTime 0.3
#define kFastNavigationAnimationTime 0.2
#define kCornerViewAlphaValue 0.1
#define kCornerViewHeightiPad 400 /*300*/
#define kCornerViewHeightiPhone 180
#define kCornerRotateAngleRad 0
#define kBackgroundHexagonEdgeSize (IS_IPAD() ? 30.0 : 20.0)
#define kShadowOpacity 0.7
#define kContentFontSizePhone 18
#define kContentFontSizePad 20
#define kParallaxScale 18
#define kParallaxRotScale 0.6
#define kParallaxBGDepth 2
#define kParallaxMainDepth 0
#define kParallaxCornerDepth -1
#define kParallaxXScale ([[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] bounds].size.height) /*0.3*/
#define kTintColor [UIColor redColor]
#define kTintHighlightedColor [UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1.0]
#define kFontName @"isocpeur"
#define kFontNameBody @"QuattrocentoSans"
#define kNotificationSegueFrom @"from segue ended"
#define kNotificationKeyForView @"view"
#define kNotificationWillChangeOrientation @"willChangeOrientation"
#define kNotificationDidChangeOrientation @"didChangeOrientation"
#define kNotificationFastNavigationDidBegin @"fast navigation begin"
#define kNotificationFastNavigationDidEnd @"fast navgiation end"
#define kNotificationNewPage @"go to new page"
#define kPageIndexKey @"page index"

#define kMaxPages 4

#define unwind_segue_identifier @"unwind"
#define unwind_segue_identifier_second @"unwind to second"
#define unwind_segue_identifier_third @"unwind to third"
#define fast_navigation_segue_identifier @"fast navigation segue"
#define fast_navigation_embed_segue_identifier @"embed second level fast navigation"
#define storyboard_main_icon_vc_identifier @"Main Icon"
#define storyboard_second_level_vc_identifier @"Second Level"
#define storyboard_third_level_vc_identifier @"Third Level"
#define storyboard_content_view_vc_identifier @"Content View"

#define URL_JSON @"http://worldofe.org/data"

#define cCornerDims(cornerWidth, cornerHeight) if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) { cornerHeight = kCornerViewHeightiPad; cornerWidth = floor(680.0/716.0 * cornerHeight); }else { cornerHeight = kCornerViewHeightiPhone; cornerWidth = floor(280.0/314.0 * cornerHeight);}
#define cDims(viewController, width, height) if (UIInterfaceOrientationIsPortrait(viewController.interfaceOrientation)) { width = viewController.view.frame.size.width; height = viewController.view.frame.size.height; } else { width = viewController.view.frame.size.height; height = viewController.view.frame.size.width;}
#define cSignInt(number) ((number > 0) ? 1 : -1)

typedef enum: uint8_t {
    PWEHexagonDrawTypeNormal = 1,
    PWEHexagonDrawTypeInvertColor
} PWEHexagonDrawType;

typedef enum: uint8_t {
    PWEHexagonTypeNone = 0,
    PWEHexagonTypeLearn,
    PWEHexagonTypeDo,
    PWEHexagonTypeConnect
} PWEHexagonType;


@class PWEMainIcon;

static NSString * const PWEHexagonCellKind = @"HexagonCell";

CGMutablePathRef drawHexagonPath(CGFloat polySize, CGPoint center);
CGMutablePathRef drawHexagonWithColor(CGContextRef context,CGPoint center, float edgeSize, CGColorRef color);


@interface PWECommonCommands : NSObject
+ (NSArray *)drawLearnDoConnectForView: (UIView *)view withContext: (CGContextRef)context;
+ (UIBezierPath *)drawHexagonWithContext: (CGContextRef)context at:(CGPoint)center withEdgeSize:(float)edgeSize withColor:(UIColor *)color withText:(NSString *)textForHexagon forView:(UIView *)view withDrawType:(PWEHexagonDrawType)drawType;
+ (UIImageView *)getBlurredSnapshotOfView:(UIView *)view;

@end