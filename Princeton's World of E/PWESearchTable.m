//
//  PWESearchTable.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 4/8/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWESearchTable.h"

@implementation PWESearchTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.searchTableDelegate tableTouched];
    
}

@end
