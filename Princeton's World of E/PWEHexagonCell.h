//
//  PWEHexagonCell.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 1/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PWEHexagonCell : UICollectionViewCell

@property PWEHexagonType type;
@property (nonatomic) BOOL isHeader;
@property (nonatomic) BOOL gotDescription;
@property (nonatomic) BOOL labelInvalidated;
@property (nonatomic, strong) NSTimer *fastNavigationTimer;



-(void)updateTextWithText:(NSString *)text;
-(void)updateDescriptionWithText:(NSString *)text;
@end
