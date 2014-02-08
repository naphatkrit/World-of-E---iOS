//
//  PWEStandardHexagon.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/29/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PWEStandardHexagonDelegate

-(void)touchedLearn;
-(void)touchedDo;
-(void)touchedConnect;

@end

@interface PWEStandardHexagon : UIView
@property (nonatomic, weak) IBOutlet id<PWEStandardHexagonDelegate>classDelegate;
@property PWEHexagonType type;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic) float edgeSize;

- (id)initWithFrame:(CGRect)frame withEdgeSize:(float)edgeSize ofType:(PWEHexagonType)type;
@end
