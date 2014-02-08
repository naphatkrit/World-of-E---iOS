//
//  PWEHexagonCell.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEHexagonCell.h"
#import "PWEGenericHexagon.h"
#import "PWEMainIcon.h"

@implementation PWEHexagonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setMultipleTouchEnabled:NO];
    }
    return self;
}
- (void)setGotDescription:(BOOL)gotDescription
{
    if (_gotDescription != gotDescription) {
        _gotDescription = gotDescription;
        _labelInvalidated = YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    
    // copy over the text, if exists
    for (UIView *subviews in self.subviews) {
        NSString *text;
        BOOL label = NO;
        if ([subviews isMemberOfClass:[UILabel class]]) {
            label = YES;
            text = ((UILabel*)subviews).text;
        } else if ([subviews isMemberOfClass:[UITextView class]] && self.gotDescription == YES) {
            text = ((UITextView *)subviews).text;
        }
        [subviews setHidden:YES];
        [subviews removeFromSuperview];
        if (text != nil) {
            if (label == YES) {
                [self updateTextWithText:text];
            } else {
                [self updateDescriptionWithText:text];
            }
        }
        text = nil;
    }
    
    //draw hexagon
    if (self.type == PWEHexagonTypeLearn || self.type == PWEHexagonTypeDo || self.type == PWEHexagonTypeConnect) {
        CGFloat edgeSize = self.bounds.size.width/2;
        
        PWEGenericHexagon *hexagon = [[PWEGenericHexagon alloc] initWithFrame:self.bounds withEdgeSize:edgeSize withText:nil ofType:self.type invertColor:self.isHeader];
        [self insertSubview:hexagon atIndex:0];

    }
    
    
    //draw shadow
    [self.layer removeAllAnimations];
//    if (self.gotSelected == YES) {
////        UIColor *shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
//        UIColor *redColor = kTintColor;
//        
//        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        CGMutablePathRef path = drawHexagonPath(self.bounds.size.width/2, center);
//        self.layer.shadowColor = redColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = kShadowOpacity;
//        self.layer.shadowRadius = 10.0;
//        self.layer.shadowPath = path;
//        
//        CGPathRelease(path);
//    } else if (self.inFastNavigation == YES){
//        [self.layer setShadowOpacity:0.0];
//    }
//    else if (self.gotDescription == YES) {
//        [self.layer setShadowOpacity:0.0];
//    }
//    else
//    {
//        [self.layer setShadowOpacity:0.0];
////        [self.layer setShadowOpacity:0.0];
////        UIColor *white = [UIColor whiteColor];
////        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
////        //adjust radius here
////        CGMutablePathRef path = drawHexagonPath(self.bounds.size.width/1.8, center);
////        self.layer.shadowColor = white.CGColor;
////        self.layer.shadowOffset = CGSizeMake(0, 0);
////        self.layer.shadowOpacity = kShadowOpacity;
////        self.layer.shadowRadius = 15.0;
////        self.layer.shadowPath = path;
////        self.layer.shouldRasterize = YES;
////        
////        CGPathRelease(path);
//    }
    
}
- (void)updateTextWithText:(NSString *)text{
    
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    CGFloat width;
    CGFloat height;
    
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    CGFloat edgeSize = width/2;
    
    UILabel *label = [[UILabel alloc]init];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    if (self.isHeader) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"plist"];
        NSDictionary *resources = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSArray *colorArray = resources[@"Colors"][self.type-1];
        UIColor *color = [UIColor colorWithRed:[colorArray[0] floatValue]/255.0 green:[colorArray[1] floatValue]/255.0 blue:[colorArray[2] floatValue]/255.0 alpha:1.0];
        label.textColor = color;
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    label.text = text;
    [self addSubview:label];
    
    
    if (self.gotDescription == YES) {
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:kFontName size:edgeSize * 1.0/3.8];
        [label sizeToFit];
        label.frame = CGRectMake(width/4.0, label.bounds.size.height/1.2, label.frame.size.width, label.frame.size.height);
        
    } else {
        label.textAlignment = NSTextAlignmentCenter;
//        CGFloat fontSizeScale;
//        if ([text length] > 17) {
//            // break line accordingly
//            // this code doesn't take into account extra spaces and line break characters
//            fontSizeScale = 0.5/2.0;
////            NSScanner *scanner = [NSScanner scannerWithString:text];
////            NSMutableString *newString = [[NSMutableString alloc] init];
////            int numLines = 0;
////            while (scanner.isAtEnd == NO) {
////                numLines++;
////                
////                NSMutableString *tempString = [[NSMutableString alloc]init];
////                while (scanner.scanLocation<(10+newString.length)) {
////                    
////                    NSString *newString1;
////                    [scanner scanUpToString:@" " intoString:&newString1];
////                    
////                    [tempString appendString:newString1];
////                    [tempString appendString:@" "];
////                }
////                [newString appendString:tempString];
////                if (scanner.isAtEnd == NO) {
////                    [newString appendString:@"\n"];
////                }
////                if (numLines > 5) {
////                    
////                    abort();
////                }
////            }
////            text = [NSString stringWithFormat:@"%@",newString];
////            [label setNumberOfLines:numLines];
////            label.text = text;
//        }
//        else if ([text length] > 15)
//        {
//            fontSizeScale = 0.5/2.0;
//        }
//        else if ([text length] > 11) {
//            fontSizeScale = 0.6/2.0;
//        } else {
//            fontSizeScale = 0.7/2.0;
//        }
//        if (self.isHeader) {
//            fontSizeScale *= 1.3;
//        }
//        fontSizeScale = 1;
        label.numberOfLines = 3;
        label.font = [UIFont fontWithName:kFontName size:edgeSize * 0.4];
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        [label sizeToFit];
//        CGFloat labelWidth = MIN(label.intrinsicContentSize.width, edgeSize * 1.8);
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        CGFloat sidePadding = edgeSize * 0.1;
        label.frame = CGRectMake(sidePadding, height/2 - label.intrinsicContentSize.height/2.0, width - 2 * sidePadding, label.intrinsicContentSize.height);
//        label.backgroundColor = [UIColor redColor];
//        [label sizeToFit];
    }
}
- (void)updateDescriptionWithText:(NSString *)text {
    CGFloat width;
    CGFloat height;
    UITextView *descriptionView;
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UITextView class]]) {
            descriptionView = (UITextView*)subview;
            [descriptionView setText:text];
            
            return;
        }
    }
    if (!descriptionView) {
        width = self.bounds.size.width;
        height = width/2.0 * sqrtf(3.0);
        CGFloat scaleHeight = 0.9;
        UILabel *label = (UILabel *)[self.subviews lastObject];
        UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(width*scaleHeight/4.0, height*(0.5-scaleHeight/2.0+scaleHeight/50.0) + label.bounds.size.height*2, width *(1.0-scaleHeight/2.0), width*scaleHeight*49.0/50.0)];
        [descriptionView setUserInteractionEnabled:NO];
        [descriptionView setBackgroundColor:[UIColor clearColor]];
        [descriptionView setFont:[UIFont fontWithName:kFontName size:width/2.0 * 1.0/6.0]];
        [descriptionView setTextColor:[UIColor whiteColor]];
        [descriptionView setText:text];
        [descriptionView setContentInset:UIEdgeInsetsMake(0, -1 * descriptionView.bounds.size.width*0.04, 0, 0)];
        [self addSubview:descriptionView];
    }
    
    
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL touched = NO;
    if (self.subviews.count == 0) {
        return [super hitTest:point withEvent:event];
    }
    PWEGenericHexagon *hexagon = (self.subviews)[0];
    CGPoint pointBounds = CGPointMake(point.x-hexagon.frame.origin.x, point.y - hexagon.frame.origin.y);
    if (CGPathContainsPoint(hexagon.path.CGPath, NULL, pointBounds, true)) {
        touched = YES;
    }
    if (touched == YES) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}
@end
